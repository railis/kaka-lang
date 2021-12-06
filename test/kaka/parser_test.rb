require_relative "../test_helper"

describe Kaka::Parser do

spec = <<~EOS
var1 = 123
--------------------------------------------------------
(MainBlock)[
  (Assignment){
    to: (Symbol='var1')
    from: (Integer='123')
  }
]
========================================================
var1 = 123.23
arr1 = [1, 2, 3]
--------------------------------------------------------
(MainBlock)[
  (Assignment){
    to: (Symbol='var1')
    from: (Float='123.23')
  },
  (Assignment){
    to: (Symbol='arr1')
    from: (Array) [
      (Integer='1'),
      (Integer='2'),
      (Integer='3')
    ]
  }
]
EOS

  spec.split(/\={5,}\n/).each_with_index do |test_case, idx|
    code, tree = test_case.split(/\-{5,}\n/)

    describe idx do

      it "parses correctly" do
        tokens = Kaka::Tokenizer.tokenize(code.strip)
        parser = Kaka::Parser.new(tokens)
        parser.parse!
        _(parser.inspect).must_equal(tree.gsub(/\s+/, ''))
      end

    end

  end

end
