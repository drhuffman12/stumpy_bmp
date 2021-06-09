require "./spec_helper"

Spectator.describe StumpyBMP do
  let(file_path) { "spec/stumpy_bmp/examples/example0/image.bmp" }
  let(width_expected) { 2 }
  let(height_expected) { 2 }

  describe ".read" do
    context "calls" do
      pending "StumpyBMP::BMP#read" do
        expect(StumpyBMP::BMP).to receive(:new).with(file_path: file_path)
        stumpy_bmp_canvas = StumpyBMP.read(file_path)
      end
    end

    context "returns" do
      let(stumpy_bmp_canvas) { StumpyBMP.read(file_path: file_path) }
      it "a Canvas" do
        expect(stumpy_bmp_canvas.class).to eq(StumpyCore::Canvas)
      end
      context "a Canvas with expected" do
        it "width" do
          expect(stumpy_bmp_canvas.width).to eq(width_expected)
        end

        it "height" do
          expect(stumpy_bmp_canvas.height).to eq(height_expected)
        end
      end
    end
  end
end
