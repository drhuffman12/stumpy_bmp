require "./../../../spec_helper"

Spectator.describe StumpyBMP::FileReader do
  context "when file_path given (and it is a valid bmp file)" do
    # when given a valid bmp file...
    let(file_path) { "spec/stumpy_bmp/examples/example0/image.bmp" }
    let(file_data) { StumpyBMP::FileData.new(file_path) }
    let(file_reader) { StumpyBMP::FileReader.new(file_data) }

    let(temp_file_name) { "test_image.bmp" }
    let(temp_file_path) { File.tempname(temp_file_name) }

    let(file_writer) { StumpyBMP::FileWriter.new(file_reader.file_data) }
    let(overwrite) { false }

    # we expect...
    let(file_size_expected) { 138 }
    let(file_bytes_expected) {
      [
        66, 77, 138, 0, 0,
        0, 0, 0, 0, 0,
        122, 0, 0, 0, 108,
        0, 0, 0, 2, 0,
        0, 0, 2, 0, 0,
        0, 1, 0, 24, 0,
        0, 0, 0, 0, 16,
        0, 0, 0, 202, 153,
        0, 0, 202, 153, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 66,
        71, 82, 115, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 2, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 255,
        255, 255, 255, 0, 0,
        255, 0, 0, 0, 255,
        0, 0, 0,
      ]
    }

    describe "#initialize" do
      it "does not raise" do
        expect { StumpyBMP::FileWriter.new(file_reader.file_data) }.not_to raise_error
      end

      it "is valid" do
        # because at initialization, we have not *yet* read the file data
        expect(file_writer.valid?).to be_false
      end

      context "sets expected values for instance variable" do
        it "file_path" do
          expect(file_writer.file_data.file_path.empty?).to be_false
        end

        it "file_bytes" do
          # because at initialization, we have not *yet* read the file data
          expect(file_writer.file_data.file_bytes.empty?).to be_true
        end
      end

      context "errors do NOT include" do
        it "file_path" do
          expect(file_writer.file_data.errors.keys.to_a).not_to contain(:file_path)
        end
      end

      context "errors do include" do
        # because at initialization, we have not *yet* read the file data
        it "file_ident_header_ords" do
          expect(file_writer.file_data.errors.keys.to_a).to contain(:file_ident_header_ords)
          expect(file_writer.file_data.errors[:file_ident_header_ords]).to eq("Not a BMP file")
        end
      end
    end

    describe "#write" do
      before_each do
        # file_data.read_data
        file_reader.read
        p! temp_file_path
      end

      after_each do
        begin
          # TODO: Find out 'File.delete' of a temp file fails on Windows w/ "Permission denied"
          File.delete(temp_file_path) if File.exists?(temp_file_path)
        rescue ex
          p! ex
        end
      end

      it "writes the expected number of bytes" do
        file_size_written = file_writer.write(temp_file_path)
        expect(file_size_written).to eq(file_size_expected)
      end

      it "written file bytes match the original file bytes" do
        file_writer.write(temp_file_path)

        # NOTE: 'Each row in the Pixel array is padded to a multiple of 4 bytes in size'
        #   So, 'file.size' and 'file_data.file_bytes.size might vary'.
        expect(file_writer.file_data.file_bytes).to eq(file_data.file_bytes)
      end

      it "written bytes size matches read bytes size" do
        file_writer.write(temp_file_path)

        expect(file_writer.bytes_written_size).to eq(file_writer.file_data.file_bytes.size)
      end

      it "written bytes matches read bytes" do
        file_writer.write(temp_file_path)

        file_data2 = StumpyBMP::FileData.new(temp_file_path)
        file_reader2 = StumpyBMP::FileReader.new(file_data2)
        file_reader2.read
        expect(file_reader2.file_data.file_bytes).to eq(file_writer.file_data.file_bytes)
      end

      it "written bytes matches expected bytes" do
        file_writer.write(temp_file_path)

        file_data2 = StumpyBMP::FileData.new(temp_file_path)
        file_reader2 = StumpyBMP::FileReader.new(file_data2)
        file_reader2.read
        expect(file_reader2.file_data.file_bytes).to eq(file_bytes_expected)
      end

      context "errors do NOT include" do
        it "file_path" do
          expect(file_writer.file_data.errors.keys.to_a).not_to contain(:file_path)
        end
      end

      context "errors are empty" do
        it "file_path" do
          expect(file_writer.file_data.errors.keys).to be_empty
        end
      end
    end
  end
end
