\d .regex_ut
\l regex2

// Regex Tests

// ** TESTS

test_matchLit: {
  ret: ()
  
  isSkipWS: 0    

  regex: "abC123"
  str: "abC123"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]
  
  regex: "abC"
  str: "abC"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]
  
  regex: "a"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]

  regex: "ab"
  str: "ab"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]
  
  regex: "a"
  str: "b"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])

  regex: "ab"
  str: "bb"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])

  regex: "abc"
  str: "bbc"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])

  regex: "abcde"
  str: "abcd"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])
  
  regex: "bcde"
  str: "abcde"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])
  
  regex: "abde"
  str: "abcde"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])
     
  :ret
}

test_matchEntity: {
  ret: ()
       
  isSkipWS: 0
  
  regex: "\\d"
  str: "1"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\c"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\C"
  str: "A"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  
  regex: "\\w"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\w"
  str: "A"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\a"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\a"
  str: "A"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\a"
  str: "1"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\v"
  str: "*"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\v"
  str: "+"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\v"
  str: "&"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\r"
  str: "'"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\r"
  str: "\\"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\p"
  str: " "
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\s"
  str: " "
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\s"
  str: "\t"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\l"
  str: " "
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\l"
  str: "\t"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\l"
  str: "\n"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]  
  
  
  regex: "\\c\\c"
  str: "ab"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\C\\C"
  str: "AB"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]
  
  regex: "\\d\\d\\d"
  str: "123"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\c\\c\\c"
  str: "abc"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       

  regex: "\\C\\C\\C"
  str: "ABC"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]  

  regex: "\\d\\c\\C\\a\\v\\r\\p\\s\\l"
  str: "1aCa*' \t\n"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]     
            
  :ret
}

test_matchMixedIncrement: {
  ret: ()
       
  isSkipWS: 0
  
  regex: "\\d2"
  str: "12"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 2)       
  
  regex: "\\d2"
  str: "13"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])  
  ret: ret , (.regex.getIncr[matchRet] = 0)  
  
  regex: "1\\d"
  str: "13"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet] 
  ret: ret , (.regex.getIncr[matchRet] = 2)
  
  regex: "456\\d&\\d"
  str: "4561&3"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet] 
  ret: ret , (.regex.getIncr[matchRet] = 6) 

  regex: "\\d\\c\\C\\a\\v\\r\\p\\s\\l1aCa&' "
  str: "1aCa&' \t\n1aCa&' "
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]
  ret: ret , (.regex.getIncr[matchRet] = 16)  

  regex: "1aCa&' \\d\\c\\C\\a\\v\\r\\p\\s\\l1aCa&' "
  str: "1aCa&' 1aCa&' \t\n1aCa&' "
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]
  ret: ret , (.regex.getIncr[matchRet] = 23) 
  
  regex: "456\\d\\c&=\\C\\a\\v\\r\\p\\s\\labc"
  str: "4561a&=Ca%' \t\nabc"
  matchRet: .regex.match[regex; str; isSkipWS]    
  ret: ret , .regex.isMatch[matchRet]
  ret: ret , (.regex.getIncr[matchRet] = 17)
      
  :ret
}

test_matchOp: {
  ret: ()
       
  isSkipWS: 0
  
  // Zero or more
  regex: "1*"
  str: ""
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 0) 
  
  regex: "1*"
  str: "1"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 1)
  
  regex: "\\d*"
  str: "123"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 3)

  regex: "\\d23*"
  str: "123523"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 6)
  
  regex: "\\d*"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 0)
      
  // Escape test
  regex: "\\**"
  str: ""
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 0) 
  
  // One or more
  regex: "1+"
  str: ""
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet]) 
  
  regex: "1+"
  str: "1"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 1)
  
  regex: "\\d+"
  str: "123"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 3)
  
  regex: "\\d+"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])
  
  regex: "123+"
  str: "1231233456"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 6)    
       
  // Escape test 
  regex: "\\++"
  str: "+++"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 3)
  
  // Zero or one
  regex: "1$"
  str: ""
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 0) 
  
  regex: "1$"
  str: "1"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 1)
  
  regex: "\\d$"
  str: "123"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 1)
  
  regex: "\\d$"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 0)
  
  // Not
  regex: "1^"
  str: ""
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 0) 

  regex: "1^"
  str: "1"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])       
  
  regex: "\\d^"
  str: "123"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])       
  
  regex: "\\d$"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 0) 

  // Match N
  regex: "1#{0}"
  str: ""
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 0) 

  regex: "1#{1}"
  str: ""
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])

  regex: "1#{10}"
  str: "1111111111"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 10)
  
  regex: "\\d23#{9}"
  str: "12322332377828"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 9)

  regex: "\\d#{2}"
  str: "123"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , (~.regex.isMatch[matchRet])       
  
  regex: "\\d#{0}"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 0)   
               
  regex: "\\d#{1}"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , (~.regex.isMatch[matchRet])  
   
  :ret
}

test_matchOpExpressions: {
  ret: ()
       
  isSkipWS: 0
  
  regex: "\\a\\d+"
  str: "a4"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 2) 

  :ret
}

test_matchAlternation: {
  ret: ()
       
  isSkipWS: 0
  
  regex: "(a|b)+"
  str: "a"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 1) 

  regex: "(a|b)+"
  str: "b"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 1)
  
  regex: "(a|b)+"
  str: "ab"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]   
  ret: ret , (.regex.getIncr[matchRet] = 2)

  regex: "(a|b)+"
  str: "ba"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 2) 

  regex: "(a|b)+"
  str: "baab"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 4) 
  
  regex: "(aa|bb)+"
  str: "aabb"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 4)   

  regex: "(aa\\d|bb)+"
  str: "aa1"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 3) 
  
  regex: "(aa\\d|\\cbb)+"
  str: "dbb"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 3)    

  regex: "(aa\\d|\\cbb|\\v\\d\\d\\d)+"
  str: "&100"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 4) 
    
  regex: "(aa\\d|\\cbb|\\v\\d\\d\\d)+"
  str: "&100^123"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 8)

  regex: "(aa\\d|\\cbb|\\v\\d\\d\\d)+"
  str: "&100^123aa1ebb"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 14)  

  regex: "(aa\\d|\\cbb|\\v\\d\\d\\d)+"
  str: "&100^123aa1ebb&100^123aa1ebb&100^123aa1ebb"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 42)
      
  :ret
}

test_matchWS: {
  ret: ()
       
  isSkipWS: 1
  
  regex: "\\a\\d+"
  str: " a4"
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 2)
  
  regex: "(aa\\d|\\cbb|\\v\\d\\d\\d)+"
  str: "&10 0"
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 4)   

  regex: "(aa\\d|\\cbb|\\v\\d\\d\\d)+"
  str: " &10 0^123 aa1 ebb "
  matchRet: .regex.match[regex; str; isSkipWS]  
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 14) 

  regex: "\\d#{3}"
  str: " 1 23 "
  matchRet: .regex.match[regex; str; isSkipWS]
  ret: ret , .regex.isMatch[matchRet]       
  ret: ret , (.regex.getIncr[matchRet] = 3) 
  
  :ret
}

// ** /TESTS

// ** HARNESS

// Harness runs all tests and reports on results. By convention, user calls runTests[] to run all tests and generate
//	report of results
runTests: {
  ret: ()
  testCount: 0
  allMatched: ()
  
  retMsg: (,(""))
  retMsg: retMsg , (,("regex_UT TEST RESULTS"))
  retMsg: retMsg , (,("---------------------"))

  // Call Tests Here
  // Success reports number of test results returned in that test
  // Failure reports the first test result that is 0 = failure in that test
  
  // test_matchLit[]
  ret: test_matchLit[]    
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchLit[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchLit[] FAILED (" , ($(ret ? 0)) , ")"))]
  testCount +: (#ret)
  allMatched: allMatched , (+/ret) = (#ret)

  // test_matchEntity[]
  ret: test_matchEntity[]  
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchEntity[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchEntity[] FAILED (" , ($(ret ? 0)) , ")"))]
  testCount +: (#ret)
  allMatched: allMatched , (+/ret) = (#ret)

  // test_matchMixedIncrement[]
  ret: test_matchMixedIncrement[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchMixedIncrement[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchMixedIncrement[] FAILED (" , ($(ret ? 0)) , ")"))]
  testCount +: (#ret)
  allMatched: allMatched , (+/ret) = (#ret)

  // test_matchOp[]
  ret: test_matchOp[]  
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchOp[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchOp[] FAILED (" , ($(ret ? 0)) , ")"))]  
  testCount +: (#ret)
  allMatched: allMatched , (+/ret) = (#ret)

  // test_matchOpExpressions[]
  ret: test_matchOpExpressions[]  
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchOpExpressions[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchOpExpressions[] FAILED (" , ($(ret ? 0)) , ")"))]
  testCount +: (#ret)
  allMatched: allMatched , (+/ret) = (#ret)

  // test_matchAlternation[]
  ret: test_matchAlternation[]  
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchAlternation[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchAlternation[] FAILED (" , ($(ret ? 0)) , ")"))]
  testCount +: (#ret)
  allMatched: allMatched , (+/ret) = (#ret)

  // test_matchWS[]
  ret: test_matchWS[]  
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchWS[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchWS[] FAILED (" , ($(ret ? 0)) , ")"))]
  testCount +: (#ret)
  allMatched: allMatched , (+/ret) = (#ret)

  // Report All Results
  retMsg: retMsg , (,(""))
  retMsg: retMsg , (,(($testCount) , " Tests Run"))
  :[(+/allMatched) = (#allMatched); retMsg: retMsg , (,"All Tests SUCCEEDED"); retMsg: retMsg , (,"Some Tests FAILED")]
  retMsg: retMsg , (,(""))
  
  :retMsg
}

// ** /HARNESS
// /Regex Tests