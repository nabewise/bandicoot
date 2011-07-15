require 'msgpack'

module Bandicoot
  class SaveFile
    attr_reader :file, :save_points

    def self.create(filename)
      new(File.open(filename, "w"))
    end
    
    def self.continue(filename)
      file = File.open(filename, "r+")
      save_points = read_save_points(file)
      file.seek(0, IO::SEEK_END)
      new(file, save_points)
    end

    def initialize(file, save_points=nil)
      @file = file
      @save_points = save_points
    end

    def write(key, retval)
      puts "[BANDICOOT] writing [#{key.inspect}, #{retval.inspect}]"
      file.write([key, retval].to_msgpack)
      file.fsync
    end

    def close
      file.close
    end

    protected
    def self.read_save_points(file)
      hash = SavePointHash.new
      begin
        MessagePack::Unpacker.new(file).each do |key, retval|
          c = hash
          key.each do |x|
            c[x] ||= SavePointHash.new
            c = c[x]
          end
          c.complete = true
          c.ret_val = retval
        end
      rescue EOFError
        #nop, of course exceptions should be used for flow control
        # silly me to think otherwise.
      end
      p hash
      hash
    end
  end
end
