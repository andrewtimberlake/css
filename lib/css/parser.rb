module CSS
  class Parser
    # Parse a css style by string, file or file name
    #
    # ==Examples
    #   parser = CSS::Parser.new
    #   css = parser.parse("body { background: #FFF }")
    #
    #   css = parser.parse("/home/andrew/style.css")
    #
    #   File.open("style.css") do |file|
    #     css = parser.parse(file)
    #   end
    def parse(file_file_name_or_style_string)
      css_style = file_file_name_or_style_string
      reset
      lineno = 1
      if css_style.respond_to?(:size) && css_style.size < 255 && File.exists?(css_style)
        File.open(css_style) do |file|
          file.each_line do |line|
            parse_line(line, lineno)
            lineno += 1
          end
        end
      elsif css_style.respond_to?(:each_line)
        css_style.each_line do |line|
          parse_line(line, lineno)
          lineno += 1
        end
      end

      @ruleset
    end

    private
      def reset
        @ruleset = RuleSet.new

        @state = :selector
        @previous_state = nil
        @previous_char = nil
        @buffer = []
        @selector = nil
      end

      def parse_line(line, lineno)
        char_count = 1
        line.each_char do |char|
          @buffer << char unless @state == :comment

          case char
          when '{'
            if @state == :selector
              @buffer.pop
              @selector = @buffer.join.strip
              @buffer.clear
              @state = :ruleset
            else
              unless @state == :comment
                raise CSSError.new(lineno, char_count, "Unexpected '{'")
              end
            end
          when '}'
            unless @state == :comment
              @buffer.pop
              @ruleset << Rule.new(@selector, @buffer.join.strip)
              @state = :selector
              @buffer.clear
            end
          when '/'
            if @previous_char == '*'
              @buffer.pop
              @state = @previous_state
            end
          when '*'
            if @previous_char == '/'
              @buffer.pop
              @previous_state = @state
              @state = :comment
            end
          end

          @previous_char = char unless char == ' '
          char_count += 1
        end
      end
  end
end
