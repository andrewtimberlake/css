module CSS
  module Normalize
    def normalize_property_name(name)
      name = name.to_s.strip
      if name =~ /[A-Z]/
        name.gsub(/([A-Z])/) do |match|
          "-#{match.downcase}"
        end
      elsif name =~ /_/
        name.gsub(/_/, '-')
      else
        name
      end
    end
  end
end
