// ************** 
// File: graph.k
// Descr: Graph data structure. Generic graph can be used as a basis for various more restricted tree implementations.
// **************

// Load namespace so calls use namespace.function to appear more OO style
\d .graph
\l utils

// Graph Vertex data structure:
//  Each node is a handle to the client, just an int internally
//  Data vector stores data associated with each node, indexed by handle
//  ParentChild adjacency matrix sets bits in column indexes (handle values)
//   for columns that are children of the row index (handle value)

// **** ctor ****
// Descr: 	Construct a new graph
// Return:	an intialized graph
ctor: { []
  data: ,(`ROOT; ,`NONE)   
  // Initial size is 1, the root
  size: 1
  // No data yet, lazy initialization to minimize memory footprint, just init root child row
  // Root element of a matrix, 2D list with one element
  parentChild: ,&size
  // Flag indicating graph has been converted to read-only sparse representation
  isLocked: 0

  :(data; parentChild; 0; size; isLocked)    
}

// **** getRoot ****
// Descr: 	Returns handle to graph root
// Args: 	none
// Return:	A handle to the root of any graph, always = 0
getRoot: {:0}

// **** getData ****
// Descr: 	Retrieves the data item stored in the graph for a node
// Args: 	node - handle to a node in the graph
//			graph - a  graph to be read
// Return:	Data item, can be any K type
getData: { [node; graph]
  :graph[0][node]
}

// **** getParents ****
// Descr: 	Retrieves handle list of parents of node arg
// Args: 	node - handle to a node in the graph
//			graph - a  graph to be read
// Return:	Integer vector of handles that are parents to node
getParents: { [node; graph]  
  // Not locked? Get column for node, set bits are the parents of node, that is, the rows with
  //  node as a child. Note we're instantiating rows lazily, so we can't just get column
  //  from parentChild, because rows at index >= size are uninitialized, not a list of length capacity yet
  //  So truncate parentChild to width (capacity) by size (initialized rows)
  // Is locked, just return list from locked parents list of lists at node index
  
  size: graph[3]
  graph[1]
  
  :[~graph[4]; :&({[x] :x[node]}'(size # graph[1])); :graph[5][node]]	
} 

// **** getChildren ****
// Descr: 	Retrieves handle list of children of node arg
// Args: 	node - handle to a node in the graph
//			graph - a graph to be read
// Return:	Integer vector of handles that are children to node
getChildren: { [node; graph]
  :[~graph[4]; :&(graph[1][node]); :graph[6][node]]  
}

// **** getChildCount ****
// Descr: 	Returns count of children for handle to node passed in
// Args: 	node - handle to node in graph
//			graph - a  graph to be read
// Return:	a non-negative scalar count of children of node
getChildCount: { [node; graph]
  :#getChildren[node; graph] 
}

// **** getChildCount ****
// Descr: 	Returns count of parents for handle to node passed in
// Args: 	node - handle to node in graph
//			graph - a  graph to be read
// Return:	a non-negative scalar count of parents of node
getParentCount: { [node; graph]
  :#getParents[node; graph]
}

// **** isLeaf ****
// Descr: 	Returns predicate indicating whether node is a leaf node, i.e. has no children
// Args: 	node - handle to node in graph
//			graph - a  graph to be read
// Return:	predicate indicating whether node is a leaf 
isLeaf: { [node; graph]
  :getChildCount[node; graph] = 0
}

// **** isRoot ****
// Descr: 	Returns predicate indicating whether node is the root node, i.e. has no parents
// Args: 	node - handle to node in graph
//			graph - a  graph to be read
// Return:	predicate indicating whether node is the root
isRoot: { [node; graph]
  :getParentCount[node; graph] = 0
}

// **** contains ****
// Descr: 	Returns a predicate indicating whether a graph contains a particular data item
// Args: 	dataItem - item to match
//          graph - a graph to be tested for ownership of item matching data			
// Return:	a predicate indicating whether graph contains data
contains: { [dataItem; graph] 
  dataItemType: (4: dataItem) 
  graphDataItems: graph[0]
  j: 0; jBound: #graphDataItems
  while[j < jBound
    graphDataItem: graphDataItems[j]
    if[(4: graphDataItem) = dataItemType
      :[graphDataItem = dataItem; :1; ]  
    ]
    j: j + 1
  ]
  
  :0
}


// DO NOT USE THE METHODS BELOW THIS COMMENT ...

// NOTE: Not used because does not modify in place. So useful for small graphs, but large ones should
//  be modified in place, which requires that the variable be declared global and modified in a function
//  in the same translation unit as it is declared in, modified by its symbol name, in an Amend variation.
// So this is here and unit tested, but this caveat applies.
// **** addChild ****
// Descr: 	Adds child node as with data as child of parent handle in graph passed in
// Args: 	data - child vertex data
//          parent - handle to parent of child
//			graph - a  graph to be modified
// Return:	a tuple of a handle to the child and the modified graph
addChild: { [data; parent; graph]

  :[graph[4]; '".graph.addChild[]. Illegal append operation on locked graph. Locked graphs are not modifiable."; ]
 
  // Get next handle, and init a row for it
  nextHandleRet: nextHandle[graph]
  handle: nextHandleRet[0]
  graph: nextHandleRet[1]

  // Ignore self-links
  if[~(parent = handle)    
    // Reserve space for next index in data vector so elements that themselves include lists
    //  are inserted correctly with Amend, because index already is present and discrete in list
    graph[0]: graph[0] , (,0)
    graph[0]: .[graph[0]; handle; :; data]
    
    // Now write in parent child relationship for new child row  
    // newParentChild: graph[1]
    // Set parent ref to child, child to parent
    graph[1]: .[graph[1]; (parent; handle); :; 1]
  ]

  :(handle; (graph[0]; graph[1]; graph[2]; graph[3]; graph[4]))  
}

// NOTE: Not used because does not modify in place. So useful for small graphs, but large ones should
//  be modified in place, which requires that the variable be declared global and modified in a function
//  in the same translation unit as it is declared in, modified by its symbol name, in an Amend variation.
// So this is here and unit tested, but this caveat applies.
// **** appendChild ****
// Descr: 	Adds child to row of parent and parent to column of child
// Args: 	child - handle to child node
//          parent - handle to parent node
//			graph - a  graph to be modified
// Return:	the modified graph
appendChild: { [child; parent; graph] 
  :[graph[4]; '".graph.appendChild[]. Illegal append operation on locked graph. Locked graphs are not modifiable."; ]
  
  nextHandleRet: nextHandle[graph]
  maxIdx: nextHandleRet[0]
  graph: nextHandleRet[1]
  
  :[~(child < maxIdx) | (parent < maxIdx); '".graph.appendChild[]. Invalid parent or child handle, out of range of current allocated nodes"; ]
  
  // Ignore self-links
  if[~(parent = child)
    // Set parent ref to child, child to parent
    graph[1]: .[graph[1]; (parent; child); :; 1]
  ]
  
  :(graph[0]; graph[1]; graph[2]; graph[3]; graph[4]) 
}

// NOTE: Not unit tested
// NOTE: Doesn't modify in place so not recommended for large graphs
// **** removeChild ****
// Descr: 	Removes child from row of parent and parent from column of child
// Args: 	child - handle to child node
//          parent - handle to parent node
//			graph - a  graph to be modified
// Return:	the modified graph
removeChild: { [child; parent; graph] 
  :[graph[4]; '".graph.removeChild[]. Illegal append operation on locked graph. Locked graphs are not modifiable."; ]
  
  nextHandleRet: nextHandle[graph]
  maxIdx: nextHandleRet[0]
  graph: nextHandleRet[1]
  
  :[~(child < maxIdx) | (parent < maxIdx); '".graph.appendChild[]. Invalid parent or child handle, out of range of current allocated nodes"; ]
  
  // Ignore self-links
  if[~(parent = child)
    // Set parent ref to child, child to parent
    graph[1]: .[graph[1]; (parent; child); :; 0]
  ]
  
  :(graph[0]; graph[1]; graph[2]; graph[3]; graph[4]) 
}

// NOTE: Not used because does not modify in place. So useful for small graphs, but large ones should
//  be modified in place, which requires that the variable be declared global and modified in a function
//  in the same translation unit as it is declared in, modified by its symbol name, in an Amend variation.
// So this is here and unit tested, but this caveat applies.
// **** lock ****
// Descr: 	Converts graph to sparse representation that is read-only. After call to lock[], no 
//			more children may be appended or added
// Args:    graph - a  graph to be locked			
// Return:	the modified graph
lock: { [graph]
  
  // TEMP DEBUG
  .utils.dbgPrint[graph; "graph"; ".graph.lock[] BEFORE locking/space optimization"; 0]
  // /TEMP DEBUG
  
  capacity: graph[2]; size: graph[3]
  // Truncate data element to size number of elements
  data: graph[0]
  data: ((-1) * ((#data) - size)) _ data
  
  // TEMP DEBUG
  .utils.dbgPrint[data; "data"; ".graph.lock[] AFTER DROP/CUT"; 0]
  // /TEMP DEBUG  
  
  // Build sparse representation, store only list of indexes (handles) for each parent/child index, empty list for
  //  for all rows with no children, columns with no parents.
  j: 0
  parents: &size
  children: &size
  while[j < size
    curParents: &({[x] : x[j]}'(graph[1]))
    :[~.utils.isEmptyVector[curParents]; parents[j]: curParents; parents[j]: !0]    
    curChildren: &(graph[1][j])
    :[~.utils.isEmptyVector[curChildren]; children[j]: curChildren; children[j]: !0]
    
    j: j + 1
  ]
    
  // TEMP DEBUG
  .utils.dbgPrint[(data; _n; graph[2]; graph[3]; 1; parents; children); "graph"; ".graph.lock[] AFTER locking/space optimization"; 0]
  // /TEMP DEBUG
  
  // Data table truncated to size, from initial allocation of capacity, index 0
  // Release memory for full bit matrix representation, index 1
  // Capacity int unchanged, index 2
  // Size int unchanged, index 3
  // Set locked indicator, index 4
  // Append new sparse parent and child lists, indices 5 and 6  
  :(data; _n; graph[2]; graph[3]; 1; parents; children)  
}

// NOTE: Not used because does not modify in place. So useful for small graphs, but large ones should
//  be modified in place, which requires that the variable be declared global and modified in a function
//  in the same translation unit as it is declared in, modified by its symbol name, in an Amend variation.
// So this is here and unit tested, but this caveat applies.
// Helpers
nextHandle: { [graph]
  size: graph[3]
  // Get next index to return as handle, and to use to initialize next row
  retHandle: size
  
  // TEMP DEBUG
  .utils.dbgPrint[g_graphHandle; "g_graphHandle"; ".graph.nextHandle[] AFTER ASSIGN"; 0]
  .utils.dbgPrint[g_parentChild; "g_parentChild"; ".graph.nextHandle[] AFTER ASSIGN"; 0]
  .utils.dbgPrint[!#g_parentChild; "!#g_parentChild"; ".graph.nextHandle[] AFTER ASSIGN"; 0]
  .utils.dbgPrint[4: g_parentChild; "4: g_parentChild"; ".graph.nextHandle[] AFTER ASSIGN"; 0]
  .utils.dbgPrint[4: `g_parentChild; "4: `g_parentChild"; ".graph.nextHandle[] AFTER ASSIGN"; 0]
  // /TEMP DEBUG

  .[g_parentChild; !#g_parentChild; {[x] :x , 0}]

  // TEMP DEBUG
  .utils.dbgPrint[g_parentChild; "g_parentChild"; ".graph.nextHandle[] AFTER AMEND"; 0]
  // /TEMP DEBUG

  .[g_graphHandle; 1; :; `g_parentChild , (,& (size + 1))]

  // TEMP DEBUG
  .utils.dbgPrint[g_graphHandle; "g_graphHandle"; ".graph.nextHandle[] AFTER AMEND"; 0]
  // /TEMP DEBUG

  // parentChild: {[x] :x,0}'graph[1]
  // Now append the new row for the new handle
  // parentChild: parentChild , (,& (size + 1))
  
  // TEMP DEBUG
  .utils.dbgPrint[graph[1]; "graph[1]"; ".graph.nextHandle[]"; 0]
  .utils.dbgPrint[#parentChild; "#parentChild"; ".graph.nextHandle[]"; 0]
  .utils.dbgPrint[^parentChild; "^parentChild"; ".graph.nextHandle[]"; 0]
  .utils.dbgPrint[parentChild; "parentChild"; ".graph.nextHandle[]"; 0]
  // /TEMP DEBUG
  
  :(retHandle; (graph[0]; parentChild; graph[2]; size + 1; graph[4]))
}

// /DO NOT USE THE METHODS BELOW THIS COMMENT ...
