module Bandicoot
  class Context
    attr_reader :parent, :save_points

    def initialize(opts={})
      @parent = opts[:parent]
      @key = opts[:key]
      
      # if this is the top level context
      if !parent
        @key ||= "__main__"
        @continuing = !!opts[:continue]
        if continuing?
          @save_file = SaveFile.continue(opts[:continue])
          @save_points = @save_file.save_points[@key] || SavePointHash.new
        else
          @save_file = SaveFile.create(opts[:save_file] || default_save_filename)
          @save_points = SavePointHash.new
        end
      else
        @save_points = parent.save_points[@key] || SavePointHash.new
      end
    end

    def key
      @m_key ||= ((parent && parent.key) || []) + [@key]
    end

    def save_file
      @save_file ||= (parent && parent.save_file)
    end

    def continuing?
      @continuing ||= (parent && parent.continuing?)
    end

    # makes things a little prettier
    def save_point
      @save_points
    end

    def run(blk)
      if continuing? && save_point.completed?
        save_point.ret_val
      else
        finish! blk.call
      end
    end

    def finish!(retval=nil)
      save_file.write(key, retval) if save_file
      retval
    end
    
    protected
    def default_save_filename
      "bandicoot-#{Time.now.to_i}-#{rand(65535)}.save"
    end
  end
end
