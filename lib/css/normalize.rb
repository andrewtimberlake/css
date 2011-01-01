module CSS
  module Normalize
    def normalize_property_name(name)
      if name.to_s =~ /[A-Z]/
        name.to_s.gsub(/([A-Z])/) do |match|
          "-#{match.downcase}"
        end
      elsif name.to_s =~ /_/
        name.to_s.gsub(/_/, '-')
      else
        name.to_s
      end
    end
  end
end
