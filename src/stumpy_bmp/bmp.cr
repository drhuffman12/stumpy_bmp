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

      file_reader.read # if file_reader.valid?

      @file_data = file_reader.file_data
      @canvas = file_data_to_canvas
    end

    def write(fp : String? = nil)
      # canvas : Canvas, bits_per_pixel : UInt8 = 8, include_alpha : Bool = false)
      raise "TODO"

      # TODO: Probably to the following in reverse/inverted:
      # @file_data.read_data
      # @file_data.validate!
      # file_data_to_canvas
    end

    private def file_data_to_canvas
      # end
      # # private def file_data_to_canvas
      # private def to_canvas
      canvas = StumpyCore::Canvas.new(@file_data.width.to_i32, @file_data.height.to_i32)

      bytes_per_pixel = (@file_data.bits / 8)

      # As per https://en.wikipedia.org/wiki/BMP_file_format#Pixel_storage:
      #   'Each row in the Pixel array is padded to a multiple of 4 bytes in size'
      row_size_with_padding = ((bytes_per_pixel * @file_data.width / 4.0).ceil * 4.0).to_i32

      byte_index = @file_data.offset.to_i32

      @file_data.height.times do |y|
        row_range = (byte_index..(byte_index + row_size_with_padding - 1))

        # TODO: Handle less than one byte per color for now, we assume (and force) bytes_per_pixel to be a whole number
        pixel_byte_sets = row_range.to_a.each_slice(bytes_per_pixel.to_i32).to_a

        @file_data.width.times do |x|
          pixel_color_data = pixel_byte_sets[x]
          pixel_data_to_canvas(pixel_color_data, x, y, canvas)
        end

        byte_index += row_size_with_padding
      end

      canvas
    end

    private def pixel_data_to_canvas(pixel_color_data, x, y, canvas)
      case
      when @file_data.bits == 32
        bi, gi, ri, ai = pixel_color_data
        a = @file_data.file_bytes[ai]
        r = @file_data.file_bytes[ri]
        g = @file_data.file_bytes[gi]
        b = @file_data.file_bytes[bi]

        canvas.safe_set(x.to_i32, y.to_i32, StumpyCore::RGBA.from_rgba(r, g, b, a))
      when @file_data.bits == 24
        bi, gi, ri = pixel_color_data
        r = @file_data.file_bytes[ri]
        g = @file_data.file_bytes[gi]
        b = @file_data.file_bytes[bi]

        canvas.safe_set(x.to_i32, y.to_i32, StumpyCore::RGBA.from_rgb8(r, g, b))
      else
        # TODO: Handle less than one byte per colorl for now, we assume (and force) bytes_per_pixel to be a whole number
      end
    end

    private def canvas_to_file_data(fp = @file_path)
      # file_data = FileData.new(fp)
      # @file_data.file_ident_header_ords = @file_data.file_bytes[FileData::FILE_IDENT_HEADER_RANGE]
      # @file_data.file_size = Utils.long_to_int(@file_data.file_bytes[FileData::FILE_SIZE_RANGE])
      # @file_data.rs1 = Utils.bit16_to_int(@file_data.file_bytes[FileData::FILE_RS1_RANGE]) # .to_u32
      # @file_data.rs2 = Utils.bit16_to_int(@file_data.file_bytes[FileData::FILE_RS2_RANGE]) # .to_u32
      # @file_data.offset = Utils.long_to_int(@file_data.file_bytes[FileData::FILE_OFFSET_RANGE])
      # @file_data.header_size = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_HEADER_SIZE_RANGE])
      # @file_data.width = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_WIDTH_RANGE])
      # @file_data.height = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_HEIGHT_RANGE])
      # @file_data.color_planes = Utils.bit16_to_int(@file_data.file_bytes[FileData::IMAGE_COLOR_PLANES_RANGE]) # .to_u32
      # @file_data.bits = Utils.bit16_to_int(@file_data.file_bytes[FileData::IMAGE_BITS_RANGE])                 # .to_u32
      # @file_data.compression = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_COMPRESSION_RANGE])
      # @file_data.image_size = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_SIZE_RANGE])
      # @file_data.res_x = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_RESOLUTION_X_RANGE])
      # @file_data.res_y = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_RESOLUTION_Y_RANGE])
      # @file_data.color_numbers = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_COLOR_NUMBERS_RANGE])
      # @file_data.important_colors = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_IMPORTANT_COLORS_RANGE])

    end
  end
end
