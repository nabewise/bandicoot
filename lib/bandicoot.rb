require 'bandicoot/save_file'
require 'bandicoot/save_point_hash'
require 'bandicoot/context'

module Bandicoot
  @@current = nil

  def self.start(opts={})
    raise AlreadyStartedError if Bandicoot.current
    Bandicoot.push_context(opts)
    begin
      yield
    ensure
      puts "[BANDICOOT] closing"
      Bandicoot.current.save_file.close
      Bandicoot.pop_context
    end
  end

  def self.current
    @@current
  end

  def self.save_point(key, &blk)
    raise NotStartedError unless Bandicoot.current
    Bandicoot.push_context(:key => key)
    begin
      Bandicoot.current.run(blk)
    ensure
      Bandicoot.pop_context
    end
  end

  def self.push_context(opts={})
    @@current = Bandicoot::Context.new(opts.merge(:parent => Bandicoot.current))
  end

  def self.pop_context
    @@current = Bandicoot.current.parent
  end

  class AlreadyStartedError < RuntimeError; end
  class NotStartedError < RuntimeError; end
end
