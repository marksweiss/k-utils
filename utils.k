// ************** 
// File: utils.k
// Descr: Lexical scanning of k source into tokens for K2Q 
// **************

// Load namespace so calls use namespace.function to appear more OO style
\d .utils


// **** Type Preds ****

// -1 int vector
// -2 float vector
// -3 char vector
// -4 symbol vector
// 0 other list
vecTypeCodes: (-1 -2 -3 -4)
vecLstTypeCodes: (-1 -2 -3 -4 0)
// 1 int 
// 2 float
// 3 char
// 4 symbol
atomTypeCodes: (1 2 3 4)

// **** isInt ****
// Descr: 	Tests arg for whether or not it is an Int Atom
// Args: 	arg - argument that is tested for Int Atom type
// Return: 	predicate indicating whether or not arg is an Int Atom
isInt: { [arg]
  :(4: arg) = 1 
}

// **** isFloat ****
// Descr: 	Tests arg for whether or not it is an Float Atom
// Args: 	arg - argument that is tested for Float Atom type
// Return: 	predicate indicating whether or not arg is an Float Atom
isFloat: { [arg]
  :(4: arg) = 2 
}

// **** isChar ****
// Descr: 	Tests arg for whether or not it is an Char Atom
// Args: 	arg - argument that is tested for Char Atom type
// Return: 	predicate indicating whether or not arg is an Char Atom
isChar: { [arg]
  :(4: arg) = 3 
}

// **** isSym ****
// Descr: 	Tests arg for whether or not it is an Symbol Atom
// Args: 	arg - argument that is tested for Symbol Atom type
// Return: 	predicate indicating whether or not arg is an Symbol Atom
isSym: { [arg]
  :(4: arg) = 4 
}

// **** isVector ****
// Descr: 	Tests arg for whether or not it is a homogenous Vector
// Args: 	arg - argument that is tested for Vector type
// Return: 	predicate indicating whether or not arg is a Vector
isVector: { [arg]
  :(+/((4: arg) =/: vecTypeCodes)) = 1
}

// **** isCharVector ****
// Descr: 	Tests arg for whether or not it is a Char Vector (String)
// Args: 	arg - argument that is tested for Vector type
// Return: 	predicate indicating whether or not arg is a Char Vector
isCharVector: { [arg]
  :(4: arg) = -3 
}
isString: { [arg]
  :isCharVector[arg]
}

// **** isVectorList ****
// Descr: 	Tests arg for whether or not it is a homogenous Vector or heterogenous List
// Args: 	arg - argument that is tested for Vector or List type
// Return: 	predicate indicating whether or not arg is a Vector or List
isVectorList: { [arg]
  :(+/((4: arg) =/: vecLstTypeCodes)) = 1
}

// **** isNil ****
// Descr: 	Test arg for being generic nil type
// Args: 	sym - arg to test
// Return: 	predicate indicating whether sym = _n
isNil: { [arg] 
  :(4: arg) = 6
}

// **** isNilStr ****
// Descr: 	Test string for being nil string, that is for being ""
// Args: 	str - string to test
// Return: 	predicate indicating whether str = ""
isNilStr: { [str] 
  :((4: str) = -3) & ((#str) = 0)
}

// **** isEmptyList ****
// Descr: 	Test list for being 0-element generic type emtpy list ()
// Args: 	lst - list to test
// Return: 	predicate indicating whether list = ()
isEmptyList: { [lst] 
  :((4: lst) = 0) & ((#lst) = 0)
}

// **** isEmptyVector ****
// Descr: 	Test list for being 0-element generic type emtpy list ()
// Args: 	lst - list to test
// Return: 	predicate indicating whether lst is one of the designated types for zero-element *homogenous typed* list, 
//  that is a K typed vector with no elements.  
//  These symbols are: 
//  Char: ""
//  Int: !0
//  Float: 0#0.0
//  Symbol: 0#`  
isEmptyVector: { [lst] 
  :((4: lst) < 0) & ((#lst) = 0)
}

// **** /Type Preds ****


// **** List Utils ****


// **** hasDepthN ****
// Descr: 	Test list for having at least one level of depth beyond the depth argument passed in
// Args: 	lst - list to test
//          depth - the depth the list must at least contain
// Return: 	predicate indicating whether list has depth >= depth
hasDepthN: { [lst; depth] 
  // Validation
  :[~(isNil[lst]); ; '".utils.hasDepthN{}: arg0 must be a non-empty vector or list"]
  :[isVectorList[lst]; ; '".utils.hasDepthN{}: arg0 must be a non-empty vector or list"]
  :[~(isEmptyList[lst]); ; '".utils.hasDepthN{}: arg0 must be a non-empty vector or list"]

  :hasDepthNHelper[lst; 0; depth]
}

hasDepthNHelper: { [lst; curDepth; depth]  
  if[curDepth = depth
    :1
  ]
  
  ret: 0
  j: 0
  bound: #lst
  while[(j < bound) & (~ret)
    if[isVectorList[lst[j]]
      ret: hasDepthNHelper[lst[j]; curDepth + 1; depth]
    ]
    j: j + 1 
  ]
  
  :ret
}

// **** /List Utils ****


// **** Numeric ****

// **** isEven ****
// Descr: 	Tests whether an integer is evenly divisible by 2
// Args: 	val - integer to be tested
// Return:  predicate indicating whether val is evenly divisible by 2
isEven: { [val]
  // Validation
  :[isInt[val]; ; '".utils.isInStr{}: arg0 must be an integer"]

  :((_(val % 2)) * 2) = val
}
// **** isOdd ****
// Descr: 	Tests whether an integer is not evenly divisible by 2
// Args: 	val - integer to be tested
// Return:  predicate indicating whether val is not evenly divisible by 2
isOdd: { [val]
  :~isEven[val]
}

// **** /Numeric ****


// **** String ****

// **** trimStr ****
// Descr: 	Trims leading and trailng whitespace from a string
// Args: 	str - string to be trimmed
// Return:  a character vector that is the characters of str with any leading and trailing whitespace removed
trimStr: { [str]
  // Validation
  if[(4: str) = 3
    if[(str = " ") | (str = "\n") | (str = "\t") | (str = "\b")
      :""
    ]
    :str
  ]
  :[(#str) = 1; :str; ]
  :[(4: str) = -3; ; '".utils.trimStr{}: arg0 must be a character vector"]
  
  wsIdxs: &({[x] :((x = " ") | (x = "\n") | (x = "\t") | (x = "\b"))}'str)
  :[(#wsIdxs) = 0; :str; ]
  
  j: 0
  lidx: j
  adv: 1
  while[adv
    adv: 0
    if[j < (#wsIdxs)
      if[wsIdxs[j] = j
        j: j + 1
        adv: 1
      ]
    ]
  ]
  :[j > 0; lidx: j; ]
    
  k: (#str)
  j: (#wsIdxs) - 1
  ridx: k  
  adv: 1
  while[adv
    adv: 0
    if[(~(j < 0)) & (k > lidx)    
      if[wsIdxs[j] = (k - 1)
        j: j - 1
        k: k - 1
        adv: 1
      ]
    ]
  ]
  :[k < (#str); ridx: k; ]
  
  :str[lidx + (!(ridx - lidx))]
}

// **** isInStr ****
// Descr: 	Tests whether a stirng contains another string as a substring
// Args: 	lstr - string to be tested for presence of rstr as substring
//          rstr - string to be searched for in lstr
// Return:  predicate indicating whether rstr was found in lstr
isInStr: { [lstr; rstr]
  // Validation
  :[(4: lstr) = -3; ; '".utils.isInStr{}: arg0 must be a character vector"]
  :[(4: rstr) = -3; ; '".utils.isInStr{}: arg1 must be a character vector"]

  :~(((4: (lstr _ss rstr)) = -1) & ((#(lstr _ss rstr)) = 0))
}

g_upper: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
g_lower: "abcdefghijklmnopqrstuvwxyz"
// **** toUpper ****
// Descr: 	Replaces all lower-case alpha characters in a source string with their upper-case counterpart
// Args: 	str - string to be modified
// Return:  modified string with all lower-case alpha characters replaced with their upper-case counterpart
toUpper: { [str]
  // Validation
  :[(4: str) = -3; ; '".utils.toUpper{}: arg0 must be a character vector"]
  
  j: 0; jBound: (#g_upper)
  while[j < jBound
    str: _ssr[str; g_lower[j]; g_upper[j]]
    j: j + 1
  ]
  
  :str
}
// **** toLower ****
// Descr: 	Replaces all upper-case alpha characters in a source string with their lower-case counterpart
// Args: 	str - string to be modified
// Return:  modified string with all upper-case alpha characters replaced with their lower-case counterpart
toLower: { [str]
  // Validation
  :[(4: str) = -3; ; '".utils.toLower{}: arg0 must be a character vector"]
	
  j: 0; jBound: (#g_upper)
  while[j < jBound
    str: _ssr[str; g_upper[j]; g_lower[j]]
    j: j + 1
  ]
  
  :str
}

// **** toUpper ****
// Descr: 	Test a character to see whether it is an uppercase Alpha character
// Args: 	char - character to be tested
// Return:  boolean predicate indicating whether character is upper case Alpha
isUpper: { [char]
  // Validation
  :[(4: char) = 3; ; '".utils.isUpper{}: arg0 must be a character"]
  
  :((#(g_upper _ss (,char))) > 0)  
}

// **** /String ****


// **** Comp Preds ****

// **** extEquals ****
// Descr: 	Test type conforming atoms for equality, and type and length-conforming vectors
// Args: 	lhs - first argument to be compared
//			rhs - second argument to be compared
// Return: 	predicate indicating whether the two arguments are equal
extEquals: { [lhs; rhs] 
  // Validation
  lhsType: (4: lhs)
  rhsType: (4: rhs)
  :[lhsType = rhsType; ; '".utils.extEquals{}: arg0 and arg1 must have conforming types"]
  :[(~(lhsType = 0)) & (~(rhsType = 0)); ; '".utils.extEquals{}: arg0 and arg1 must be atoms or vectors of homogenous type"]
  
  // If this is an atom comparison, just test for value equality
  if[lhsType > 0
    :(lhs = rhs)
  ]
  
  // Lists but not same length
  if[(lhsType < 0) & (rhsType < 0) & (~((#lhs) = (#rhs)))
    :0
  ]
  // If this is a list comparison, test that the boolean vector returned by equality has a 1 in each position
  // e.g. - (1 2 3) = (1 2 3) returns 1 1 1		(1 2 3) = (1 2 2) returns 1 1 0
  :((+/(lhs = rhs)) = (# lhs))
}

// **** /Comp Preds ****


// **** Dictionary ****

// **** dct_ctor ****
// Descr: 	Constructs a new dictionary with designated dummy first item and returns it
//			assigned to the argument passed in
// Args: 	dct - dictionary to be returned
// Return: 	a new empty dictionary, dummy first item is ignored because it's symbol is nil symbol. Return is type .() 
dummyDctItem: (`0#; _n)
dct_ctor: {
  :(. . (dummyDctItem))
}

// TODO - Reverse the order of these args and fix where it breaks
// **** dct_append ****
// Descr: 	Appends the second argument as a new entry in the dictionary first argument. Validates that
//			the first argument is a dictionary, and the second is in the proper form of a dictionary item,
//			which is a two-element list whose first element is a symbol atom.
// Args: 	item - item to be appended to dct
//			dct - dictionary to be appended to
// Return: 	a modified copy of dct, with item appended
dct_append: { [item; dct]
  // Validation
  :[(((# item) = 2) | ((# item) = 3)) & ((4: item[0]) = 4); ; '".utils.dct_append{}: arg0 must be a two- or three-element list whose first element is a symbol"]
  :[(4: dct) = 5; ; '".utils.dct_append{}: arg1 must be a dictionary"]

  // Convert dct to a list
  dct: . dct
  // Enlist item, append it to the end of dct as a list
  dct: dct , (,item)
  // Now convert dct back to a dictionary and return it
  dct: . dct
  :dct
}

// **** /Dictionary ****


// **** I/O ****

// **** fileRead ****
// Descr: 	Reads in a text file and returns the text read in as a char vector
// Args: 	inFile - file to be read
// Return: 	Text read in as a char vector
fileRead: { [inFile]
  : 0: inFile
}

// **** fileWriteAppend ****
// Descr: 	Appends to a text file. File must exist or raises a Domain Error if the file doesn't exist, as per K docs
// Args: 	outFile - file to be appended to
//			val - value to be appended
// Return: 	none
fileWriteAppend: { [outFile; val] 
  prevOut: (0: outFile)
  
  //prevIsVecLst: 0
  //if[isVectorList[prevOut]
  //  prevIsVecLst: 1
  //  j: 0
  //  while[j < (#prevOut)
  //    prevOut: .[prevOut; j; :; prevOut[j],"\n"]
  //    j: j + 1
  //  ]
  //]
  
  //:[~prevIsVecLst; val: ("\n" , ($val)); val: $val]
  
  //outFile 0: ,/(prevOut , val)
  
  outFile 0: (prevOut , (,val))
}

// **** fileWriteClear ****
// Descr: 	Clears a file, so that it is empty
// Args: 	outFile - file to be cleared
// Return: 	none
fileWriteClear: { [outFile]
  outFile 0: ,""
} 


// **** fileWrite ****
// Descr: 	Writes to a text file. File must exist or raises a Domain Error if the file doesn't exist, as per K docs
// Args: 	outFile - file to be written
//			val - value to be written
// Return: 	none
fileWrite: { [outFile; val] 
  outFile 0: ($val)
}

// **** /I/O ****


// **** Debug ****

// **** dbgPrint ****
// Descr: 	Displays debug message and value to the console
// Args: 	val - atom, vector or list of values to be displayed
//			msgHeader - debug message header to be displayed
//			msg - debug message to be displayed
//          displayFlag - condtional expression evaluated to determine whether message is printed
// Return: 	void 
dbgPrint: { [val; msgHeader; msg; displayFlag]
  if[displayFlag
    :[(~(isNil[msgHeader]) & (~(isNil[msg]))); \ ("DEBUG: " , msgHeader , " " , msg); ]
    \ val
    \ "-----------------------------------------------"
  ]
}

// **** dbgBreak ****
// Descr: 	Displays debug message and value to the console and halts execution
// Args: 	val - atom, vector or list of values to be displayed
//			msgHeader - debug message header to be displayed
//			msg - debug message to be displayed
//          displayFlag - condtional expression evaluated to determine whether message is printed
// Return: 	void 
dbgBreak: { [val; msgHeader; msg; displayFlag]
  dbgPrint[val; msgHeader; msg; displayFlag]
  :[displayFlag; ' "BREAK"; ]
}

// **** assert ****
// Descr: 	Traditional C "assert" for those who prefer it
ASSERT: { [val; msgHeader; msg; assertion] 
  :[(~assertion); dbgBreak[val; msgHeader; msg; 1]; ]
}

// **** Debug ****
