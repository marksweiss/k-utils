// Mark Weiss
// K2Q
// ************** 
// File: utils_UT.k
// Descr: Unit Tests for utils.k - general utility function library
// \d utils -- loads utils.k and is intended to be run standalone with that module to test it
// **************

\l utils


// ** TESTS

// utils: isInt[]
// Return invariants:
// Should return 1 if arg passed in is specified atom type, and return 0 otherwise
test_isInt: {
  ret: ()
  
  // Test all atom types
  atom: 1
  ret: ret , (.utils.isInt[atom] = 1)
  atom: 1.0
  ret: ret , (~(.utils.isInt[atom] = 1))
  atom: "a"
  ret: ret , (~(.utils.isInt[atom] = 1))
  atom: `sym
  ret: ret , (~(.utils.isInt[atom] = 1))
  atom: `"sym$"
  ret: ret , (~(.utils.isInt[atom] = 1))

  // Test all non-atom types
  notAtom: ()  
  ret: ret , (~(.utils.isInt[notAtom] = 1))
  notAtom: .utils.dct_ctor[]  
  ret: ret , (~(.utils.isInt[notAtom] = 1))
  notAtom: .utils.dct_append[(`key; 100); notAtom]  
  ret: ret , (~(.utils.isInt[notAtom] = 1))  
  notAtom: 1 2
  ret: ret , (~(.utils.isInt[notAtom] = 1))
  notAtom: 1.0 2.0
  ret: ret , (~(.utils.isInt[notAtom] = 1))
  notAtom: `a `b
  ret: ret , (~(.utils.isInt[notAtom] = 1))
  notAtom: `"a$" `"b$"
  ret: ret , (~(.utils.isInt[notAtom] = 1))
  notAtom: "ab"
  ret: ret , (~(.utils.isInt[notAtom] = 1))
  notAtom: (1; 1.0; `a; "a")
  ret: ret , (~(.utils.isInt[notAtom] = 1))
  notAtom: _n
  ret: ret , (~(.utils.isInt[notAtom] = 1))
  
  :ret
}

// utils: isFloat[]
// Return invariants:
// Should return 1 if arg passed in is specified atom type, and return 0 otherwise
test_isFloat: {
  ret: ()
  
  // Test all atom types
  atom: 1
  ret: ret , (~(.utils.isFloat[atom] = 1))
  atom: 1.0
  ret: ret , (.utils.isFloat[atom] = 1)
  atom: "a"
  ret: ret , (~(.utils.isFloat[atom] = 1))
  atom: `sym
  ret: ret , (~(.utils.isFloat[atom] = 1))
  atom: `"sym$"
  ret: ret , (~(.utils.isFloat[atom] = 1))

  // Test all non-atom types
  notAtom: ()  
  ret: ret , (~(.utils.isFloat[notAtom] = 1))
  notAtom: .utils.dct_ctor[]  
  ret: ret , (~(.utils.isFloat[notAtom] = 1))
  notAtom: .utils.dct_append[(`key; 100); notAtom]  
  ret: ret , (~(.utils.isFloat[notAtom] = 1))  
  notAtom: 1 2
  ret: ret , (~(.utils.isFloat[notAtom] = 1))
  notAtom: 1.0 2.0
  ret: ret , (~(.utils.isFloat[notAtom] = 1))
  notAtom: `a `b
  ret: ret , (~(.utils.isFloat[notAtom] = 1))
  notAtom: `"a$" `"b$"
  ret: ret , (~(.utils.isFloat[notAtom] = 1))
  notAtom: "ab"
  ret: ret , (~(.utils.isFloat[notAtom] = 1))
  notAtom: (1; 1.0; `a; "a")
  ret: ret , (~(.utils.isFloat[notAtom] = 1))
  notAtom: _n
  ret: ret , (~(.utils.isFloat[notAtom] = 1))
  
  :ret
}

// utils: isChar[]
// Return invariants:
// Should return 1 if arg passed in is specified atom type, and return 0 otherwise
test_isChar: {
  ret: ()
  
  // Test all atom types
  atom: 1
  ret: ret , (~(.utils.isChar[atom] = 1))
  atom: 1.0
  ret: ret , (~(.utils.isChar[atom] = 1))
  atom: "a"
  ret: ret , (.utils.isChar[atom] = 1)
  atom: `sym
  ret: ret , (~(.utils.isChar[atom] = 1))
  atom: `"sym$"
  ret: ret , (~(.utils.isChar[atom] = 1))

  // Test all non-atom types
  notAtom: ()  
  ret: ret , (~(.utils.isChar[notAtom] = 1))
  notAtom: .utils.dct_ctor[]  
  ret: ret , (~(.utils.isChar[notAtom] = 1))
  notAtom: .utils.dct_append[(`key; 100); notAtom]  
  ret: ret , (~(.utils.isChar[notAtom] = 1))  
  notAtom: 1 2
  ret: ret , (~(.utils.isChar[notAtom] = 1))
  notAtom: 1.0 2.0
  ret: ret , (~(.utils.isChar[notAtom] = 1))
  notAtom: `a `b
  ret: ret , (~(.utils.isChar[notAtom] = 1))
  notAtom: `"a$" `"b$"
  ret: ret , (~(.utils.isChar[notAtom] = 1))
  notAtom: "ab"
  ret: ret , (~(.utils.isChar[notAtom] = 1))
  notAtom: (1; 1.0; `a; "a")
  ret: ret , (~(.utils.isChar[notAtom] = 1))
  notAtom: _n
  ret: ret , (~(.utils.isChar[notAtom] = 1))
  
  :ret
}

// utils: isSym[]
// Return invariants:
// Should return 1 if arg passed in is specified atom type, and return 0 otherwise
test_isSym: {
  ret: ()
  
  // Test all atom types
  atom: 1
  ret: ret , (~(.utils.isSym[atom] = 1))
  atom: 1.0
  ret: ret , (~(.utils.isSym[atom] = 1))
  atom: "a"
  ret: ret , (~(.utils.isSym[atom] = 1))
  atom: `sym
  ret: ret , (.utils.isSym[atom] = 1)
  atom: `"sym$"
  ret: ret , (.utils.isSym[atom] = 1)

  // Test all non-atom types
  notAtom: ()  
  ret: ret , (~(.utils.isSym[notAtom] = 1))
  notAtom: .utils.dct_ctor[]  
  ret: ret , (~(.utils.isSym[notAtom] = 1))
  notAtom: .utils.dct_append[(`key; 100); notAtom]  
  ret: ret , (~(.utils.isSym[notAtom] = 1))  
  notAtom: 1 2
  ret: ret , (~(.utils.isSym[notAtom] = 1))
  notAtom: 1.0 2.0
  ret: ret , (~(.utils.isSym[notAtom] = 1))
  notAtom: `a `b
  ret: ret , (~(.utils.isSym[notAtom] = 1))
  notAtom: `"a$" `"b$"
  ret: ret , (~(.utils.isSym[notAtom] = 1))
  notAtom: "ab"
  ret: ret , (~(.utils.isSym[notAtom] = 1))
  notAtom: (1; 1.0; `a; "a")
  ret: ret , (~(.utils.isSym[notAtom] = 1))
  notAtom: _n
  ret: ret , (~(.utils.isSym[notAtom] = 1))
  
  :ret
}

// utils: isVector[]
// Return invariants:
// Should return 1 if arg passed in is a homegenous vector type, and return 0 otherwise
test_isVector: {
  ret: ()
  
  // Test all vector types
  vec: 1 2
  ret: ret , (.utils.isVector[vec] = 1)
  vec: 1.0 2.0
  ret: ret , (.utils.isVector[vec] = 1)
  vec: `a `b
  ret: ret , (.utils.isVector[vec] = 1)
  vec: `"a$" `"b$"
  ret: ret , (.utils.isVector[vec] = 1)
  vec: "ab"

  // Test all non-vector types
  // Atoms
  notVec: 1
  ret: ret , (~(.utils.isVector[notVec] = 1))
  notVec: 1.0
  ret: ret , (~(.utils.isVector[notVec] = 1))
  notVec: "a"
  ret: ret , (~(.utils.isVector[notVec] = 1))
  notVec: `sym
  ret: ret , (~(.utils.isVector[notVec] = 1))
  notVec: `"sym$"
  ret: ret , (~(.utils.isVector[notVec] = 1))
  // Dict
  notVec: .utils.dct_ctor[]  
  ret: ret , (~(.utils.isVector[notVec] = 1))
  notVec: .utils.dct_append[(`key; 100); notVec]  
  ret: ret , (~(.utils.isVector[notVec] = 1))  
  // List
  notVec: ()  
  ret: ret , (~(.utils.isVector[notVec] = 1))
  notVec: (1; 1.0; `a; "a")
  ret: ret , (~(.utils.isVector[notVec] = 1))
  // Nil
  notVec: _n
  ret: ret , (~(.utils.isVector[notVec] = 1))
  
  :ret
}

// utils: isCharVector[]
// Return invariants:
// Should return 1 if arg passed in is a homegenous char vector type, and return 0 otherwise
test_isCharVector: {
  ret: ()
  
  vec: "ab"
  ret: ret , (.utils.isCharVector[vec] = 1)
  vec: "*&_#$&(*)()&@()jlajs;lj"
  ret: ret , (.utils.isCharVector[vec] = 1)

  // Test all vector types
  notVec: 1 2
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  notVec: 1.0 2.0
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  notVec: `a `b
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  notVec: `"a$" `"b$"
  ret: ret , (~(.utils.isCharVector[notVec] = 1))

  // Test all non-vector types
  // Atoms
  notVec: 1
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  notVec: 1.0
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  notVec: "a"
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  notVec: `sym
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  notVec: `"sym$"
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  // Dict
  notVec: .utils.dct_ctor[]  
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  notVec: .utils.dct_append[(`key; 100); notVec]  
  ret: ret , (~(.utils.isCharVector[notVec] = 1))  
  // List
  notVec: ()  
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  notVec: (1; 1.0; `a; "a")
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  // Nil
  notVec: _n
  ret: ret , (~(.utils.isCharVector[notVec] = 1))
  
  :ret
}
test_isString: {
  ret: ()
  
  vec: "ab"
  ret: ret , (.utils.isString[vec] = 1)
  vec: "*&_#$&(*)()&@()jlajs;lj"
  ret: ret , (.utils.isString[vec] = 1)

  // Test all vector types
  notVec: 1 2
  ret: ret , (~(.utils.isString[notVec] = 1))
  notVec: 1.0 2.0
  ret: ret , (~(.utils.isString[notVec] = 1))
  notVec: `a `b
  ret: ret , (~(.utils.isString[notVec] = 1))
  notVec: `"a$" `"b$"
  ret: ret , (~(.utils.isString[notVec] = 1))

  // Test all non-vector types
  // Atoms
  notVec: 1
  ret: ret , (~(.utils.isString[notVec] = 1))
  notVec: 1.0
  ret: ret , (~(.utils.isString[notVec] = 1))
  notVec: "a"
  ret: ret , (~(.utils.isString[notVec] = 1))
  notVec: `sym
  ret: ret , (~(.utils.isString[notVec] = 1))
  notVec: `"sym$"
  ret: ret , (~(.utils.isString[notVec] = 1))
  // Dict
  notVec: .utils.dct_ctor[]  
  ret: ret , (~(.utils.isString[notVec] = 1))
  notVec: .utils.dct_append[(`key; 100); notVec]  
  ret: ret , (~(.utils.isString[notVec] = 1))  
  // List
  notVec: ()  
  ret: ret , (~(.utils.isString[notVec] = 1))
  notVec: (1; 1.0; `a; "a")
  ret: ret , (~(.utils.isString[notVec] = 1))
  // Nil
  notVec: _n
  ret: ret , (~(.utils.isString[notVec] = 1))
  
  :ret
}

// utils: isVectorList[]
// Return invariants:
// Should return 1 if arg passed in is a homegenous vector type or empty or heterogenous list type, 
//	and return 0 otherwise
test_isVectorList: {
  ret: ()
  
  // Test all vector types
  vecLst: 1 2
  ret: ret , (.utils.isVectorList[vecLst] = 1)
  vecLst: 1.0 2.0
  ret: ret , (.utils.isVectorList[vecLst] = 1)
  vecLst: `a `b
  ret: ret , (.utils.isVectorList[vecLst] = 1)
  vecLst: `"a$" `"b$"
  ret: ret , (.utils.isVectorList[vecLst] = 1)
  vecLst: "ab"
  // List
  vecLst: ()  
  ret: ret , (.utils.isVectorList[vecLst] = 1)
  vecLst: (1; 1.0; `a; "a")
  ret: ret , (.utils.isVectorList[vecLst] = 1)

  // Test all Atom types
  // Atoms
  notVecLst: 1
  ret: ret , (~(.utils.isVectorList[notVecLst] = 1))
  notVecLst: 1.0
  ret: ret , (~(.utils.isVectorList[notVecLst] = 1))
  notVecLst: "a"
  ret: ret , (~(.utils.isVectorList[notVecLst] = 1))
  notVecLst: `sym
  ret: ret , (~(.utils.isVectorList[notVecLst] = 1))
  notVecLst: `"sym$"
  ret: ret , (~(.utils.isVectorList[notVecLst] = 1))
  // Dict
  notVecLst: .utils.dct_ctor[]  
  ret: ret , (~(.utils.isVectorList[notVecLst] = 1))
  notVecLst: .utils.dct_append[(`key; 100); notVecLst]  
  ret: ret , (~(.utils.isVectorList[notVecLst] = 1))  
  // Nil
  notVecLst: _n
  ret: ret , (~(.utils.isVectorList[notVecLst] = 1))
  
  :ret
}

// utils: isNil[]
// Return invariants:
// Should return 1 if arg passed in is the nil symbol, nil vector/list element, or a name bound to this value,
//	0 otherwise
test_isNil: {
  ret: ()
  
  // Nil atom
  arg: _n
  ret: ret , (.utils.isNil[arg] = 1)
  // Nil vector element
  arg: (1; )
  ret: ret , (.utils.isNil[arg[1]] = 1)

  // Non-nil symbol
  arg: `a
  ret: ret , (~(.utils.isVectorList[arg] = 1))
  
  :ret
}

// utils: isNilStr[]
// Return invariants:
// Should return 1 if arg passed in is nil string, "", 0 otherwise
test_isNilStr: {
  ret: ()
  
  // Nil string
  arg: ""
  ret: ret , (.utils.isNilStr[arg] = 1)

  // Character atom
  arg: "a"
  ret: ret , (~(.utils.isNilStr[arg] = 1))
  
  // String
  arg: "ab"
  ret: ret , (~(.utils.isNilStr[arg] = 1))

  :ret
}

// utils: trimStr[str]
// Return invariants:
// Should return arg passed in with all contiguous leading and trailng spaces removed
test_trimStr: {
  ret: ()
  
  // One-wspace string
  arg: " "
  ret: ret , (.utils.isNilStr[.utils.trimStr[arg]])
  arg: "\n"
  ret: ret , (.utils.isNilStr[.utils.trimStr[arg]])
  arg: "\t"
  ret: ret , (.utils.isNilStr[.utils.trimStr[arg]])
  arg: "\b"
  ret: ret , (.utils.isNilStr[.utils.trimStr[arg]])

  // Character atom
  arg: "a"
  ret: ret , (.utils.trimStr[arg] = arg)

  // String, no whitespace
  arg: "ab"
  ret: ret , (.utils.trimStr[arg] = arg)

  // String, single character whitespace leading and following
  arg: " ab"
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: "ab "
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: " ab "
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: "\nab "
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: "\nab\n"
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: "\tab\n"
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: " ab\t"
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: "\bab\t"
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: "ab\b"
  ret: ret , (.utils.trimStr[arg] = "ab")

 // String, multiple character whitespace leading and following
  arg: "  ab"
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: "ab  "
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: "   ab  "
  ret: ret , (.utils.trimStr[arg] = "ab")  
  arg: "\t\n ab "
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: "ab \n"
  ret: ret , (.utils.trimStr[arg] = "ab")
  arg: " \t \b ab\b \n \t"
  ret: ret , (.utils.trimStr[arg] = "ab")
  
  // String, interior whitespace preserved
  arg: "a b "
  ret: ret , (.utils.trimStr[arg] = "a b")
  arg: " a  b "
  ret: ret , (.utils.trimStr[arg] = "a  b")   
  arg: "a\tb "
  ret: ret , (.utils.trimStr[arg] = "a\tb")
  arg: " a\nb "
  ret: ret , (.utils.trimStr[arg] = "a\nb") 
  arg: " a\bb "
  ret: ret , (.utils.trimStr[arg] = "a\bb") 
  arg: " a\n b "
  ret: ret , (.utils.trimStr[arg] = "a\n b") 
  arg: " a \bb "
  ret: ret , (.utils.trimStr[arg] = "a \bb") 
  arg: " a \b \t\n b "
  ret: ret , (.utils.trimStr[arg] = "a \b \t\n b") 

  :ret
}

// utils: isEmptyList[]
// Return invariants:
// Should return 1 if arg passed in is empty list, (), 0 otherwise
test_isEmptyList: {
  ret: ()
  
  // Empty list
  arg: ()
  ret: ret , (.utils.isEmptyList[arg] = 1)

  // Some atoms
  arg: "a"
  ret: ret , (~(.utils.isEmptyList[arg] = 1))
  arg: 1
  ret: ret , (~(.utils.isEmptyList[arg] = 1))
  arg: 1.0
  ret: ret , (~(.utils.isEmptyList[arg] = 1))
  arg: `a
  ret: ret , (~(.utils.isEmptyList[arg] = 1))

  // Non-empty list/vector
  arg: "ab"
  ret: ret , (~(.utils.isEmptyList[arg] = 1))
  arg: 0 1
  ret: ret , (~(.utils.isEmptyList[arg] = 1))
  arg: 0.0 1.0
  ret: ret , (~(.utils.isEmptyList[arg] = 1))
  arg: `a `b
  ret: ret , (~(.utils.isEmptyList[arg] = 1))
  arg: (`a; 1)
  ret: ret , (~(.utils.isEmptyList[arg] = 1))

  :ret
}

// utils: isEmptyVector[]
// Return invariants:
// Should return 1 if arg passed in is empty homogenous list (vector), 
//  e.g. !0 for int type and 0#0.0 for float, "" for char, 0 otherwise
test_isEmptyVector: {
  ret: ()
  
  // Empty list
  arg: ()
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))

  // Some atoms
  arg: "a"
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))
  arg: 1
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))
  arg: 1.0
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))
  arg: `a
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))

  // Non-empty list/vector
  arg: "ab"
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))
  arg: 0 1
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))
  arg: 0.0 1.0
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))
  arg: `a `b
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))
  arg: (`a; 1)
  ret: ret , (~(.utils.isEmptyVector[arg] = 1))

  // Empty list/vector
  arg: ""
  ret: ret , (.utils.isEmptyVector[arg] = 1)
  arg: !0
  ret: ret , (.utils.isEmptyVector[arg] = 1)
  arg: 0#0.0
  ret: ret , (.utils.isEmptyVector[arg] = 1)
  arg: 0#`
  ret: ret , (.utils.isEmptyVector[arg] = 1)

  :ret
}

// utils: hasDepthN[]
// Return invariants:
// Should return 1 if arg0 passed in is a list that has some nested element of at least depth of arg1, 0 otherwise
test_hasDepthN: {
  ret: ()
  
  // Atoms an Empty list all throw, so start with valid cases
  arg: ,1
  // Has one level of depth ...
  ret: ret , (.utils.hasDepthN[arg; 0] = 1)
  // ... but not two
  ret: ret , (~(.utils.hasDepthN[arg; 1] = 1))
  arg: 1 2
  // Multi-element lists but no more depth
  // Has one level of depth ...
  ret: ret , (.utils.hasDepthN[arg; 0] = 1)
  ret: ret , (~(.utils.hasDepthN[arg; 1] = 1))
  ret: ret , (~(.utils.hasDepthN[arg; 2] = 1))

  // Has one level of depth ...
  arg: ((1 2) ; `a)
  ret: ret , (.utils.hasDepthN[arg; 0] = 1)
  ret: ret , (.utils.hasDepthN[arg; 1] = 1)
  ret: ret , (~(.utils.hasDepthN[arg; 2] = 1))
  ret: ret , (~(.utils.hasDepthN[arg; 3] = 1))
  arg: ((1 2) ; `a; 1.1)
  ret: ret , (.utils.hasDepthN[arg; 0] = 1)
  ret: ret , (.utils.hasDepthN[arg; 1] = 1)
  ret: ret , (~(.utils.hasDepthN[arg; 2] = 1))
  ret: ret , (~(.utils.hasDepthN[arg; 3] = 1))
  arg: ((1 2) ; `a; 1.1; (4 5))
  ret: ret , (.utils.hasDepthN[arg; 0] = 1)
  ret: ret , (.utils.hasDepthN[arg; 1] = 1)
  ret: ret , (~(.utils.hasDepthN[arg; 2] = 1))
  ret: ret , (~(.utils.hasDepthN[arg; 3] = 1))
  
  // Has greater levels of depth ...
  arg: ( (1 2 ; (`a `b) ) ; `a )
  ret: ret , (.utils.hasDepthN[arg; 0] = 1)
  ret: ret , (.utils.hasDepthN[arg; 1] = 1)
  ret: ret , (.utils.hasDepthN[arg; 2] = 1)
  ret: ret , (~(.utils.hasDepthN[arg; 3] = 1))
  ret: ret , (~(.utils.hasDepthN[arg; 4] = 1))
  arg: ((1 2; (,3)) ; `a; 1.1)
  ret: ret , (.utils.hasDepthN[arg; 0] = 1)
  ret: ret , (.utils.hasDepthN[arg; 1] = 1)
  ret: ret , (.utils.hasDepthN[arg; 2] = 1)
  ret: ret , (~(.utils.hasDepthN[arg; 3] = 1))
  ret: ret , (~(.utils.hasDepthN[arg; 4] = 1))
  arg: ((1 2) ; `a; (1.1 ; ,`d); (4 5))
  ret: ret , (.utils.hasDepthN[arg; 0] = 1)
  ret: ret , (.utils.hasDepthN[arg; 1] = 1)
  ret: ret , (.utils.hasDepthN[arg; 2] = 1)
  ret: ret , (~(.utils.hasDepthN[arg; 3] = 1))
  ret: ret , (~(.utils.hasDepthN[arg; 4] = 1))

  :ret
}

// utils: dct_ctor[]
// utils: dct_append[]
// Return invariants:
// dct_ctor should return a new dictionary with one element, that is the null symbol keyed to an empty list value
// dct_append should return a copy of the dictionary passed in, with item passed in added to the dictionary
test_dct_ctor_dct_append: {
  ret: ()
  
  // Dict
  dct: .utils.dct_ctor[]
  // Dictionary type  
  ret: ret , ((4: dct) = 5)
  // Has one element
  ret: ret , ((#dct) = 1)
  // Getting all the values returns a list ...
  ret: ret , ((#(dct[])) = 0)
  // ... but it's the nil list
  ret: ret , ((4: (dct[])) = 0)
  
  // Now append
  dct: .utils.dct_append[(`key; 100); dct]
  ret: ret , (dct[`key] = 100)  
  // Still one, because nil symbol keyed to empty string not maintained once there is a non-nil key in the dictionary
  ret: ret , ((#dct) = 1)  
  ret: ret , ((#(dct[])) = 1)

  dct: .utils.dct_append[(`key2; "C"); dct]
  ret: ret , (dct[`key2] = "C")
  dct: .utils.dct_append[(`key3; 1.0); dct]
  ret: ret , (dct[`key3] = 1.0)
  dct: .utils.dct_append[(`key4; `a); dct]
  ret: ret , (dct[`key4] = `a)

  dct: .utils.dct_append[(`key5; "AB"); dct]
  ret: ret , (dct[`key5] = "AB")
  dct: .utils.dct_append[(`key6; 1.0 2.0); dct]
  ret: ret , (dct[`key6] = 1.0 2.0)
  dct: .utils.dct_append[(`key7; `a `b); dct]
  ret: ret , (dct[`key7] = `a `b)
  
  :ret
}

// utils: extEquals[]
// Return invariants:
// returns 1 if arg0 and arg1 are atoms and have the same value, or are length-conforming
//  homogenous vectors that have atoms in each position that have the same value, 0 otherwise
test_extEquals: {
  ret: ()
  
  ret: ret , .utils.extEquals[1; 1]
  ret: ret , .utils.extEquals[1.0; 1.0]
  ret: ret , .utils.extEquals[`a; `a]
  ret: ret , .utils.extEquals["a"; "a"]

  ret: ret , ~(.utils.extEquals[1; 2])
  ret: ret , ~(.utils.extEquals[1.0; 2.0])
  ret: ret , ~(.utils.extEquals[`a; `b])
  ret: ret , ~(.utils.extEquals["a"; "b"])

  ret: ret , .utils.extEquals[1 2; 1 2]
  ret: ret , .utils.extEquals[1.0 2.0; 1.0 2.0]
  ret: ret , .utils.extEquals[`a `b; `a `b]
  ret: ret , .utils.extEquals["ab"; "ab"]

  ret: ret , ~(.utils.extEquals[1 2; 2 1])
  ret: ret , ~(.utils.extEquals[1.0 2.0; 2.0 1.0])
  ret: ret , ~(.utils.extEquals[`a `b; `b `a])
  ret: ret , ~(.utils.extEquals["ab"; "ba"])

  :ret
}

// utils: isInStr[]
// Return invariants:
// returns 1 if arg1 is a subsstring of arg0, 0 otherwise
test_isInStr: {
  ret: ()
  
  ret: ret , .utils.isInStr["abc"; "ab"]
  ret: ret , .utils.isInStr["abc"; "bc"]
  ret: ret , .utils.isInStr["abc"; "abc"]

  ret: ret , ~(.utils.isInStr["abc"; "abcd"])
  ret: ret , ~(.utils.isInStr["abc"; "abe"])
  ret: ret , ~(.utils.isInStr["abc"; "aeb"])
  ret: ret , ~(.utils.isInStr["abc"; "eabc"])
  ret: ret , ~(.utils.isInStr["ab"; "ac"])

  :ret
}

// utils: toUpper_toLower[]
// Return invariants:
// toUpper - all lower-case alpha characters will be replaced with upper-case counterparts
// toLower - all upper-case alpha characters will be replaced with lower-case counterparts
test_toUpper_toLower: {
  ret: ()
  
  ret: ret , .utils.extEquals[.utils.toUpper["abc"]; "ABC"]
  ret: ret , .utils.extEquals[.utils.toUpper["a1b2c3DE"]; "A1B2C3DE"]
  ret: ret , .utils.extEquals[.utils.toUpper["123"]; "123"]

  ret: ret , .utils.extEquals[.utils.toLower["ABC"]; "abc"]
  ret: ret , .utils.extEquals[.utils.toLower["A1B2C3de"]; "a1b2c3de"]
  ret: ret , .utils.extEquals[.utils.toLower["123"]; "123"]

  :ret
}

// utils: isEven_isOdd[]
// Return invariants:
// If arg is an integer and evenly divisible by 2, isEven[] returns 1 and isOdd[] returns 0, 
//  otherwise isEven[] returns 0 and isOdd[] returns 1
test_isEven_isOdd: {
  ret: ()
  
  ret: ret , .utils.isEven[0]
  ret: ret , .utils.isEven[-0]
  ret: ret , .utils.isEven[2]
  ret: ret , .utils.isEven[-2]
  ret: ret , .utils.isEven[20]
  ret: ret , .utils.isEven[-20]
  
  ret: ret , .utils.isOdd[1]
  ret: ret , .utils.isOdd[-1]
  ret: ret , .utils.isOdd[3]
  ret: ret , .utils.isOdd[-3]
  ret: ret , .utils.isOdd[33]
  ret: ret , .utils.isOdd[-33]
  
  ret: ret , ~(.utils.isEven[1])
  ret: ret , ~(.utils.isEven[-1])
  ret: ret , ~(.utils.isOdd[0])
  ret: ret , ~(.utils.isOdd[-0])
  ret: ret , ~(.utils.isOdd[2])
  ret: ret , ~(.utils.isOdd[-2])
  ret: ret , ~(.utils.isOdd[200])
  ret: ret , ~(.utils.isOdd[-222])
  
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
  retMsg: retMsg , (,("utils_UT TEST RESULTS"))
  retMsg: retMsg , (,("---------------------"))

  // Call Tests Here
  
  // test_isInt[]	
  ret: test_isInt[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isInt[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isInt[] FAILED"))]

  // test_isFloat[]	
  ret: test_isFloat[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isFloat[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isFloat[] FAILED"))]

  // test_isChar[]	
  ret: test_isChar[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isChar[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isChar[] FAILED"))]

  // test_isSym[]	
  ret: test_isSym[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isSym[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isSym[] FAILED"))]

  // test_isVector[]	
  ret: test_isVector[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isVector[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isVector[] FAILED"))]

  // test_isCharVector[]	
  ret: test_isCharVector[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isCharVector[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isCharVector[] FAILED"))]
  // test_isString[]	
  ret: test_isString[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isString[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isString[] FAILED"))]

  // test_isVectorList[]	
  ret: test_isVectorList[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isVectorList[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isVectorList[] FAILED"))]

  // test_isNil[]	
  ret: test_isNil[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isNil[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isNil[] FAILED"))]

  // test_isNilStr[]	
  ret: test_isNilStr[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isNilStr[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isNilStr[] FAILED"))]

  // test_trimStr[]	
  ret: test_trimStr[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test trimStr[] SUCCEEDED")) ; retMsg: retMsg , (,("Test trimStr[] FAILED"))]

  // test_isEmptyList[]	
  ret: test_isEmptyList[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isEmptyList[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isEmptyList[] FAILED"))]

  // test_isEmptyVector[]	
  ret: test_isEmptyVector[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isEmptyVector[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isEmptyVector[] FAILED"))]

  // test_hasDepthN[]	
  ret: test_hasDepthN[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test hasDepthN[] SUCCEEDED")) ; retMsg: retMsg , (,("Test hasDepthN[] FAILED"))]

  // test_dct_ctor_dct_append[]	
  ret: test_dct_ctor_dct_append[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test dct_ctor[], dct_append[] SUCCEEDED")) ; retMsg: retMsg , (,("Test dct_ctor[], dct_append[] FAILED"))]

  // test_extEquals[]	
  ret: test_extEquals[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test extEquals[] SUCCEEDED")) ; retMsg: retMsg , (,("Test extEquals[] FAILED"))]

  // test_isInStr[]
  ret: test_isInStr[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isInStr[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isInStr[] FAILED"))]

  // test_toUpper_toLower
  ret: test_toUpper_toLower[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test toUpper[] and toLower[] SUCCEEDED")) ; retMsg: retMsg , (,("Test toUpper[] and toLower[] FAILED"))]

  // test_isEven_isOdd[]
  ret: test_isEven_isOdd[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test isEven[], isOdd[] SUCCEEDED")) ; retMsg: retMsg , (,("Test isEven[], isOdd[] FAILED"))]
  // /Call Tests Here
  
  retMsg: retMsg , (,(""))
  retMsg: retMsg , (,(""))
  
  :retMsg
}

// ** /HARNESS