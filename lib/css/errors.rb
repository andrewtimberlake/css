module CSS
  class CSSError < StandardError
    attr_reader :line_number, :char

    def initialize(line_number, char, error_message)
      @line_number = line_number
      @char = char
      super(error_message)
    end
  end
end
