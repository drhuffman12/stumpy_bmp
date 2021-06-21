require "./file_reader.cr"

module StumpyBMP
  class BadFilePath < Exception; end

  class BMP
    # enum ResizeMode
    #   AnchorTopLeft
    #   # TODO: add more and handle accordingly below
    # end

    # getter width : Int32 = 0, height : Int32 = 0
    property file_path : String

    getter file_data : FileData
    getter canvas : StumpyCore::Canvas

    def initialize(width = 0, height = 0, @file_path = "")
      @file_data = FileData.new(file_path)
      # @canvas = resize(@width, @height)
      @canvas = StumpyCore::Canvas.new(width, height)
    end

    # def resize(width = 0, height = 0) # , mode : ResizeMode)
    #   @width = width
    #   @height = height

    #   @canvas = StumpyCore::Canvas.new(@width, @height)
    # end

    # def width=(new_width)
    #   @width = new_width
    # end

    # def height=(new_height)
    #   @height = new_height
    # end

    def width
      @canvas.width
    end

    def height
      @canvas.height
    end

    # private def resize
    #   @canvas = StumpyCore::Canvas.new(@width, @height)
    # end

    def read(fp : String? = nil)
      unless fp.nil?
        raise BadFilePath.new if fp == "" || !File.file?(fp)
        @file_data.file_path = fp
      end

      file_reader = FileReader.new(@file_data)
      results = file_reader.read

      @file_data = results[:file_data]
      @canvas = results[:canvas]
    end

    def write(canvas : Canvas, bits_per_pixel : UInt8 = 8, include_alpha : Bool = false)
      raise "TODO"

      # TODO: Probably to the following in reverse/inverted:
      # @file_data.read_data
      # @file_data.validate!
      # file_data_to_canvas
    end
  end
end
