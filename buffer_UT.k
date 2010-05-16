// ************** 
// File: buffer_UT.k
// Descr: Unit Tests for buffer.k - buffer data structure 
// \d buffer -- loads buffer.k and is intended to be run standalone with that module to test it
// **************

\l buffer
\l utils


// ** TESTS

// buffer: .buffer.ctor[data]
// Return invariants:
// An initialized buffer should have three elements, the designated symbol for an empty buffer as its
//  data element, and previous and current offset values of 0
test_ctor: {
  ret: ()
  
  data: `A `B `C
  buffer: .buffer.ctor[data]
  ret: ret , (((#buffer) = 3) & (.utils.extEquals[buffer[0]; data]) & (buffer[1] = 0) & (buffer[2] = 0)) 
  
  :ret
}

// buffer: .buffer.count[buffer]
// Return invariants:
// Count of buffer is constant whatever operations are performed on the buffer; storage bound to buffer is immutable
// An initialized buffer should have a count = (#(bound storage))
test_count: {
  ret: ()
  
  // An initialized buffer should have a count = (#(bound storage))
  data: `A `B `C
  dataCount: #data
  buffer: .buffer.ctor[data]  
  ret: ret , (.buffer.count[buffer] = dataCount)

  // Count of buffer is constant whatever operations are performed
  // Test count remaining unchanged after all write operations on buffer
  buffer: .buffer.inc[buffer]
  ret: ret , (.buffer.count[buffer] = dataCount)
  buffer: .buffer.dec[buffer]
  ret: ret , (.buffer.count[buffer] = dataCount)
  buffer: .buffer.incN[buffer; 1]
  ret: ret , (.buffer.count[buffer] = dataCount)
  buffer: .buffer.decN[buffer; 1]
  ret: ret , (.buffer.count[buffer] = dataCount)
  buffer: .buffer.setOffset[buffer; 0]
  ret: ret , (.buffer.count[buffer] = dataCount)
  val: .buffer.getDataItem[buffer]
  ret: ret , (.buffer.count[buffer] = dataCount)

  :ret
}

// buffer: .buffer.inc[buffer]
// buffer: .buffer.dec[buffer]
// buffer: .buffer.getOffset[buffer]
// Return invariants: 
// Buffer offset should be incremented by one after inc[], unless that would place it out of bounds
// Buffer offset should be decremented by one after dec[], unless that would place it out of bounds
test_inc_dec_getOffset: {
  ret: ()
  
  // Buffer offset should be incremented by one after inc[], unless that would place it out of bounds
  data: `A `B `C
  buffer: .buffer.ctor[data]  
  
  oldOffset: .buffer.getOffset[buffer]  
  buffer: .buffer.inc[buffer]  
  newOffset: .buffer.getOffset[buffer]
  ret: ret , (newOffset = (oldOffset + 1))

  // Buffer offset should be decremented by one after dec[], unless that would place it out of bounds
  oldOffset: .buffer.getOffset[buffer]
  buffer: .buffer.dec[buffer]  
  newOffset: .buffer.getOffset[buffer]
  ret: ret , (newOffset = (oldOffset - 1))
    
  :ret
}

// buffer: .buffer.incN[buffer]
// buffer: .buffer.decN[buffer]
// buffer: .buffer.getOffset[buffer]
// Return invariants: 
// Buffer offset should be incremented by N after incN[], unless that would place it out of bounds
// Buffer offset should be decremented by N after decN[], unless that would place it out of bounds
test_incN_decN_getOffset: {
  ret: ()
  
  // Buffer offset should be incremented by N after incN[], unless that would place it out of bounds
  data: `A `B `C
  buffer: .buffer.ctor[data]  
  
  oldOffset: .buffer.getOffset[buffer]
  buffer: .buffer.incN[buffer; 2]  
  newOffset: .buffer.getOffset[buffer]
  ret: ret , (newOffset = (oldOffset + 2))

  // Buffer offset should be decremented by N after decN[], unless that would place it out of bounds
  oldOffset: .buffer.getOffset[buffer]
  buffer: .buffer.decN[buffer; 2]  
  newOffset: .buffer.getOffset[buffer]
  ret: ret , (newOffset = (oldOffset - 2))
    
  :ret
}

// buffer: .buffer.decPrevN[buffer]
// buffer: .buffer.setPrevOffset[buffer; idx]
// buffer: .buffer.getPrevOffset[]
// Return invariants: 
// For decPrevN: buffer previous offset should be decremented by N, unless that would place it out of bounds
// For setPrevOffset: buffer previous offset should be set to idx, unless that would place it out of bounds
// For getPrevOffset: Return should be last value set by decPrevN or setPrevOffset
test_decPrevN_setPrevOffset_getPrevOffset: {
  ret: ()
  
  // Buffer offset should be incremented by N after incN[], unless that would place it out of bounds
  data: `A `B `C
  buffer: .buffer.ctor[data]  
  
  oldOffset: .buffer.getOffset[buffer]
  buffer: .buffer.incN[buffer; 2]  
  newOffset: .buffer.getOffset[buffer]
  ret: ret , (newOffset = (oldOffset + 2))

  oldPrevOffset: .buffer.getPrevOffset[buffer]
  buffer: .buffer.setPrevOffset[buffer; 2]  
  newPrevOffset: .buffer.getPrevOffset[buffer]
  ret: ret , (newPrevOffset = (oldPrevOffset + 2))

  // Buffer offset should be decremented by N after decN[], unless that would place it out of bounds
  oldPrevOffset: .buffer.getPrevOffset[buffer]
  buffer: .buffer.decPrevN[buffer; 2]  
  newPrevOffset: .buffer.getPrevOffset[buffer]
  ret: ret , (newPrevOffset = (oldPrevOffset - 2))
    
  :ret
}

// buffer: .buffer.setOffset[buffer; N]
// Return invariants: 
// Buffer offset should have value N after setOffset[], unless that would place it out of bounds
test_setOffset: {
  ret: ()
  
  // Buffer offset should have value N after setOffset[], unless that would place it out of bounds
  data: `A `B `C
  buffer: .buffer.ctor[data]

  offsetToSet: 1   
  buffer: .buffer.setOffset[buffer; offsetToSet]  
  newOffset: .buffer.getOffset[buffer]
  ret: ret , (newOffset = offsetToSet)

  offsetToSet: 2   
  buffer: .buffer.setOffset[buffer; offsetToSet]  
  newOffset: .buffer.getOffset[buffer]
  ret: ret , (newOffset = offsetToSet)
    
  :ret
}

// buffer: .buffer.getDataItem[buffer]
// Return invariants: 
// Should return the data at index of the current offset of the buffer, from the storage bound to the buffer 
test_getDataItem: {
  ret: ()
  
  // Should return the data at index of the current offset of the buffer, from the storage bound to the buffer
  data: `A `B `C
  buffer: .buffer.ctor[data]

  // Retrieval from initialized buffer
  val: .buffer.getDataItem[buffer]  
  ret: ret , (val = data[0])

  // Retrieval after all inc and dec operations
  buffer: .buffer.inc[buffer]
  val: .buffer.getDataItem[buffer]  
  ret: ret , (val = data[1])

  buffer: .buffer.dec[buffer]
  val: .buffer.getDataItem[buffer]  
  ret: ret , (val = data[0])
  
  buffer: .buffer.incN[buffer; 2]  
  val: .buffer.getDataItem[buffer]  
  ret: ret , (val = data[2])

  buffer: .buffer.decN[buffer; 2]  
  val: .buffer.getDataItem[buffer]  
  ret: ret , (val = data[0]) 
  
  buffer: .buffer.setOffset[buffer; 1] 
  val: .buffer.getDataItem[buffer]  
  ret: ret , (val = data[1])
    
  :ret
}

// buffer: .buffer.getDataItemsRange[lbound; count; buffer]
// Return invariants: 
// Should return the data itsm in the range of indexes specified, from the storage bound to the buffer 
test_getDataItemsRange: {
  ret: ()
  
  // Should return the data at index of the current offset of the buffer, from the storage bound to the buffer
  data: `A `B `C `D
  buffer: .buffer.ctor[data]

  // Retrieval from initialized buffer
  val: .buffer.getDataItemsRange[buffer; 0; 1]  
  ret: ret , (val[0] = data[0])

  val: .buffer.getDataItemsRange[buffer; 0; 2]  
  ret: ret , (.utils.extEquals[val; data[!2]])

  val: .buffer.getDataItemsRange[buffer; 0; 4]
  ret: ret , (.utils.extEquals[val; data[!4]])

  :ret  
}

// buffer: .buffer.getAllDataItemsAsList[buffer]
// Return invariants: 
// List loaded into buffer should be retrieved and compare as identical
test_getAllDataItemsAsList: {
  ret: ()
  
  // Should return the data at index of the current offset of the buffer, from the storage bound to the buffer
  data: ,`A
  buffer: .buffer.ctor[data]
  ret: ret , (.utils.extEquals[.buffer.getAllDataItemsAsList[buffer]; data])
  ret: ret , (~(.utils.extEquals[.buffer.getAllDataItemsAsList[buffer]; `A `B]))
  ret: ret , (~(.utils.extEquals[.buffer.getAllDataItemsAsList[buffer]; ,`B]))

  data: `A `B `C `D
  buffer: .buffer.ctor[data]
  ret: ret , (.utils.extEquals[.buffer.getAllDataItemsAsList[buffer]; data])
  ret: ret , (~(.utils.extEquals[.buffer.getAllDataItemsAsList[buffer]; `A `B `C]))

  :ret  
}

// buffer: .buffer.isOffsetAtBeg[buffer]
// buffer: .buffer.isOffsetAtEnd[buffer]
// Return invariants: 
// First function should return true if buffer offset is at the 0th index of buffer storage, false otherwise
// Second function should return true if buffer offset is at the last index of buffer storage, false otherwise
test_isOffsetAtBeg_isOffsetAtEnd: {
  ret: ()
  
  // Should return the data at index of the current offset of the buffer, from the storage bound to the buffer
  data: `A `B `C
  buffer: .buffer.ctor[data]
  
  // First function should return true if buffer offset is at the 0th index of buffer storage, false otherwise
  ret: ret , (.buffer.isOffsetAtBeg[buffer])
  buffer: .buffer.inc[buffer]
  ret: ret , ((.buffer.isOffsetAtBeg[buffer]) = 0)
  buffer: .buffer.inc[buffer]
  ret: ret , ((.buffer.isOffsetAtBeg[buffer]) = 0)  
  buffer: .buffer.inc[buffer]    
  ret: ret , (.buffer.isOffsetAtEnd[buffer])
  buffer: .buffer.dec[buffer]
  ret: ret , ((.buffer.isOffsetAtBeg[buffer]) = 0) 
  buffer: .buffer.dec[buffer]
  ret: ret , ((.buffer.isOffsetAtBeg[buffer]) = 0) 
  buffer: .buffer.dec[buffer]
  ret: ret , (.buffer.isOffsetAtBeg[buffer])

  // Second function should return true if buffer offset is at the 0th index of buffer storage
  ret: ret , ((.buffer.isOffsetAtEnd[buffer]) = 0)
  // Set offset to last legal position in buffer, test again
  buffer: .buffer.setOffset[buffer; .buffer.count[buffer]]
  ret: ret , (.buffer.isOffsetAtEnd[buffer])
  
  :ret
}

// buffer: .buffer.isPrevOffsetAtEnd[buffer]
// Return invariants: 
// First function should return true if buffer preivous offset the last index of buffer storage, false otherwise
test_isPrevOffsetAtEnd: {
  ret: ()
  
  // Should return the data at index of the current offset of the buffer, from the storage bound to the buffer
  data: `A `B `C
  buffer: .buffer.ctor[data]
  
  // Second function should return true if buffer previous offset is at the 0th index of buffer storage
  ret: ret , ((.buffer.isPrevOffsetAtEnd[buffer]) = 0)
  // Set previous offset to last legal position in buffer, test again
  buffer: .buffer.setOffset[buffer; .buffer.count[buffer]]
  buffer: .buffer.setPrevOffset[buffer; .buffer.count[buffer]]
  ret: ret , (.buffer.isPrevOffsetAtEnd[buffer])
  
  :ret
}

// buffer: .buffer.removeDataItemsRange[buffer; lbound; len]
// Return invariants: 
// Return value should be a buffer with the items in range lbound to (lbound + len) removed, if lbound and len are valid
test_removeDataItemsRange: {
  ret: ()
  
  // Boundary cases, single item buffers, removing first and last items in 1, 2 and 3 item buffers
  data: ,`A
  buffer: .buffer.ctor[data]    
  ret: ret , (.utils.isEmptyList[.buffer.getDataItemsRange[.buffer.removeDataItemsRange[buffer; 0; 1]; 0; 1]])

  data: `A `B  
  buffer: .buffer.ctor[data]
  ret: ret , (.utils.isEmptyList[.buffer.getDataItemsRange[.buffer.removeDataItemsRange[buffer; 0; 2]; 0; 1]])
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 1]    
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `B))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 1]  
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `A))

  data: `A `B `C
  buffer: .buffer.ctor[data]
  ret: ret , (.utils.isEmptyList[.buffer.getDataItemsRange[.buffer.removeDataItemsRange[buffer; 0; 3]; 0; 1]])
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 1]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `B `C]))
  bufRet: .buffer.removeDataItemsRange[buffer; 2; 1]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `A `B]))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 1]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `A `C]))
  
  // Remove multiple items, again short list boundary cases
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 2]
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `C))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 2]
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `A))
  
  // Remove multiple items and single items, longer lists
  data: `A `B `C `D
  buffer: .buffer.ctor[data]
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 2]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `C `D]))
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 3]
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `D))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 2]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `A `D]))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 3]
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `A))
  bufRet: .buffer.removeDataItemsRange[buffer; 2; 2]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `A `B]))

  :ret
}

// buffer: .buffer.insertDataItemsRange[buffer; lbound; dataItems]
// Return invariants: 
// Return value should be a buffer with the items in dataItems inserted in range lbound to (lbound + #dataItems)
test_insertDataItemsRange: {
  ret: ()
  
  // Boundary cases, empty buffers, single-item buffers
  data: ()
  dataItems: ()
  buffer: .buffer.ctor[data]    
  ret: ret , (.utils.isEmptyList[.buffer.getDataItemsRange[.buffer.insertDataItemsRange[buffer; 0; dataItems]; 0; 1]])

  data: `A `B  
  buffer: .buffer.ctor[data]
  ret: ret , (.utils.isEmptyList[.buffer.getDataItemsRange[.buffer.removeDataItemsRange[buffer; 0; 2]; 0; 1]])
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 1]    
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `B))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 1]  
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `A))

  data: `A `B `C
  buffer: .buffer.ctor[data]
  ret: ret , (.utils.isEmptyList[.buffer.getDataItemsRange[.buffer.removeDataItemsRange[buffer; 0; 3]; 0; 1]])
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 1]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `B `C]))
  bufRet: .buffer.removeDataItemsRange[buffer; 2; 1]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `A `B]))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 1]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `A `C]))

  // Remove multiple items, again short list boundary cases
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 2]
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `C))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 2]
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `A))

  // Remove multiple items and single items, longer lists
  data: `A `B `C `D
  buffer: .buffer.ctor[data]
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 2]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `C `D]))
  bufRet: .buffer.removeDataItemsRange[buffer; 0; 3]
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `D))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 2]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `A `D]))
  bufRet: .buffer.removeDataItemsRange[buffer; 1; 3]
  ret: ret , ((.buffer.count[bufRet] = 1) & (.buffer.getDataItem[bufRet] = `A))
  bufRet: .buffer.removeDataItemsRange[buffer; 2; 2]
  ret: ret , ((.buffer.count[bufRet] = 2) & (.utils.extEquals[.buffer.getDataItemsRange[bufRet; 0; 2]; `A `B]))

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
  retMsg: retMsg , (,("buffer_UT TEST RESULTS"))
  retMsg: retMsg , (,("---------------------"))

  // Call Tests Here
  
  // test_ctor[]	
  ret: test_ctor[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.ctor[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.ctor[] FAILED"))]

  // test_count[]	
  ret: test_count[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.count[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.count[] FAILED"))]

  // test_inc_dec_getOffset[]
  ret: test_inc_dec_getOffset[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.inc[], dec[], getOffset[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.inc[], dec[], getOffset[] FAILED"))]

  // test_incN_decN_getOffset[]
  ret: test_pushListItems_pop_peek[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.incN[], decN[], getOffset[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.incN[], decN[], getOffset[] FAILED"))]

  // test_setOffset[]
  ret: test_setOffset[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.setOffset[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.setOffset[] FAILED"))]

  // test_getDataItem[]
  ret: test_getDataItem[]        
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.getDataItem[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.getDataItem[] FAILED"))]

  // test_getDataItemsRange[]
  ret: test_getDataItemsRange[]        
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.getDataItemsRange[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.getDataItemsRange[] FAILED"))]

  // test_isOffsetAtBeg_isOffsetAtEnd[]
  ret: test_isOffsetAtBeg_isOffsetAtEnd[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.isOffsetAtBeg[], isOffsetAtEnd[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.isOffsetAtBeg[], isOffsetAtEnd[] FAILED"))]

  // test_isPrevOffsetAtEnd
  ret: test_isPrevOffsetAtEnd[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.isPrevOffsetAtEnd[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.isPrevOffsetAtEnd[] FAILED"))]

  // test_decPrevN_setPrevOffset_getPrevOffset
  ret: test_decPrevN_setPrevOffset_getPrevOffset[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.decPrevN[], setPrevOffset[] and getPrevOffset[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.decPrevN[], setPrevOffset[] and getPrevOffset[] FAILED"))]
  
  // test_removeDataItemsRange
  ret: test_removeDataItemsRange[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.removeDataItemsRange[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.removeDataItemsRange[] FAILED"))]
  
  // test_insertDataItemsRange
  ret: test_insertDataItemsRange[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.insertDataItemsRange[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.insertDataItemsRange[] FAILED"))]
  
  // test_getAllDataItemsAsList
  ret: test_getAllDataItemsAsList[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .buffer.getAllDataItemsAsList[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .buffer.getAllDataItemsAsList[] FAILED"))]
  
  // /Call Tests Here

  retMsg: retMsg , (,(""))
  retMsg: retMsg , (,(""))
  
  :retMsg
}

// ** /HARNESS