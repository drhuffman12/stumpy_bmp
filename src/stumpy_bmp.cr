require "stumpy_core"
require "./stumpy_bmp/*"

module StumpyBMP
  alias Canvas = StumpyCore::Canvas

  def self.read(file_name : String)
    StumpyBMP::BMP.new(file_name: file_name).read
  end

  def self.write(file_name : String, canvas : Canvas, bits_per_pixel : UInt8 = 8, include_alpha : Bool = false)
    StumpyBMP::BMP.new(width: canvas.width, height: canvas.height, file_name: file_name).write(canvas: canvas, bits_per_pixel: bits_per_pixel, include_alpha: include_alpha)
  end
end
