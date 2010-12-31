module CSS
  class Parser
    def parse(file_name)
      ruleset = RuleSet.new

      state = :selector
      previous_state = nil
      previous_char = nil
      buffer = []
      selector = nil

      File.open(file_name) do |file|
        file.each do |line|
          char_count = 1
          line.each_char do |char|
            buffer << char unless state == :comment

            case char
            when '{'
              if state == :selector
                buffer.pop
                selector = buffer.join.strip
                buffer.clear
                state = :ruleset
              else
                unless state == :comment
                  raise CSSError.new(file.lineno, char_count, "Unexpected '{'")
                end
              end
            when '}'
              unless state == :comment
                buffer.pop
                ruleset << Rule.new(selector, buffer.join.strip)
                state = :selector
                buffer.clear
              end
            when '/'
              if previous_char == '*'
                buffer.pop
                state = previous_state
              end
            when '*'
              if previous_char == '/'
                buffer.pop
                previous_state = state
                state = :comment
              end
            end

            previous_char = char unless char == ' '
            char_count += 1
          end
        end
      end

      ruleset
    end
  end
end
