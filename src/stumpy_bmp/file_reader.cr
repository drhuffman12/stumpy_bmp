require "./file_data.cr"

module StumpyBMP
  class FileReader
    # include FileData
    getter file_data : FileData

    # property file_data : FileData

    # getter errors = Hash(Symbol, String).new
    # getter valid = false
    getter file_read = false

    # # property file_path = ""
    # property file_bytes = [] of UInt8

    def initialize(file_data : FileData) # , @file_path = "")
      @file_data = file_data             # .clone
      validate
    end

    def validate
      @file_data.validate
      if @file_read
        @file_data.errors[:file_ident_header_ords] = "Not a BMP file" if @file_data.file_ident_header_range_text != FileData::FILE_IDENT_HEADER
        @file_data.errors[:bits] = "Un-supported bit-depth! (bits: #{@file_data.bits}; supported: 24 at 8bits per bgr, 32 at 8bits per bgra)" if ![24, 32].includes?(@file_data.bits)
      end
      @file_data.errors
    end

    def valid?
      validate
      @file_data.valid?
    end

    def validate!
      raise @file_data.errors.to_json if !valid?
    end

    def read
      @file_read = false

      @file_data.file_bytes = [] of UInt8

      read_bytes
      read_header_data

      @file_read = true

      validate!

      {file_data: @file_data, canvas: to_canvas}
    end

    # private
    def read_bytes # (file_bytes)
      # @file_data.file_bytes = [] of UInt8

      unless @file_data.file_path.empty?
        file = File.open(@file_data.file_path)

        # file must be read as UInt8 bytes
        while (c = file.read_byte)
          @file_data.file_bytes << c
        end
      end

      @file_data.file_bytes
    end

    # private
    def read_header_data
      unless @file_data.file_path.empty? || @file_data.file_bytes.empty?
        @file_data.file_ident_header_ords = @file_data.file_bytes[FileData::FILE_IDENT_HEADER_RANGE]
        @file_data.file_size = Utils.long_to_int(@file_data.file_bytes[FileData::FILE_SIZE_RANGE])
        @file_data.rs1 = Utils.bit16_to_int(@file_data.file_bytes[FileData::FILE_RS1_RANGE]) # .to_u32
        @file_data.rs2 = Utils.bit16_to_int(@file_data.file_bytes[FileData::FILE_RS2_RANGE]) # .to_u32
        @file_data.offset = Utils.long_to_int(@file_data.file_bytes[FileData::FILE_OFFSET_RANGE])
        @file_data.header_size = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_HEADER_SIZE_RANGE])
        @file_data.width = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_WIDTH_RANGE])
        @file_data.height = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_HEIGHT_RANGE])
        @file_data.color_planes = Utils.bit16_to_int(@file_data.file_bytes[FileData::IMAGE_COLOR_PLANES_RANGE]) # .to_u32
        @file_data.bits = Utils.bit16_to_int(@file_data.file_bytes[FileData::IMAGE_BITS_RANGE])                 # .to_u32
        @file_data.compression = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_COMPRESSION_RANGE])
        @file_data.image_size = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_SIZE_RANGE])
        @file_data.res_x = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_RESOLUTION_X_RANGE])
        @file_data.res_y = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_RESOLUTION_Y_RANGE])
        @file_data.color_numbers = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_COLOR_NUMBERS_RANGE])
        @file_data.important_colors = Utils.long_to_int(@file_data.file_bytes[FileData::IMAGE_IMPORTANT_COLORS_RANGE])
      end
    end

    # def file_ident_header_range_text
    #   @file_ident_header_ords.map(&.chr).join
    # end

    # private def file_data_to_canvas
    private def to_canvas
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
  end
end
