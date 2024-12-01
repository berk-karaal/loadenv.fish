source functions/loadenv.fish

@test 'printb option' (loadenv --printb tests/happy.env | string collect) = "[HELLO=World]
[SIMPLE_KEY=simple_value]
[VALUE_WITH_EQUALS_SIGN1==]
[VALUE_WITH_EQUALS_SIGN2==abcdef=]
[VALUE_WITH_HASHTAG_INSIDE=hello # world]
[VALUE_WITH_HASHTAG_INSIDE_INLINE_COMMENTED=hello # world]
[VAR_BELOW_COMMENT=1234]
[INLINE_COMMENT1=commented_value]
[INLINE_COMMENT2=commented_value]
[MULTIPLE_INLINE_COMMENT=lets_play_safe]
[EMPTY_VAR=]
[ANOTHER_EMPTY_VAR=]
[DOUBLE_QUOTE_EMPTY=]
[SINGLE_QUOTE_EMPTY=]
[DOUBLE_QUOTE_WITH_WHITESPACE1=word1 word2 word3]
[DOUBLE_QUOTE_WITH_WHITESPACE2=  word1 word2 word3  ]
[SINGLE_QUOTE_WITH_WHITESPACE1=word1 word2 word3]
[SINGLE_QUOTE_WITH_WHITESPACE2=  word1 word2 word3  ]
[DOUBLE_QUOTE_WITH_HASHTAG=abde#fghi]
[SINGLE_QUOTE_WITH_HASHTAG=abde#fghi]
[SINGLE_QUOTE_INSIDE_DOUBLE_QUOTE1=Test '123' test]
[SINGLE_QUOTE_INSIDE_DOUBLE_QUOTE2='123' test]
[SINGLE_QUOTE_INSIDE_DOUBLE_QUOTE3=test '123']
[SINGLE_QUOTE_INSIDE_DOUBLE_QUOTE4='123']
[MUTLIPLE_SINGLE_QUOTE_INSIDE_DOUBLE_QUOTE='abc' def 'ghi' jkl]
[DOUBLE_QUOTE_INSIDE_SINGLE_QUOTE1=Test \"123\" test]
[DOUBLE_QUOTE_INSIDE_SINGLE_QUOTE2=\"123\" test]
[DOUBLE_QUOTE_INSIDE_SINGLE_QUOTE3=Test \"123\"]
[DOUBLE_QUOTE_INSIDE_SINGLE_QUOTE4=\"123\"]
[MULTIPLE_DOUBLE_QUOTE_INSIDE_SINGLE_QUOTE={\"key1\": \"value1\",\"key2\": \"value2\"}]
[DOUBLE_QUOTE_WITH_INLINE_COMMENT1=word1]
[DOUBLE_QUOTE_WITH_INLINE_COMMENT2=word1 word2 word3]
[SINGLE_QUOTE_WITH_INLINE_COMMENT1=word1]
[SINGLE_QUOTE_WITH_INLINE_COMMENT2=word1 word2 word3]"
