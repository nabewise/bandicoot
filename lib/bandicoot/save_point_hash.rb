module Bandicoot
  class SavePointHash < Hash
    attr_accessor :ret_val, :complete

    def completed?
      !!complete
    end
  end
end
