module Kaka
  class Token

    attr_reader :token_class, :token_value, :line_nr, :rel_pos, :abs_pos

    def initialize(token_class, token_value, line_nr, rel_pos, abs_pos)
      @token_class = token_class
      @token_value = token_value
      @line_nr = line_nr
      @rel_pos = rel_pos
      @abs_pos = abs_pos
    end

    def inspect
      if @token_value
        "<#{@token_class}='#{@token_value}'>"
      else
        "<#{@token_class}>"
      end
    end

  end
end
