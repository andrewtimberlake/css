class Numeric
  %w(em ex px gd rem vw vh vm ch).each do |unit|
    define_method(unit) do
      "#{self}#{unit}"
    end
  end

  def percent
    "#{self}%"
  end
end
