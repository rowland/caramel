require "./measurement"

module Caramel
  class Attributes < Hash(String, String)
    def measurement(key : String, units : String = "pt") : Float64 | Nil
      if m = self[key]?
        Measurement.parse(m, units)
      end
    end
  end
end
