// ************** 
// File: buffer.k
// Descr: Buffer data structure, maintains data element (a vector/list/"array"/buffer), offset into the buffer
//        and a "previous offset," which can be used for convenience to maintain a buffer range in the object's state.
//        Standard treatement of buffer range as a half-open interval, with start of buffer at offset = 0, and end
//        at a position one past the offset of the last item in the buffer -- that at the offset = #buffer 
// **************

// Load namespace so calls use namespace.function to appear more OO style
\d .buffer

// **** ctor ****
// Descr: 	Create and return reference to a vector or list, which is the underlying storage of this buffer
// Args: 	lst - vector or list which is to be manipulated through the buffer interface
// Return:	buffer, a tuple of the reference to the bound storage and the current and previous buffer offsets
ctor: { [lst] :(lst; 0; 0) }

// **** inc ****
// Descr: 	Increments the offset of the buffer passed in by 1
// Args: 	buf - buffer tuple of storage reference and current offset to be manipulated
// Return:	buffer, a tuple of the reference to the bound storage and the current and previous buffer offsets
inc: { [buf]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.inc{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[((buf[1]) + 1) < ((#buf[0]) + 1); ; '"k2q.buffer.inc{}: offset increment past end of buffer"]

  :(buf[0]; (buf[1]) + 1; buf[2])
}

// **** dec ****
// Descr: 	Decrements the offset of the buffer passed in by 1
// Args: 	buf - buffer tuple of storage reference and current offset to be manipulated
// Return:	buffer, a tuple of the reference to the bound storage and the current and previous buffer offsets
dec: { [buf]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.dec{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[~(((buf[1]) - 1) < 0); ; '"k2q.buffer.dec{}: offset decrement past beginning of buffer"]

  :(buf[0]; (buf[1]) - 1; buf[2])
}

// **** decPrev ****
// Descr: 	Decrements the  previous offset of the buffer passed in by 1
// Args: 	buf - buffer tuple of storage reference and current offset to be manipulated
// Return:	buffer, a tuple of the reference to the bound storage and the current and previous buffer offsets
//decPrev: { [buf]
//  // Validation
//  :[isBuffer[buf]; ; '"k2q.buffer.dec{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
//  :[~(((buf[2]) - 1) < 0); ; '"k2q.buffer.dec{}: previuos offset decrement past beginning of buffer"]

//  :(buf[0]; buf[1]; (buf[2] - 1))
//}

// **** incN ****
// Descr: 	Increments the offset of the buffer passed in by N
// Args: 	buf - buffer tuple of storage reference and current offset to be manipulated
//          N - integer amount to increment buffer offset
// Return:	buffer, a tuple of the reference to the bound storage and the current and previous buffer offsets
incN: { [buf; N]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.incN{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[((4: N) = 1); ; '"k2q.buffer.incN{}: arg1 an integer"]
  :[((buf[1]) + N) < ((#buf[0]) + 1); ; '"k2q.buffer.incN{}: offset increment past end of buffer"]

  :(buf[0]; (buf[1]) + N; buf[2])
}

// **** decN ****
// Descr: 	Decrements the offset of the buffer passed in by N
// Args: 	buf - buffer tuple of storage reference and current offset to be manipulated
//          N - integer amount to decrement buffer offset
// Return:	buffer, a tuple of the reference to the bound storage and the current and previous buffer offsets
decN: { [buf; N]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.decN{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[((4: N) = 1); ; '"k2q.buffer.decN{}: arg1 an integer"]
  :[~(((buf[1]) - N) < 0); ; '"k2q.buffer.decN{}: offset decrement past beginning of buffer"]

  :(buf[0]; (buf[1]) - N; buf[2])
}

// **** setOffset ****
// Descr: 	Sets the offset of the buffer passed in to N
// Args: 	buf - buffer tuple of storage reference and current offset to be manipulated
//          N - integer value to set the offset to
// Return:	buffer, a tuple of the reference to the bound storage and the current and previous buffer offsets
setOffset: { [buf; N]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.setOffset{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[((4: N) = 1); ; '"k2q.buffer.setOffset{}: arg1 an integer"]
  :[~(N < 0); ; '"k2q.buffer.setOffset{}: offset set past beginning of buffer"]
  :[N < ((#buf[0]) + 1); ; '"k2q.buffer.setOffset{}: offset set past end of buffer"]

  :(buf[0]; N; buf[2])
}

// **** setPrevOffset ****
// Descr: 	Sets the previous offset of the buffer passed in to N
// Args: 	buf - buffer tuple of storage reference and current offset to be manipulated
//          N - integer value to set the offset to
// Return:	buffer, a tuple of the reference to the bound storage and the current and previous buffer offsets
setPrevOffset: { [buf; N]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.setPrevOffset{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[((4: N) = 1); ; '"k2q.buffer.setPrevOffset{}: arg1 an integer"]
  :[~(N < 0); ; '"k2q.buffer.setPrevOffset{}: offset set past beginning of buffer"]
  :[N < ((#buf[0]) + 1); ; '"k2q.buffer.setPrevOffset{}: offset set past end of buffer"]
  :[~(N > (buf[1])); ; '"k2q.buffer.setPrevOffset{}: previous offset set past current offset"]

  :(buf[0]; buf[1]; N)
}

// **** decPrevN ****
// Descr: 	Decrements the prevous offset of the buffer passed in by N
// Args: 	buf - buffer tuple of storage reference and previous offset to be manipulated
//          N - integer amount to decrement buffer previous offset
// Return:	buffer, a tuple of the reference to the bound storage and the current and previous buffer offsets
decPrevN: { [buf; N]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.decPrevN{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[((4: N) = 1); ; '"k2q.buffer.decPrevN{}: arg1 an integer"]
  :[~(((buf[2]) - N) < 0); ; '"k2q.buffer.decPrevN{}: previous offset decrement past beginning of buffer"]

  :(buf[0]; buf[1]; (buf[2]) - N)
}

// **** getOffset ****
// Descr: 	Gets the offset of the buffer passed in
// Args: 	buf - buffer tuple of storage reference and current offset to be manipulated
// Return:	integer which is the current offset of buf
getOffset: { [buf]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.getOffset{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  
  :buf[1]
}

// **** getPrevOffset ****
// Descr: 	Gets the prevous offset of the buffer passed in
// Args: 	buf - buffer tuple of storage reference and current offset to be manipulated
// Return:	integer which is the previous offset of buf
getPrevOffset: { [buf]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.getPrevOffset{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  
  :buf[2]
}

// **** getDataItem ****
// Descr: 	Retrieves the buffer element at the current offset
// Args: 	buf - buffer tuple of storage reference and current offset to be read
// Return:	the item at the current offset of buf from the storage of buf
getDataItem: { [buf]
  // Validation
  :[~(.utils.isEmptyList[buf[0]]); ;:()]
  :[isBuffer[buf]; ; '"k2q.buffer.getDataItem{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[~isOffsetAtEnd[buf]; ; '"k2q.buffer.getDataItem{}: arg0 buffer offset is in the 'at end' position"]

  dataBuf: buf[0]
  :dataBuf[buf[1]]
}

// **** getDataItemsRange ****
// Descr: 	Retrieves the buffer elements in the designated range of offsets
// Args: 	buf - buffer tuple of storage reference and current offset to be read
//          lbound - the first index in the range to be retrieved
//          len - length of range to be retrieved
// Return:	the items in the range of offsets of buf from the storage of buf
getDataItemsRange: { [buf; lbound; len]
  // Validation
  :[~(.utils.isEmptyList[buf[0]]); ;:()]
  :[isBuffer[buf]; ; '"k2q.buffer.getDataItemsRange{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[(.utils.isInt[lbound]) & (~(lbound < 0)); ; '"k2q.buffer.getDataItemsRange{}: arg1 must be a non-negative integer"]  
  :[(.utils.isInt[len]) & (~((lbound + len) > count[buf])); ; '"k2q.buffer.getDataItemsRange{}: arg1 + arg2 must be an integer value not greater than the count of items in the buffer's storage"]

  dataBuf: buf[0]
  :dataBuf[lbound + (!len)]
}

// **** getAllDataItemsAsList ****
// Descr: 	Retrieves the underlying list data from buffer, in whatever shape it was loaded
// Args: 	buf - buffer from which data items are being retrieved
// Return:	A copy of the underlying list being managed by buf
getAllDataItemsAsList: { [buf]
  // Validation
  :[~(.utils.isEmptyList[buf[0]]); ;:()]
  :[isBuffer[buf]; ; '"k2q.buffer.getAllDataItemsAsList{}: arg0 must be a buffer tuple of a list or vector type and an integer"]

  :buf[0]
}

// **** removeDataItemsRange ****
// Descr: 	Removes the buffer elements in the designated range of offsets
// Args: 	buf - buffer tuple of storage reference and current offset to be read
//          lbound - the first index in the range to be removed
//          len - length of range to be removed
// Return:	a new modified buffer, unless the range arguments are out of bounds
// NOTE: This function returns a buffer with offset at it's original position if that position is < lbound, or
//  lbound if offset is >= lbound, because after modifying the buffer, lbound is the last known valid position.
//  prevOffset is unchanged and it is the responsibility of the client to assign it valid values.	
removeDataItemsRange: { [buf; lbound; len]
  // Validation  
  :[isBuffer[buf]; ; '"k2q.buffer.removeDataItemsRange{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[(.utils.isInt[lbound]) & (~(lbound < 0)); ; '"k2q.buffer.removeDataItemsRange{}: arg1 must be a non-negative integer"]  
  :[(.utils.isInt[len]) & (~((lbound + len) > count[buf])); ; '"k2q.buffer.removeDataItemsRange{}: arg1 + arg2 must be an integer value not greater than the count of items in the buffer's storage"]

  dataBuf: buf[0]
  newDataBuf: dataBuf[!lbound] , dataBuf[(lbound + len) + !((#dataBuf) - (lbound + len))]
  :[.utils.isEmptyVector[newDataBuf] | .utils.isEmptyList[newDataBuf]; newDataBuf: (); ]
  :(newDataBuf; :[buf[1] > lbound; lbound; buf[1]]; buf[2]) 
}

// **** insertDataItemsRange ****
// Descr: 	Inserts a list of new data items at the index indicated.  Expands the list by #newDataItems.
// Args: 	buf - buffer tuple of storage reference and current offset to be read
//          insertOffset - the index at which dataItems are to be inserted
//          dataItems - list of items to be inserted
// Return:	a new modified buffer, unless the insertOffset argument is out of bounds
// NOTE: This function returns a buffer with offset at it's original position if that position is < insertOffset, or
//  lbound if offset is >= insertOffset, because after modifying the buffer, insertOffset is the last known valid position.
//  prevOffset is unchanged and it is the responsibility of the client to assign it valid values.	
insertDataItemsRange: { [buf; insertOffset; dataItems]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.insertDataItemsRange{}: arg0 must be a buffer tuple of a list or vector type and an integer"]
  :[(.utils.isInt[insertOffset]) & (~(insertOffset < 0)) & (~(insertOffset > count[buf])); ; '"k2q.buffer.insertDataItemsRange{}: arg1 must be a non-negative integer"]  
  :[(.utils.isVectorList[dataItems]); ; '"k2q.buffer.insertDataItemsRange{}:arg2 must be a list or vector type"]

  dataBuf: buf[0]
  newDataBuf: dataBuf[!insertOffset] , dataItems , dataBuf[insertOffset + !((#dataBuf) - insertOffset)]
  :(newDataBuf; :[buf[1] > insertOffset; insertOffset; buf[1]]; buf[2]) 
}

// **** getPrevCurDataItemsRange ****
// Descr: 	Retrieves the buffer elements in the range of offsets from previous offset to current offset
// Args: 	buf - buffer tuple of storage reference and current offset to be read
// Return:	the items in the range of offsets of buf from the storage of buf
getPrevCurDataItemsRange: { [buf]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.getPrevCurDataItemsRange{}: arg0 must be a buffer tuple of a list or vector type and an integer"]

  dataBuf: buf[0]  
  :dataBuf[buf[2] + (!(buf[1] - buf[2]))]
}

// **** count ****
// Descr: 	Returns number of items in the buffer
// Args: 	buf - buffer tuple whose count is to be returned
// Return:	Non-negative scalar indicating the number of elements stored in buf
count: { [buf]  
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.count{}: arg0 must be a buffer tuple of a list or vector type and an integer"]

  :#(buf[0])
}

// **** isOffsetAtEnd ****
// Descr: 	Tests whether buffer offset is at the end of the buffer
// Args: 	buf - buffer tuple whose offset is to be tested
// Return:	Predicate indicating whether buffer offset is at the end
isOffsetAtEnd: { [buf]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.isOffsetAtEnd{}: arg0 must be a buffer tuple of a list or vector type and an integer"]

  :(#(buf[0])) = (buf[1])
}

// **** isPrevOffsetAtEnd ****
// Descr: 	Tests whether buffer previous offset is at the end of the buffer
// Args: 	buf - buffer tuple whose offset is to be tested
// Return:	Predicate indicating whether buffer previous offset is at the end
isPrevOffsetAtEnd: { [buf]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.isOffsetAtEnd{}: arg0 must be a buffer tuple of a list or vector type and an integer"]

  :(#(buf[0])) = (buf[2])
}

// **** isOffsetAtBeg ****
// Descr: 	Tests whether buffer offset is at the beginning of the buffer
// Args: 	buf - buffer tuple whose offset is to be tested
// Return:	Predicate indicating whether buffer offset is at the beginning
isOffsetAtBeg: { [buf]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.isOffsetAtBeg{}: arg0 must be a buffer tuple of a list or vector type and an integer"]

  :0 = (buf[1])
}

// **** isPrevOffsetAtBeg ****
// Descr: 	Tests whether buffer previous offset is at the beginning of the buffer
// Args: 	buf - buffer tuple whose offset is to be tested
// Return:	Predicate indicating whether buffer offset is at the beginning
isPrevOffsetAtBeg: { [buf]
  // Validation
  :[isBuffer[buf]; ; '"k2q.buffer.isPrevOffsetAtBeg{}: arg0 must be a buffer tuple of a list or vector type and an integer"]

  :0 = (buf[2])
}


// ** Helpers

// **** isBuffer ****
// Descr: 	Tests whether arg is a buffer "type"
// Args: 	buf - object to test
// Return:	Predicate indicating whether arg is a buffer
isBuffer: { [buf]
  if[((#buf) = 3)
    :[(.utils.isVectorList[buf[0]]) & ((4: (buf[1])) = 1) & ((4: (buf[2])) = 1); :1; :0]
  ]
  
  :0
}

// ** /Helpers