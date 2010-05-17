\d .pattex_ut
\l pattex

// Pattex Tests

// ** TESTS

test_matchLit: {
  ret: ()

  pattex: `a
  seq: `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]
       
  pattex: `ab
  seq: `ab
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]

  pattex: `ab `cd
  seq: `ab `cd
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]

  pattex: `ab `cd `a1234
  seq: `ab `cd `a1234
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]
  
  pattex: `ab `cd `a12345
  seq: `ab `cd `a1234
  matchRet: .pattex.match[pattex; seq]
  ret: ret , (~.pattex.isMatch[matchRet])  

  :ret
}

test_matchOp: {
  ret: ()
  
  // Zero or more
  pattex: `a `PTXOP_ZERO_MORE
  seq: `
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 0) 
  
  pattex: `a `PTXOP_ZERO_MORE
  seq: `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 1) 

  pattex: `a `PTXOP_ZERO_MORE
  seq: `a `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 2) 

  pattex: `a `PTXOP_ZERO_MORE
  seq: `a `a `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 3)
  
  // One or more  
  pattex: `a `PTXOP_ONE_MORE
  seq: `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 1) 

  pattex: `a `PTXOP_ONE_MORE
  seq: `a `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 2) 

  pattex: `a `PTXOP_ONE_MORE
  seq: `a `a `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 3)  
  
  // Zero or one
  pattex: `a `PTXOP_ZERO_ONE
  seq: `
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 0) 
  
  pattex: `a `PTXOP_ZERO_ONE
  seq: `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 1)    
  
  pattex: `a `PTXOP_ZERO_ONE
  seq: `ba `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , (~.pattex.isMatch[matchRet])       
  ret: ret , (~(.pattex.getIncr[matchRet] = 1))
  
  // Match N   
  pattex: `a `PTXOP_MATCH_N `"1"
  seq: `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 1)    

  pattex: `a `PTXOP_MATCH_N `"2"
  seq: `a `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 2)    

  pattex: `a `PTXOP_MATCH_N `"3"
  seq: `a `a `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 3)
  
  // Match Not 
  pattex: `a `PTXOP_NOT
  seq: `b
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]

  pattex: `a `a `PTXOP_NOT
  seq: `a `b
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]  
   
  pattex: `a `a `PTXOP_ZERO_MORE `PTX_OP_NOT
  seq: `a `b
  matchRet: .pattex.match[pattex; seq]
  ret: ret , (~.pattex.isMatch[matchRet])       
  ret: ret , (~(.pattex.getIncr[matchRet] = 1))
   
  :ret
}

test_matchAlternation: {
  ret: ()

  pattex: `"(" `a `"|" `b `")"
  seq: `a
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]

  pattex: `"(" `a `"|" `b `")"
  seq: `b
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]
  
  pattex: `"(" `abc `"|" `bcd `"|" `eff `")"
  seq: `bcd
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]  
  
  pattex: `"(" `abc `"|" `bcd `"|" `eff `")" `PTXOP_ONE_MORE
  seq: `abc `eff
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 2)

  pattex: `"(" `abc `"|" `bcd `"|" `eff `")" `PTXOP_ONE_MORE
  seq: `abc `eff `bcd `abc
  matchRet: .pattex.match[pattex; seq]
  ret: ret , .pattex.isMatch[matchRet]       
  ret: ret , (.pattex.getIncr[matchRet] = 4)
      
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
  retMsg: retMsg , (,("pattex_UT TEST RESULTS"))
  retMsg: retMsg , (,("---------------------"))

  // Call Tests Here
  // Success reports number of test results returned in that test
  // Failure reports the first test result that is 0 = failure in that test
  
  // test_matchLit[]
  ret: test_matchLit[]    
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchLit[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchLit[] FAILED (" , ($(ret ? 0)) , ")"))]
  testCount +: (#ret)
  allMatched: allMatched , (+/ret) = (#ret)

  // test_matchOp[]
  ret: test_matchOp[]  
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchOp[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchOp[] FAILED (" , ($(ret ? 0)) , ")"))]  
  testCount +: (#ret)
  allMatched: allMatched , (+/ret) = (#ret)

  // test_matchAlternation[]
  ret: test_matchAlternation[]  
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test matchAlternation[] SUCCEEDED (" , ($(#ret)) , ")")) ; retMsg: retMsg , (,("Test matchAlternation[] FAILED (" , ($(ret ? 0)) , ")"))]
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
// /pattex Tests