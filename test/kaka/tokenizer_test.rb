require_relative "../test_helper"

describe Kaka::Tokenizer do

spec = <<~EOS
123
--------------------------------------------------------
<integer='123'>
========================================================
123.12
--------------------------------------------------------
<float='123.12'>
========================================================
variable_1
--------------------------------------------------------
<identifier='variable_1'>
========================================================
Array
--------------------------------------------------------
<type_identifier='Array'>
========================================================
a > 1
--------------------------------------------------------
<identifier='a'><space><operator_gt>
<space><integer='1'>
========================================================
2 < 1
--------------------------------------------------------
<integer='2'><space><operator_ls><space><integer='1'>
========================================================
c <= 1
--------------------------------------------------------
<identifier='c'><space><operator_lse><space><integer='1'>
========================================================
2 >= 1
--------------------------------------------------------
<integer='2'><space><operator_gte><space><integer='1'>
========================================================
d == 1
--------------------------------------------------------
<identifier='d'><space><operator_eq><space><integer='1'>
========================================================
f != 1
--------------------------------------------------------
<identifier='f'><space><operator_neq><space><integer='1'>
========================================================
f != 1
--------------------------------------------------------
<identifier='f'><space><operator_neq><space><integer='1'>
========================================================
f && 1
--------------------------------------------------------
<identifier='f'><space><operator_and><space><integer='1'>
========================================================
f || 1
--------------------------------------------------------
<identifier='f'><space><operator_or><space><integer='1'>
========================================================
f & 1
--------------------------------------------------------
<identifier='f'><space><operator_band><space><integer='1'>
========================================================
f | 1
--------------------------------------------------------
<identifier='f'><space><operator_bor><space><integer='1'>
========================================================
true
--------------------------------------------------------
<keyword='true'>
========================================================
false
--------------------------------------------------------
<keyword='false'>
========================================================
null
--------------------------------------------------------
<keyword='null'>
========================================================
if
--------------------------------------------------------
<keyword='if'>
========================================================
else
--------------------------------------------------------
<keyword='else'>
========================================================
include
--------------------------------------------------------
<keyword='include'>
========================================================
while
--------------------------------------------------------
<keyword='while'>
========================================================
Array var1 = [1, 2]
--------------------------------------------------------
<type_identifier='Array'><space><identifier='var1'><space>
<assignment><space><array_start><integer='1'><separator><space>
<integer='2'><array_end>
========================================================
Array.reverse([1, 2])
--------------------------------------------------------
<type_identifier='Array'><invocation><identifier='reverse'>
<bracket_start><array_start><integer='1'><separator><space>
<integer='2'><array_end><bracket_end>
========================================================
Array.reverse [1, 2]
--------------------------------------------------------
<type_identifier='Array'><invocation><identifier='reverse'><space>
<array_start><integer='1'><separator><space>
<integer='2'><array_end>
========================================================
String.length "foo"
--------------------------------------------------------
<type_identifier='String'><invocation><identifier='length'><space>
<string_start><string_content='foo'><string_end>
========================================================
"i am a simple string"
--------------------------------------------------------
<string_start><string_content='i am a simple string'><string_end>
========================================================
[1, 2, 3, 4]
--------------------------------------------------------
<array_start><integer='1'><separator><space><integer='2'>
<separator><space><integer='3'><separator><space><integer='4'>
<array_end>
========================================================
[1, ["foo", [1.21,var2]], 4]
--------------------------------------------------------
<array_start><integer='1'><separator><space>
<array_start><string_start><string_content='foo'>
<string_end><separator><space><array_start><float='1.21'>
<separator><identifier='var2'><array_end><array_end><separator>
<space><integer='4'><array_end>
========================================================
var1 = 123
--------------------------------------------------------
<identifier='var1'><space><assignment><space><integer='123'>
========================================================
str1 = "i'm a string"
--------------------------------------------------------
<identifier='str1'><space><assignment><space><string_start>
<string_content='i\'m a string'><string_end>
========================================================
var1 = 554
str1 = "a string"
var2 = 2.53
var3 = var1
--------------------------------------------------------
<identifier='var1'><space><assignment><space><integer='554'><linebreak>
<identifier='str1'><space><assignment><space><string_start>
<string_content='a string'><string_end><linebreak>
<identifier='var2'><space><assignment><space><float='2.53'><linebreak>
<identifier='var3'><space><assignment><space><identifier='var1'>
========================================================
Enum.each(arr1) (el): IO.print(el)
--------------------------------------------------------
<type_identifier='Enum'><invocation><identifier='each'>
<bracket_start><identifier='arr1'><bracket_end><space>
<bracket_start><identifier='el'><bracket_end><block_start><space>
<type_identifier='IO'><invocation><identifier='print'>
<bracket_start><identifier='el'><bracket_end>
========================================================
Enum.each(arr1) (el):
  IO.print(el)
--------------------------------------------------------
<type_identifier='Enum'><invocation><identifier='each'>
<bracket_start><identifier='arr1'><bracket_end><space>
<bracket_start><identifier='el'><bracket_end><block_start>
<linebreak><indent>
<type_identifier='IO'><invocation><identifier='print'>
<bracket_start><identifier='el'><bracket_end>
========================================================
fn1 = :
  print(2)
--------------------------------------------------------
<identifier='fn1'><space><assignment><space><block_start><linebreak>
<indent><identifier='print'><bracket_start><integer='2'><bracket_end>
========================================================
Enum.each [a1, a2], (arr):
  Enum.each arr:
    IO.print arr
--------------------------------------------------------
<type_identifier='Enum'><invocation><identifier='each'>
<space><array_start><identifier='a1'><separator><space>
<identifier='a2'><array_end><separator><space>
<bracket_start><identifier='arr'><bracket_end><block_start>
<linebreak><indent><type_identifier='Enum'><invocation><identifier='each'>
<space><identifier='arr'><block_start><linebreak>
<indent><indent><type_identifier='IO'><invocation><identifier='print'>
<space><identifier='arr'>
EOS

  spec.split(/\={5,}\n/).each_with_index do |test_case, idx|
    code, tokens = test_case.split(/\-{5,}\n/)

    describe idx do

      it "tokenizes correctly" do
        _(Kaka::Tokenizer.tokenize(code.strip).map(&:inspect).join).must_equal(tokens.gsub("\n", ''))
      end

    end
  end

end
