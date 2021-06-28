require "stumpy_core"
require "./stumpy_bmp/*"

module StumpyBMP
  alias Canvas = StumpyCore::Canvas

  def self.read(file_path : String)
    StumpyBMP::BMP.new(file_path: file_path).read
  end

  def self.write(file_path : String, canvas : Canvas, bits_per_pixel : UInt8 = 8, include_alpha : Bool = false)
    StumpyBMP::BMP.new(width: canvas.width, height: canvas.height, file_path: file_path).write(canvas: canvas, bits_per_pixel: bits_per_pixel, include_alpha: include_alpha)
  end
end
