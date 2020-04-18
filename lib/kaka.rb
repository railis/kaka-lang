require_relative "kaka/tokenizer"

module Kaka
  def self.exec!(file_body)
    tokens = Tokenizer.tokenize(file_body)
    tokens.each do |t|
      puts t.token_class.to_s.ljust(20) + t.token_value.to_s.ljust(10) + "line: #{t.line_nr}".ljust(10) + "pos: #{t.rel_pos}".ljust(10)
    end
  end
end
