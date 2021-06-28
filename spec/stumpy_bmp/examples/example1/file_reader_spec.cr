require "./../../../spec_helper"

Spectator.describe StumpyBMP::FileReader do
  context "when file_path given (and it is a valid bmp file)" do
    # when given a valid bmp file...
    let(file_path) { "spec/stumpy_bmp/examples/example1/image.bmp" }
    let(file_data) { StumpyBMP::FileData.new(file_path) }
    let(file_reader) { StumpyBMP::FileReader.new(file_data) }

    # we expect...
    let(file_size_expected) { 322 }
    let(file_bytes_expected) {
      [
        66, 77, 66, 1, 0,
        0, 0, 0, 0, 0,
        122, 0, 0, 0, 108,
        0, 0, 0, 6, 0,
        0, 0, 10, 0, 0,
        0, 1, 0, 24, 0,
        0, 0, 0, 0, 200,
        0, 0, 0, 19, 11,
        0, 0, 19, 11, 0,
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
        0, 0, 255, 255, 255,
        255, 255, 255, 255, 255,
        255, 0, 0, 0, 1,
        0, 48, 0, 0, 48,
        0, 0, 255, 255, 255,
        1, 0, 48, 1, 0,
        48, 4, 33, 112, 0,
        48, 144, 0, 96, 146,
        0, 0, 255, 255, 255,
        2, 0, 48, 255, 255,
        255, 1, 0, 48, 2,
        0, 48, 48, 24, 162,
        0, 0, 0, 0, 48,
        1, 0, 64, 76, 73,
        112, 0, 0, 0, 255,
        255, 255, 0, 0, 156,
        0, 0, 1, 0, 48,
        8, 2, 162, 2, 0,
        48, 2, 0, 48, 255,
        255, 255, 0, 16, 156,
        0, 0, 1, 0, 48,
        0, 16, 144, 2, 0,
        48, 2, 0, 48, 255,
        255, 255, 0, 0, 48,
        0, 0, 2, 0, 48,
        24, 24, 168, 3, 0,
        48, 12, 137, 112, 3,
        0, 48, 3, 0, 48,
        0, 0, 1, 0, 48,
        0, 2, 164, 2, 0,
        48, 0, 0, 48, 24,
        2, 166, 255, 255, 255,
        0, 0, 2, 0, 48,
        0, 64, 156, 0, 0,
        28, 1, 0, 48, 160,
        153, 112, 255, 255, 255,
        0, 0, 255, 255, 255,
        255, 255, 255, 0, 0,
        0, 0, 80, 146, 3,
        0, 48, 255, 255, 255,
        0, 0,
      ]
    }

    # TODO: verify!
    let(file_ident_header_ords_expected) { [66, 77] }
    let(rs1_expected) { 0 }
    let(rs2_expected) { 0 }
    let(offset_expected) { 122 }
    let(header_size_expected) { 108 }
    let(width_expected) { 6 }
    let(height_expected) { 10 }
    let(color_planes_expected) { 1 }
    let(bits_expected) { 24 }
    let(compression_expected) { 0 }
    let(image_size_expected) { 200 }
    let(res_x_expected) { 2835 }
    let(res_y_expected) { 2835 }
    let(color_numbers_expected) { 0 }

    describe "#initialize" do
      it "does not raise" do
        expect { StumpyBMP::FileReader.new(file_data) }.not_to raise_error
      end

      it "is valid" do
        # because at initialization, we have not *yet* read the file data
        expect(file_reader.valid?).to be_false
      end

      context "sets expected values for instance variable" do
        it "file_path" do
          expect(file_reader.file_data.file_path.empty?).to be_false
        end

        it "file_bytes" do
          # because at initialization, we have not *yet* read the file data
          expect(file_reader.file_data.file_bytes.empty?).to be_true
        end
      end

      context "errors do NOT include" do
        it "file_path" do
          expect(file_reader.file_data.errors.keys.to_a).not_to contain(:file_path)
        end
      end

      context "errors do include" do
        # because at initialization, we have not *yet* read the file data
        it "file_ident_header_ords" do
          expect(file_reader.file_data.errors.keys.to_a).to contain(:file_ident_header_ords)
          expect(file_reader.file_data.errors[:file_ident_header_ords]).to eq("Not a BMP file")
        end
      end
    end

    describe "#read" do
      before_each do
        allow(file_reader).to receive(:read_bytes).and_return(nil)
        allow(file_reader).to receive(:read_header_data).and_return(nil)
      end

      context "calls" do
        pending "read_bytes" do
          # allow(file_data).to receive(:read_bytes).and_return(nil)
          # allow(file_data).to receive(:read_header_data).and_return(nil)

          expect(file_reader).to receive(:read_bytes).and_return(nil)
          file_reader.read
        end

        pending "read_header_data" do
          # allow(file_data).to receive(:read_bytes).and_return(nil)
          # allow(file_data).to receive(:read_header_data).and_return(nil)

          expect(file_reader).to receive(:read_header_data)
          file_reader.read
        end
      end
    end

    describe "#read_bytes" do
      context "does call" do
        pending "File.open" do
          expect(file_reader.file_data.file_path.empty?).to be_false
          expect(File).to receive(:open).with(file_path)
          file_reader.read_bytes
        end
      end

      it "sets @file_bytes with expected data" do
        expect(file_reader.file_data.file_bytes).to eq(Array(UInt8).new)
        file_reader.read_bytes
        expect(file_reader.file_data.file_bytes).to eq(file_bytes_expected)
      end

      it "returns expected data" do
        expect(file_reader.read_bytes).to eq(file_bytes_expected)
      end
    end

    describe "#read_header_data" do
      before_each do
        file_reader.read_bytes
      end

      context "when file_path IS given (and not empty and is for a valid bmp file)" do
        before_each do
          file_reader.read_header_data
        end

        context "does set expected value for instance variable" do
          context "@file_ident_header_ords re" do
            let(variable_set) { file_reader.file_data.file_ident_header_ords }
            let(value_expected) { file_ident_header_ords_expected }

            it "class" do
              expect(variable_set.class).to eq(Array(UInt8))
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@file_size re" do
            let(variable_set) { file_reader.file_data.file_size }
            let(value_expected) { file_size_expected }

            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@rs1 re" do
            let(variable_set) { file_reader.file_data.rs1 }
            let(value_expected) { rs1_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@rs2 re" do
            let(variable_set) { file_reader.file_data.rs2 }
            let(value_expected) { rs2_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@offset re" do
            let(variable_set) { file_reader.file_data.offset }
            let(value_expected) { offset_expected }
            it "class" do
              expect(file_reader.file_data.offset.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@header_size re" do
            let(variable_set) { file_reader.file_data.header_size }
            let(value_expected) { header_size_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@width re" do
            let(variable_set) { file_reader.file_data.width }
            let(value_expected) { width_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@height re" do
            let(variable_set) { file_reader.file_data.height }
            let(value_expected) { height_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@color_planes re" do
            let(variable_set) { file_reader.file_data.color_planes }
            let(value_expected) { color_planes_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@bits re" do
            let(variable_set) { file_reader.file_data.bits }
            let(value_expected) { bits_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@compression re" do
            let(variable_set) { file_reader.file_data.compression }
            let(value_expected) { compression_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@image_size re" do
            let(variable_set) { file_reader.file_data.image_size }
            let(value_expected) { image_size_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@res_x re" do
            let(variable_set) { file_reader.file_data.res_x }
            let(value_expected) { res_x_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@res_y re" do
            let(variable_set) { file_reader.file_data.res_y }
            let(value_expected) { res_y_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end

          context "@color_numbers re" do
            let(variable_set) { file_reader.file_data.color_numbers }
            let(value_expected) { color_numbers_expected }
            it "class" do
              expect(variable_set.class).to eq(UInt32)
            end

            it "value" do
              expect(variable_set).to eq(value_expected)
            end
          end
        end
      end
    end
  end
end