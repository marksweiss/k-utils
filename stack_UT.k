// ************** 
// File: stack_UT.k
// Descr: Unit Tests for stack.k - stack data structure 
// \d stack -- loads stack.k and is intended to be run standalone with that module to test it
// **************

\l stack
\l utils


// ** TESTS

// stack: .stack.ctor[]
// Return invariants:
// An initialized stack should have one element, the designated symbol for an empty stack
test_ctor: {
  ret: ()
  
  stack: .stack.ctor[stack]
  ret: ret , (((#stack) = 1) & (stack[0] = `EMPTY)) 
  
  :ret
}

// stack: .stack.count[stack]
// Return invariants:
// Count of stack should always increment by one for each push[], and decrement by one for each pop[]
// An initialized stack should have a count of 0
// Popping an empty stack does not change the state of the stack
test_count: {
  ret: ()
  
  // An initialized stack should have a count of 0
  stack: .stack.ctor[stack]  
  ret: ret , (.stack.count[stack] = 0)

  // Count of stack should always increment by one for each push[], and decrement by one for each pop[]
  stack: .stack.push[5; stack]
  ret: (.stack.count[stack] = 1)

  stack: .stack.push["C"; stack]
  stack: .stack.push[.5; stack]
  stack: .stack.push[`SeeWhatYouHaveDone; stack]
  ret: ret , (.stack.count[stack] = 4)
 
  stack: .stack.pop[stack] 
  ret: ret , (.stack.count[stack] = 3)

  stack: .stack.pop[stack]
  stack: .stack.pop[stack]
  stack: .stack.pop[stack]
  ret: ret , (.stack.count[stack] = 0)
  
  // Popping an empty stack does not change the state of the stack
  stack: .stack.pop[stack]
  ret: ret , (.stack.count[stack] = 0)

  :ret
}

// stack: .stack.push[item; stack]
// stack: .stack.pop[stack]
// item: .stack.peek[stack]
// Return invariants: 
// Stack should contain each item added
// Items should be removed by pop in LIFO order
// The stack should contain only those items added and never contain those items removed
// peek[] is idempotent
test_push_pop_peek: {
  ret: ()
  
  // Stack should contain each item added
  // Items added should be retrieved by pop in LIFO order
  push1: 5
  push2: .5
  push3: "C"
  push4: `SeeWhatYouHaveDone
  
  stack: .stack.ctor[stack] 
  
  stack: .stack.push[push1; stack]
  stack: .stack.push[push2; stack]
  stack: .stack.push[push3; stack]
  stack: .stack.push[push4; stack]
    
  // peek[] is idempotent
  peek4: .stack.peek[stack]
  peek4: .stack.peek[stack]
  stack: .stack.pop[stack]  
  //
  peek3: .stack.peek[stack]
  stack: .stack.pop[stack]
  peek2: .stack.peek[stack]
  stack: .stack.pop[stack]
  peek1: .stack.peek[stack]
  stack: .stack.pop[stack]
   
  ret: ret , ((peek4 = push4) & (peek3 = push3) & (peek2 = push2) & (peek1 = push1))
    
  // The stack should contain only those items added and never contain those items removed
  peek0: .stack.peek[stack]

  stack: .stack.pop[stack]
  peek0: .stack.peek[stack]
  ret: ret , (.utils.isNil[peek0])
  
  :ret
}

// stack: .stack.push[item; stack]
// stack: .stack.pop[stack]
// item: .stack.peekN[stack]
// Return invariants: 
// Stack should contain each item added
// Items should be removed by pop in LIFO order
// The stack should contain only those items added and never contain those items removed
// peekN[] is idempotent. peekN returns copy of value at index N or _n if index is invalid
test_push_pop_peekN: {
  ret: ()
  
  // Stack should contain each item added
  // Items added should be retrieved by pop in LIFO order
  push1: 5
  push2: .5
  push3: "C"
  push4: `SeeWhatYouHaveDone
  
  stack: .stack.ctor[stack] 
  
  stack: .stack.push[push1; stack]
  stack: .stack.push[push2; stack]
  stack: .stack.push[push3; stack]
  stack: .stack.push[push4; stack]
  
  // peekN[] at different valid indexes
  peekNRet: .stack.peekN[0; stack]
  ret: ret , (peekNRet = push1)
  peekNRet: .stack.peekN[1; stack]
  ret: ret , (peekNRet = push2)
  peekNRet: .stack.peekN[2; stack]
  ret: ret , (peekNRet = push3)
  peekNRet: .stack.peekN[3; stack]
  ret: ret , (peekNRet = push4)
  
  // peek[] is idempotent
  peek4: .stack.peekN[.stack.count[stack] - 1; stack]
  peek4: .stack.peekN[.stack.count[stack] - 1; stack]
  stack: .stack.pop[stack]  
  //
  peek3: .stack.peekN[.stack.count[stack] - 1; stack]
  stack: .stack.pop[stack]
  peek2: .stack.peekN[.stack.count[stack] - 1; stack]
  stack: .stack.pop[stack]
  peek1: .stack.peekN[.stack.count[stack] - 1; stack]
  stack: .stack.pop[stack]
   
  ret: ret , ((peek4 = push4) & (peek3 = push3) & (peek2 = push2) & (peek1 = push1))
  
  :ret
}

// stack: .stack.pushListItems[item; stack]
// stack: .stack.pop[stack]
// item: .stack.peek[stack]
// Return invariants: 
// Stack should contain each item added
// Items should be removed by pop in LIFO order
// The stack should contain only those items added and never contain those items removed
// peek[] is idempotent
test_pushListItems_pop_peek: {
  ret: ()
  
  // Stack should contain each item added
  // Items added should be retrieved by pop in LIFO order
  push1: 5
  push2: .5
  push3: "C"
  push4: `SeeWhatYouHaveDone
  
  pushItems: (push1; push2; push3; push4)
  
  stack: .stack.ctor[stack] 
  
  stack: .stack.pushListItems[pushItems; stack]
      
  // peek[] is idempotent
  peek4: .stack.peek[stack]
  peek4: .stack.peek[stack]
  stack: .stack.pop[stack]  
  //
  peek3: .stack.peek[stack]
  stack: .stack.pop[stack]
  peek2: .stack.peek[stack]
  stack: .stack.pop[stack]
  peek1: .stack.peek[stack]
  stack: .stack.pop[stack]
   
  ret: ret , ((peek4 = push4) & (peek3 = push3) & (peek2 = push2) & (peek1 = push1))
    
  // The stack should contain only those items added and never contain those items removed
  peek0: .stack.peek[stack]

  stack: .stack.pop[stack]
  peek0: .stack.peek[stack]
  ret: ret , (.utils.isNil[peek0])
  
  :ret
}

// stack: .stack.pushStack[stackItem; stack]
// Return invariants: 
// Stack should contain stack item added, at its top, nested to one level of depth so that the stack items are
//	together as a unit on the containing stack
test_pushStack: {
  ret: ()
  
  // Stack should contain each item added
  // Items added should be retrieved by pop in LIFO order
  push1: 5
  push2: .5
  push3: "C"
  push4: `SeeWhatYouHaveDone
  
  stackItem: .stack.ctor[stackItem] 
  stackItem: .stack.push[push1; stackItem]
  stackItem: .stack.push[push2; stackItem]
  stackItem: .stack.push[push3; stackItem]
  stackItem: .stack.push[push4; stackItem]
  
  stack: .stack.ctor[]
  stack: .stack.pushStack[stackItem; stack]
    
  // Stack should contain stack item added, at its top, nested to one level of depth
  peekStackItem: .stack.peek[stack]
   
  ret: ret , (stackItem = peekStackItem)
  
  // Now pop the stackItem, the containing stack should be empty, stackItem should come off as a unit
  stack: .stack.pop[stack]  
  ret: ret , (.stack.isEmpty[stack])
  
  // Now push on some items, then push on the stackItem, then some more items, verify the entire contents
  //  of the stackItem are one item on the parent stack, and are not joined with other items on the containing stack
  push5: 10
  push6: .10
  push7: "D"
  push8: `SeeWhatIHaveDone
  stack: .stack.push[push5; stack]  
  stack: .stack.push[push6; stack]
  stack: .stack.pushStack[stackItem; stack]
  stack: .stack.push[push7; stack]
  stack: .stack.push[push8; stack]
  // Count should be 5 items
  ret: ret , ((.stack.count[stack]) = 5)    
  
  // Pop top item, then peek and pop item adjacent to stackItem, verify its value
  stack: .stack.pop[stack]  
  peek7: .stack.peek[stack]
  stack: .stack.pop[stack]
  ret: ret , (peek7 = push7)
  
  // Then pop stackItem, verify its value and the containing stack count
  peekStackItem: .stack.peek[stack]
  stack: .stack.pop[stack]
  ret: ret , (stackItem = peekStackItem)
  
  // Then pop next item, which was also adjacent to stackItem, verify its value
  peek6: .stack.peek[stack]
  stack: .stack.pop[stack]
  ret: ret , (peek6 = push6)
  
  // There should be one item left ...
  ret: ret , ((.stack.count[stack]) = 1)
  stack: .stack.pop[stack]
  
  // ... and now none left   
  ret: ret , (.stack.isEmpty[stack])
  
  :ret
}

// stack: .stack.pushList[lstItem; stack]
// Return invariants: 
// Stack should contain list/vector item added, at its top, nested to one level of depth so that the list/vector items are
//	together as a unit on the containing stack
test_pushList: {
  ret: ()
  
  // Stack should contain each item added
  // Items added should be retrieved by pop in LIFO order
  push1: 5
  push2: .5
  push3: "C"
  push4: `SeeWhatYouHaveDone
  
  lstItem: (push1; push2; push3; push4)
  
  stack: .stack.ctor[]
  stack: .stack.pushList[lstItem; stack]
    
  // Stack should contain list item added, at its top, nested to one level of depth
  peekLstItem: .stack.peek[stack]
   
  ret: ret , (lstItem = peekLstItem)
  
  // Now pop the lstItem, the containing stack should be empty, lstItem should come off as a unit
  stack: .stack.pop[stack]  
  ret: ret , (.stack.isEmpty[stack])
  
  // Now push on some items, then push on the lstItem, then some more items, verify the entire contents
  //  of the lstItem are one item on the parent stack, and are not joined with other items on the containing stack
  push5: 10
  push6: .10
  push7: "D"
  push8: `SeeWhatIHaveDone
  stack: .stack.push[push5; stack]  
  stack: .stack.push[push6; stack]
  stack: .stack.pushList[lstItem; stack]
  stack: .stack.push[push7; stack]
  stack: .stack.push[push8; stack]
  // Count should be 5 items
  ret: ret , ((.stack.count[stack]) = 5)    
  
  // Pop top item, then peek and pop item adjacent to lstItem, verify its value
  stack: .stack.pop[stack]  
  peek7: .stack.peek[stack]
  stack: .stack.pop[stack]
  ret: ret , (peek7 = push7)
  
  // Then pop lstItem, verify its value and the containing stack count
  peekLstItem: .stack.peek[stack]
  stack: .stack.pop[stack]
  ret: ret , (lstItem = peekLstItem)
  
  // Then pop next item, which was also adjacent to lstItem, verify its value
  peek6: .stack.peek[stack]
  stack: .stack.pop[stack]
  ret: ret , (peek6 = push6)
  
  // There should be one item left ...
  ret: ret , ((.stack.count[stack]) = 1)
  stack: .stack.pop[stack]
  
  // ... and now none left   
  ret: ret , (.stack.isEmpty[stack])
  
  :ret
}

// stack: .stack.popN[stack]
// Return invariants:
// Count of stack should always decrement by N for N pop[] operations
// Popping an empty stack does not change the state of the stack
test_popN: {
  ret: ()
  
  stack: .stack.ctor[stack]  

  // Count of stack should always decrement by one for N pop[] operations
  stack: .stack.push[5; stack]
  stack: .stack.push["C"; stack]
  stack: .stack.push[.5; stack]
  stack: .stack.push[`SeeWhatYouHaveDone; stack]
  ret: ret , (.stack.count[stack] = 4)

  stack: .stack.popN[4; stack]
  ret: ret , (.stack.count[stack] = 0)

  stack: .stack.push[5; stack]
  stack: .stack.push["C"; stack]
  stack: .stack.push[.5; stack]
  stack: .stack.push[`SeeWhatYouHaveDone; stack]

  stack: .stack.popN[2; stack]
  ret: ret , (.stack.count[stack] = 2)
  stack: .stack.popN[2; stack]
  ret: ret , (.stack.count[stack] = 0)
  
  // Popping an empty stack does not change the state of the stack
  stack: .stack.popN[50; stack]
  ret: ret , (.stack.count[stack] = 0)

  :ret
}

// stack: .stack.getAsList[stack]
// Return invariants:
// Stack passed in should be unchanged
// Return value should be a list corresponding to the items in the stack, in order from 0th ordinal
//  corresponding to stack order (order of items as they would be popped off the stack).
test_getAsList: {
  ret: ()
    
  push1: 5
  push2: "C"
  push3: .5
  push4: `SeeWhatYouHaveDone

  stack: .stack.ctor[stack]

  // Return value should be a list corresponding to the items in the stack
  stack: .stack.push[push1; stack]
  stack: .stack.push[push2; stack]
  stack: .stack.push[push3; stack]
  stack: .stack.push[push4; stack]
  asList: .stack.getAsList[stack]
  
  ret: ret , (asList[0] = push4)
  ret: ret , (asList[1] = push3)
  ret: ret , (asList[2] = push2)
  ret: ret , (asList[3] = push1)
  
  // Stack passed in should be unchanged
  peek4: .stack.peek[stack]
  stack: .stack.pop[stack]  
  peek3: .stack.peek[stack]
  stack: .stack.pop[stack]
  peek2: .stack.peek[stack]
  stack: .stack.pop[stack]
  peek1: .stack.peek[stack]
  stack: .stack.pop[stack]
  
  ret: ret , ((peek4 = push4) & (peek3 = push3) & (peek2 = push2) & (peek1 = push1))
    
  // Test single item case
  stack: .stack.ctor[stack]  
  stack: .stack.push[5; stack]
  asList: .stack.getAsList[stack]
  
  ret: ret , (asList[0] = 5)

  :ret
}

// stack: .stack.clear[stack]
// Return invariants: 
// This empties the stack passed in, so that isEmpty[stack] = 1, and returns that emptied stack
test_clear: {
  ret: ()
  
  stack: .stack.ctor[stack] 
  
  stack: .stack.push[push1; stack]
  stack: .stack.push[push2; stack]
  
  ret: ret , (.stack.count[stack] = 2)
  
  stack: .stack.clear[stack]
  
  ret: ret , (.stack.count[stack] = 0)
  ret: ret , .stack.isEmpty[stack]
  
  :ret
}

// pred: .stack.isEmpty[stack]
// Return invariants:
// An initialized stack is empty
// A stack is not empty if it has had more push operations than pop operations since it was initialized, 
//	otherwise it is empty
// Popping an empty stack does not change the state of the stack, and it remains empty afterward
test_isEmpty: {
  ret: ()
  
  // An initialized stack is empty
  stack: .stack.ctor[stack]
  ret: ret , ((.stack.isEmpty[stack]) = 1)

  // A stack is not empty if it has had more push operations than pop operations since it was initialized, 
  //	otherwise it is empty
  stack: .stack.push[100; stack]
  ret: ret , ((.stack.isEmpty[stack]) = 0)
  stack: .stack.push[101; stack]
  ret: ret , ((.stack.isEmpty[stack]) = 0)

  stack: .stack.pop[stack]
  ret: ret , ((.stack.isEmpty[stack]) = 0)
  stack: .stack.pop[stack]
  ret: ret , ((.stack.isEmpty[stack]) = 1)

  // Popping an empty stack does not change the state of the stack, and it remains empty afterward
  stack: .stack.pop[stack]
  ret: ret , ((.stack.isEmpty[stack]) = 1)

  :ret
}

// pred: .stack.isStack[stack]
// Return invariants:
// Returns true only if the arg is a list type, with at least one element, and with an element at position
//  #stack - 1 that is the designated symbol `EMPTY.  Otherwise returns false.
// Works in concert with .stack.ctor[] and other .stack functions so that objects constructed by that function
//	are stacks after any .stack operation
test_isStack: {
  ret: ()
  
  // Construct and perform every operation on a stack to insure it is still a stack after each one
  stack: .stack.ctor[stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  stack: .stack.push[100; stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  val: .stack.peek[stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  stack: .stack.pop[stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  stack: .stack.pushList[(1; 2; 3.5); stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  stack: .stack.pushListItems[(1; 2; 3.5); stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  stack: .stack.popN[1; stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  stack: .stack.pushStack[.stack.ctor[]; stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  val: .stack.getAsList[stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  stack: .stack.clear[stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  val: .stack.count[stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  val: .stack.isEmpty[stack]
  ret: ret , ((.stack.isStack[stack]) = 1)
  
  // Test lists/vectors/atoms to insure they are not stacks
  notStack: 1
  ret: ret , ((.stack.isStack[notStack]) = 0)
  notStack: 1.1
  ret: ret , ((.stack.isStack[notStack]) = 0)
  notStack: "1"
  ret: ret , ((.stack.isStack[notStack]) = 0)
  notStack: `a
  ret: ret , ((.stack.isStack[notStack]) = 0)
  notStack: 1 1
  ret: ret , ((.stack.isStack[notStack]) = 0)
  notStack: 1.1 1.1
  ret: ret , ((.stack.isStack[notStack]) = 0)
  notStack: `a `a
  ret: ret , ((.stack.isStack[notStack]) = 0)
  notStack: "11"
  ret: ret , ((.stack.isStack[notStack]) = 0)
  notStack: (1; 1.1; `a; "1")
  ret: ret , ((.stack.isStack[notStack]) = 0)

  :ret
}

// ** /TESTS


// ** HARNESS

// Harness runs all tests and reports on results. By convention, user calls runTests[] to run all tests and generate
//	report of results
runTests: {
  ret: ()
  retMsg: (,(""))
  retMsg: retMsg , (,(""))
  retMsg: retMsg , (,("stack_UT TEST RESULTS"))
  retMsg: retMsg , (,("---------------------"))

  // Call Tests Here
  
  // test_ctor[]	
  ret: test_ctor[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.ctor[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.ctor[] FAILED"))]

  // test_count[]	
  ret: test_count[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.count[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.count[] FAILED"))]

  // test_push_pop_peek[]
  ret: test_push_pop_peek[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.push[], pop[], peek[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.push[], pop[], peek[] FAILED"))]

  // test_push_pop_peekN[]
  ret: test_push_pop_peekN[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.push[], pop[], peekN[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.push[], pop[], peekN[] FAILED"))]

  // test_pushListItems_pop_peek[]
  ret: test_pushListItems_pop_peek[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.pushListItems[], pop[], peek[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.pushListItems[], pop[], peek[] FAILED"))]

  // test_pushStack[]
  ret: test_pushStack[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.pushStack[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.pushStack[] FAILED"))]

  // test_pushList[]
  ret: test_pushList[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.pushList[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.pushList[] FAILED"))]

  // test_popN[]
  ret: test_popN[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.popN[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.popN[] FAILED"))]

  // test_getAsList[]
  ret: test_getAsList[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.getAsList[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.getAsList[] FAILED"))]

  // test_clear[]
  ret: test_clear[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.clear[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.clear[] FAILED"))]
  
  // test_count[]	
  ret: test_count[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.count[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.count[] FAILED"))]

  // test_isEmpty[]
  ret: test_isEmpty[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.isEmpty[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.isEmpty[] FAILED"))]

  // test_isStack
  ret: test_isStack[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .stack.isStack[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .stack.isStack[] FAILED"))]

  // /Call Tests Here

  retMsg: retMsg , (,(""))
  retMsg: retMsg , (,(""))
  
  :retMsg
}

// ** /HARNESS