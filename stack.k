// ************** 
// File: stack.k
// Descr: Stack data structure 
// **************

// Load namespace so calls use namespace.function to appear more OO style
\d .stack
\l utils

// Initialize stack with designated empty symbol, for convenience
ctor: {:(, `EMPTY)}

// **** push ****
// Descr: 	Pushes item onto stack passed in
// Args: 	item - item to push onto stack
//			stack - stack to manipulate
// Return:	stack passed in with item pushed on
push: { [item; stack] 
  :[isStack[stack]; ; '"k2q.stack.push{}: arg1 must be a stack"]

  :(item , stack)
}

// **** pushListItems ****
// Descr: 	Pushes a list or vector of one or more item onto stack passed in. 
//			NOTE: the items in the list or vector are joined onto the front of the stack, 
//			as though each had been pushed successively with push{}
// Args: 	items - list or vector of items to push onto stack
//			stack - stack to manipulate
// Return:	stack passed in with item pushed on
pushListItems: { [items; stack]
  // Validation
  :[.utils.isVectorList[items]; ; '"k2q.stack.pushListItems{}: arg0 must be a homogenous vector or heterogenous list"]
  :[isStack[stack]; ; '"k2q.stack.pushListItems{}: arg1 must be a stack"]

  j: 0
  while[j < (#items)    
    stack: push[items[j]; stack]
    j: j + 1
  ]
  
  :stack 
}

// **** pushList ****
// Descr: 	Pushes a list or vector as a unit onto the stack.
//			NOTE: unlike pushListItems{}, the items are pushed on as a group, enlisted, so the vector or list
//			is nested together one level from the top level of items pushed onto the containing stack 
// Args: 	lstItem - a list or vector to push onto the containing stack
//			stack - stack to manipulate
// Return:	stack passed in with lstItem pushed on
pushList: { [lstItem; stack]
  // Validation
  :[.utils.isVectorList[lstItem]; ; '"k2q.stack.pushList{}: arg0 must be a homogenous vector or heterogenous list"]
  :[isStack[stack]; ; '"k2q.stack.pushList{}: arg1 must be a stack"]
  
  :push[,lstItem; stack]
}

// **** pushStack ****
// Descr: 	Pushes a list or vector being used to represent a stack as a unit onto the stack.
//			NOTE: unlike pushListItems{}, the items are pushed on as a group, enlisted, so the vector or list
//			representing the stack is nested together one level from the top level of items pushed onto 
//			the containing stack 
// Args: 	stackItem - a stack to push onto the containing stack
//			stack - stack to manipulate
// Return:	stack passed in with stackItem pushed on
pushStack: { [stackItem; stack]
  // Validation
  :[isStack[stackItem]; ; '"k2q.stack.pushStack{}: arg0 must be a stack"]
  :[isStack[stack]; ; '"k2q.stack.pushStack{}: arg1 must be a stack"]

  stack: push[,stackItem; stack]
  :stack
}

// **** pop ****
// Descr: 	Pops item from stack passed in
// Args: 	stack - stack to manipulate
// Return:	stack passed in with item popped off
pop: { [stack]
  // Validation
  :[isStack[stack]; ; '"k2q.stack.pop{}: arg0 must be a stack"]

  :[(#stack) = 1; :stack; :(1 _ stack)] 	  
}

// **** popN ****
// Descr: 	Pops item from stack passed in
// Args: 	N - positive integer indicating number of items to pop
//			stack - stack to manipulate
// Return:	stack passed in with items popped off
popN: { [N; stack]
  // Validation
  :[isStack[stack]; ; '"k2q.stack.popN{}: arg0 must be a stack"]
  :[N > 0; ; '"k2q.stack.popN{}: arg1 must be a positive integer"]
  
  j: 0
  while[j < N    
    stack: pop[stack]
    j: j + 1
  ]
  
  :stack 
}

// **** peek ****
// Descr: 	Returns value of item on top of stack, or _n if the stack is empty
// Args: 	stack - stack to manipulate
// Return:	Value of item on top of stack, or _n if the stack is empty
peek: { [stack]
  // Validation
  :[isStack[stack]; ; '"k2q.stack.peek{}: arg0 must be a stack"]
  
  :[(#stack) = 1; :_n; :*stack]
}

// **** peekN ****
// Descr: 	Returns value of item at specified index on stack, or _n if the position specified
//			is not a valid position on the stack
// Args: 	stack - stack to manipulate
//          N - an index on the stack, 0-based
// Return:	Value of item on top of stack, or _n if N is not a valid index in stack
peekN: { [N; stack]
  // Validation
  :[isStack[stack]; ; '"k2q.stack.peekN{}: arg0 must be a stack"]
  :[~((isEmpty[stack]) | (count[stack] < N) | (N < 0)); ; '"k2q.stack.peekN{}: Illegal index argument: stack is empty or index is out of range of stack count"]
  
  :stack[((#stack) - (N + 2))]
}

// **** getAsList ****
// Descr: 	Returns all items in stack in stack order as a vector/list. Does not modify stack passed in.
// Args: 	stack - stack to manipulate
// Return:	All items in stack in stack order as a vector/list
getAsList: { [stack]
  // Validation
  :[isStack[stack]; ; '"k2q.stack.getAsList{}: arg0 must be a stack"]
  
  stackCopy: stack  
  ret: ()
  
  stackCount: count[stackCopy]
  do[stackCount    
    ret: ret , (peek[stackCopy])
    stackCopy: pop[stackCopy]
  ]
    
  :ret  
}

// **** clear ****
// Descr: 	Removes all items from the stack
// Args: 	stack - stack to manipulate
// Return:	void
clear: { [stack]
  // Validation
  :[isStack[stack]; ; '"k2q.stack.clear{}: arg0 must be a stack"]
  
  stack: (, `EMPTY)
  :stack
}

// **** count ****
// Descr: 	Returns number of item in the stack, not including designated EMPTY item
// Args: 	stack - stack to return count of
// Return:	Non-negative scalar indicating the number of elements stored in stack
count: { [stack]
  // Validation
  :[isStack[stack]; ; '"k2q.stack.count{}: arg0 must be a stack"]
  
  :((#stack) - 1)
}

// **** isEmpty ****
// Descr: 	Tests whether stack is empty
// Args: 	stack - stack to manipulate
// Return:	Predicate indicating whether stack is empty
isEmpty: { [stack]
  // Validation
  :[(isStack[stack]); ; '"k2q.stack.isEmpty{}: arg0 must be a stack"]

  // If the top of the stack is a symbol, return its equality to `EMPTY
  :((#stack) = 1)
}


// ** Helpers

// **** isStack ****
// Descr: 	Tests whether arg is a stack "type"
// Args: 	stack - object to test
// Return:	Predicate indicating whether arg is a stack
isStack: { [stack]
  if[.utils.isVectorList[stack]
    if[(#stack) > 0
      if[.utils.isSym[stack[((#stack) - 1)]]
        if[stack[((#stack) - 1)] = `EMPTY
          :1
        ]
      ]
    ]
  ]
  :0
}

// ** /Helpers