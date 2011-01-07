module CSS
  module Orientation
    NESW = %w(top right bottom left)

    def compact_orientation(top, right, bottom, left)
      if top && right && bottom && left
        if [top, right, bottom, left] == Array.new(4) { top }
          top
        elsif [top, bottom] == Array.new(2) { top } && [left, right] == Array.new(2) { left }
          [top, left].join(' ')
        elsif [top, bottom] != Array.new(2) { top } && [left, right] == Array.new(2) { left }
          [top, left, bottom].join(' ')
        else
          [top, right, bottom, left].join(' ')
        end
      end
    end
  end
end
