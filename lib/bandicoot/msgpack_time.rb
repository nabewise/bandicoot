# As it turns out, serializing Time is something we should support for
# this sort of application
class Time
  def to_msgpack
    {"__type__" => "unixts", "ts" => self.to_i}.to_msgpack
  end
end
