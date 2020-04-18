require "strscan"
require_relative "stack"
require_relative "tokenizer/token"

module Kaka
  class Tokenizer

    KEYWORDS = %w{true false null if else include while}

    TOKEN_DEFS = {
      default: [
        {class: :keyword,         pattern: /#{KEYWORDS.join("|")}/, with_content: true,  state: false   },
        {class: :float,           pattern: /\d+\.\d+/,              with_content: true,  state: false   },
        {class: :integer,         pattern: /\d+/,                   with_content: true,  state: false   },
        {class: :identifier,      pattern: /[a-z0-9_-]+/,           with_content: true,  state: false   },
        {class: :type_identifier, pattern: /[A-Z][A-Za-z0-9]+/,     with_content: true,  state: false   },
        {class: :string_start,    pattern: /\"/,                    with_content: false, state: :string },
        {class: :operator_gte,    pattern: /\>\=/,                  with_content: false, state: false   },
        {class: :operator_lse,    pattern: /\<\=/,                  with_content: false, state: false   },
        {class: :operator_gt,     pattern: /\>/,                    with_content: false, state: false   },
        {class: :operator_ls,     pattern: /\</,                    with_content: false, state: false   },
        {class: :operator_gt,     pattern: /\>/,                    with_content: false, state: false   },
        {class: :operator_ls,     pattern: /\</,                    with_content: false, state: false   },
        {class: :operator_eq,     pattern: /\={2}/,                 with_content: false, state: false   },
        {class: :operator_neq,    pattern: /\!\=/,                  with_content: false, state: false   },
        {class: :operator_and,    pattern: /\&{2}/,                 with_content: false, state: false   },
        {class: :operator_or,     pattern: /\|{2}/,                 with_content: false, state: false   },
        {class: :operator_band,   pattern: /\&/,                    with_content: false, state: false   },
        {class: :operator_bor,    pattern: /\|/,                    with_content: false, state: false   },
        {class: :assignment,      pattern: /\=/,                    with_content: false, state: false   },
        {class: :block_start,     pattern: /\:/,                    with_content: false, state: false   },
        {class: :invocation,      pattern: /\./,                    with_content: false, state: false   },
        {class: :bracket_start,   pattern: /\(/,                    with_content: false, state: false   },
        {class: :bracket_end,     pattern: /\)/,                    with_content: false, state: false   },
        {class: :array_start,     pattern: /\[/,                    with_content: false, state: false   },
        {class: :array_end,       pattern: /\]/,                    with_content: false, state: false   },
        {class: :separator,       pattern: /\,/,                    with_content: false, state: false   },
        {class: :indent,          pattern: /^\ {2}/,                with_content: false, state: false   },
        {class: :linebreak,       pattern: /\n/,                    with_content: false, state: false   },
        {class: :space,           pattern: /\ +/,                   with_content: false, state: false   },
        {class: :content,         pattern: /.+/m,                   with_content: true,  state: false   }
      ],
      string: [
        {class: :string_end,      pattern: /\"/,                    with_content: false, state: :pop    },
        {class: :string_content,  pattern: /[^\"]+/,                with_content: true,  state: false   }
      ]
    }

    def initialize(body)
      @body = body
      @scanner = StringScanner.new(@body)
      @state = Stack.new
      @lines = 1
      @tokens = []
    end

    def tokenize
      until @scanner.eos?
        token_loop_active = true
        index = 0
        while index < TOKEN_DEFS[@state.current].size || token_loop_active
          token_def = TOKEN_DEFS[@state.current][index]
          if @scanner.scan(token_def[:pattern])
            append_token(
              token_def[:class],
              (@scanner.matched if token_def[:with_content]),
              current_line_number, position_in_line - @scanner.matched.length + 1,
              @scanner.pos
            )
            @lines += 1 if token_def[:class] == :linebreak
            token_def[:state] == :pop ? @state.pop : @state.push(token_def[:state]) if token_def[:state]
            index = 0
            token_loop_active = false
          else
            index += 1
          end
        end
      end
      @tokens
    end

    def append_token(token_class, token_value, line, rel_position, abs_position)
      @tokens << Token.new(token_class, token_value, line, rel_position, abs_position)
    end

    def current_line_number
      linebreak_tokens.size + 1
    end

    def position_in_line
      return @scanner.pos if linebreak_tokens.empty?
      @scanner.pos - linebreak_tokens.last.abs_pos
    end

    def linebreak_tokens
      @tokens.select { |t| t.token_class == :linebreak }
    end

    def self.tokenize(body)
      new(body).tokenize
    end

  end
end
