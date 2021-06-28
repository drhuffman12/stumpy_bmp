module StumpyBMP
  class FileData
    property file_path = ""
    property file_bytes = [] of UInt8
    getter errors = Hash(Symbol, String).new
    getter valid = false

    property file_ident_header_ords = Array(UInt8).new
    property file_size : UInt32 = 0
    property rs1 : UInt32 = 0
    property rs2 : UInt32 = 0
    property offset : UInt32 = 0
    property header_size : UInt32 = 0
    property width : UInt32 = 0
    property height : UInt32 = 0
    property color_planes : UInt32 = 0
    property bits : UInt32 = 0
    property compression : UInt32 = 0
    property image_size : UInt32 = 0
    property res_x : UInt32 = 0
    property res_y : UInt32 = 0
    property color_numbers : UInt32 = 0
    property important_colors : UInt32 = 0

    # FILE_HEADER_RANGE       = (0..13)
    FILE_IDENT_HEADER       = "BM"
    FILE_IDENT_HEADER_RANGE = (0..1)

    FILE_SIZE_RANGE = (2..5)
    FILE_RS1_RANGE  = (6..7)
    FILE_RS2_RANGE  = (8..9)

    FILE_OFFSET_RANGE = (10..13)

    # IMAGE_HEADER_SIZE            = 40
    # IMAGE_HEADER_RANGE           = (14..53)
    IMAGE_HEADER_SIZE_RANGE      = (14..17)
    IMAGE_WIDTH_RANGE            = (18..21)
    IMAGE_HEIGHT_RANGE           = (22..25)
    IMAGE_COLOR_PLANES_RANGE     = (26..27)
    IMAGE_BITS_RANGE             = (28..29)
    IMAGE_COMPRESSION_RANGE      = (30..33)
    IMAGE_SIZE_RANGE             = (34..37)
    IMAGE_RESOLUTION_X_RANGE     = (38..41)
    IMAGE_RESOLUTION_Y_RANGE     = (42..45)
    IMAGE_COLOR_NUMBERS_RANGE    = (46..49)
    IMAGE_IMPORTANT_COLORS_RANGE = (50..53)

    def initialize(@file_path = "")
      validate
    end

    # def initialize # (@file_path = "")
    #   validate
    # end

    # def read_data
    #   read_bytes
    #   read_header_data
    # end

    # def read_bytes
    #   @file_bytes = [] of UInt8

    #   unless @file_path.empty?
    #     file = File.open(@file_path)

    #     # file must be read as UInt8 bytes
    #     while (c = file.read_byte)
    #       @file_bytes << c
    #     end
    #   end

    #   @file_bytes
    # end

    # def read_header_data
    #   unless @file_path.empty? || @file_bytes.empty?
    #     @file_ident_header_ords = file_bytes[FILE_IDENT_HEADER_RANGE]
    #     @file_size = Utils.long_to_int(file_bytes[FILE_SIZE_RANGE])
    #     @rs1 = Utils.bit16_to_int(file_bytes[FILE_RS1_RANGE]) # .to_u32
    #     @rs2 = Utils.bit16_to_int(file_bytes[FILE_RS2_RANGE]) # .to_u32
    #     @offset = Utils.long_to_int(file_bytes[FILE_OFFSET_RANGE])
    #     @header_size = Utils.long_to_int(file_bytes[IMAGE_HEADER_SIZE_RANGE])
    #     @width = Utils.long_to_int(file_bytes[IMAGE_WIDTH_RANGE])
    #     @height = Utils.long_to_int(file_bytes[IMAGE_HEIGHT_RANGE])
    #     @color_planes = Utils.bit16_to_int(file_bytes[IMAGE_COLOR_PLANES_RANGE]) # .to_u32
    #     @bits = Utils.bit16_to_int(file_bytes[IMAGE_BITS_RANGE])                 # .to_u32
    #     @compression = Utils.long_to_int(file_bytes[IMAGE_COMPRESSION_RANGE])
    #     @image_size = Utils.long_to_int(file_bytes[IMAGE_SIZE_RANGE])
    #     @res_x = Utils.long_to_int(file_bytes[IMAGE_RESOLUTION_X_RANGE])
    #     @res_y = Utils.long_to_int(file_bytes[IMAGE_RESOLUTION_Y_RANGE])
    #     @color_numbers = Utils.long_to_int(file_bytes[IMAGE_COLOR_NUMBERS_RANGE])
    #     @important_colors = Utils.long_to_int(file_bytes[IMAGE_IMPORTANT_COLORS_RANGE])
    #   end
    # end

    def validate
      @errors = Hash(Symbol, String).new

      @errors[:file_path] = "Param file_path is missing!" if file_path.empty?
      @errors[:file_ident_header_ords] = "Not a BMP file" if file_ident_header_range_text != FILE_IDENT_HEADER
      @errors[:bits] = "Un-supported bit-depth! (bits: #{bits}; supported: 24 at 8bits per bgr, 32 at 8bits per bgra)" if ![24, 32].includes?(bits)

      # TODO: more validations

      @errors
    end

    def valid?
      validate
      @valid = @errors.keys.empty?
    end

    def validate!
      raise @errors.to_json if !valid?
    end

    def file_ident_header_range_text
      @file_ident_header_ords.map(&.chr).join
    end

    # def write_data(to_file_path = @file_path)
    #   bytes_written = 0

    #   if @file_bytes.size > 0
    #     folder_path = File.dirname(to_file_path)

    #     file_exists_and_is_writeable = File.directory?(folder_path) && File.file?(to_file_path) && File.writable?(file_path)
    #     file_not_yet_exists = File.directory?(folder_path) && !File.exists?(to_file_path)
    #     folder_not_yet_exists = !File.exists?(to_file_path)

    #     if file_exists_and_is_writeable || file_not_yet_exists || folder_not_yet_exists
    #       Dir.mkdir_p(folder_path) if folder_not_yet_exists
    #       File.open(to_file_path, "w") do |io|
    #         # bytes_written = io.write_bytes(@file_bytes.join )
    #         @file_bytes.each do |byte|
    #           io.write_byte(byte)
    #           bytes_written += 1
    #         end
    #       end
    #     end
    #   end

    #   bytes_written
    #   # (canvas)
    #   # # See also: https://github.com/edin/raytracer/blob/master/ruby/Image.rb and related code
    # end

    # def write_data_bytes
    #   # @file_bytes = [] of UInt8
    #   # unless @file_path.empty?
    #   #   file = File.open(@file_path)

    #   #   # file must be read as UInt8 bytes
    #   #   while (c = file.read_byte)
    #   #     @file_bytes << c
    #   #   end
    #   # end

    #   # @file_bytes

    #   # TODO
    #   # Utils.to_u8_bounded(x)
    #   # Utils.to_u16_bounded(x)
    #   # Utils.to_u32_bounded(x)

    #   # file
    # end

    # def write_data_header
    # end

    # def write_data_image
    #   # TODO
    # end
  end
end
