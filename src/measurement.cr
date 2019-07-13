module Caramel
  module Measurement
    extend self

    UNIT_CONVERSION = {"pt" => 1.0, "in" => 72.0, "cm" => 28.35, "dp" => 0.072}

    def from_units(measurement : Float64, units : String) : Float64
      measurement * (UNIT_CONVERSION[units]? || 1.0)
    end

    RE_MEASUREMENT = /^\s*([+-]?\d+(\.\d+)?)([a-z]+)?\s*$/

    def parse(measurement : String, units : String = "pt") : Float64
      if m = RE_MEASUREMENT.match(measurement)
        v = m[1].to_f
        u = m[3]? || units
        from_units(v, u)
      else
        0.0
      end
    end
  end
end
