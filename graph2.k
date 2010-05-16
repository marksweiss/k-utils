\l utils

// Graph

// Moved from graph.k to here because we need to modify our large graph structure in place rather than by
//	value or the k runtime reaches its maximum for allocated RAM and craps out.
// .[`d; i; f; y] rather than d: .[d; i; f; y] requires that:
//
// d must be a list, NOT a vector or convertible to a vector, that is (4: d) = 0
// d must be declared at global scope, not local to function block
// i must be a non-neg int or vector of non-neg ints
// i must refer to only legal indexes of d
// .[`d; i; f; y] can be at global scope
// .[`d; i; f; y] can be within a function block, but if it is, global declared d must be passed to 
//  the function through a function argument.  The argument name must be used -- it cannot be reassigned
//  to another block-scope name and that name then used.
// d and .[`d; i; f; y] must be in the same translation unit (.k file), which is why module-style encapsulation
//  is broken and this function is moved into this module -- it has to be to get this to work.



// **** ctor ****
// Descr: 	Construct a new graph
// Return:	an intialized graph
graph_ctor: {
  data: ,(`ROOT; ,`NONE)   
  parents: ,_n
  children: ,_n
  // Initial size is 1, the root
  size: 1
  freeList: ()

  :(data; (parents; children); size; freeList)    
}

// **** getRoot ****
// Descr: 	Returns handle to graph root
// Args: 	none
// Return:	A handle to the root of any graph, always = 0
graph_getRoot: {:0}


// **** Parse Tree globals **** 
root: graph_getRoot[]
g_treeCache: &1; g_cacheIdx: 0
g_treeCache[g_cacheIdx]: (`NONE; graph_ctor[])
g_tree: g_treeCache[g_cacheIdx]
// **** /Parse Tree globals **** 


// **** graph_nextHandle ****
// Descr: 	Returns the handle that will be assigned to the next child added. If client needs to store this, e.g. -
//          if client code wants some node object to carry its graph handle with it
// Args: 	none
// Return:	a handle that is currently valid but will become valid on the next call to addChild[]
graph_nextHandle: { [] 
  // Get next index to return as handle, either the head of the free list or the current size, which will be
  //  the next handle allocated if none previously allocated are free to reuse
  freeList: g_treeCache[g_cacheIdx][1][3]; 
  size: g_treeCache[g_cacheIdx][1][2] 
  :[~.utils.isEmptyList[freeList]; :freeList[0]; :size]
}

// **** graph_addChild ****
// Descr: 	Adds new child node with data as child of parent handle in graph passed in
// Args: 	data - child vertex data
//          parent - handle to parent of child
// Return:	a handle to the child
graph_addChild: { [data; parent]
  // Get next index to return as handle
  child: -1
  freeList: g_treeCache[g_cacheIdx][1][3]
  isFreeListEmpty: .utils.isEmptyList[freeList]
  if[~isFreeListEmpty;
    child: freeList[0]
    .[`g_treeCache; (g_cacheIdx; 1; 3); _di; 0]
    // Set existing child index being reused to new data
    graph_setData[data; child]
    // Append child to parent, parent to child
    .[`g_treeCache; (g_cacheIdx; 1; 1; 0; child); ,; parent]
    .[`g_treeCache; (g_cacheIdx; 1; 1; 1; parent); ,; child]
  ]
  if[isFreeListEmpty
    child: g_treeCache[g_cacheIdx][1][2]
    // Append data element      
    .[`g_treeCache; (g_cacheIdx; 1; 0); ,; ,data]
    // Increment size for child being added
    .[`g_treeCache; (g_cacheIdx; 1; 2); :; (g_treeCache[g_cacheIdx][1][2]) + 1]
  
    // Append child to parent, parent to child
    .[`g_treeCache; (g_cacheIdx; 1; 1; 0); ,; ,(,parent)]
    .[`g_treeCache; (g_cacheIdx; 1; 1; 1); ,; ,(())]
    .[`g_treeCache; (g_cacheIdx; 1; 1; 1; parent); ,; child]
  ]
  
  // Return handle to new child element added
  :child  
}

// **** graph_addChildLink ****
// Descr: 	Links existing child node as child of parent handle in graph passed in
// Args: 	child - hanlde to child
//          parent - handle to parent of child
// Return:	a handle to the child
graph_addChildLink: { [parent; child]
  // Append child to parent, parent to child
  // Self-links are illegal
  if[~(parent = child)
    .[`g_treeCache; (g_cacheIdx; 1; 1; 0; child); ,; parent]
    .[`g_treeCache; (g_cacheIdx; 1; 1; 1; parent); ,; child]
  ]
}

// **** graph_removeChildLink ****
// Descr: 	Removes child from row of parent and parent from column of child
// Args: 	parent - handle to parent node
//          child - handle to child node
// Return:	none
graph_removeChildLink: { [parent; child] 
  .[`g_treeCache; (g_cacheIdx; 1; 1; 0; child); _dv; parent]
  .[`g_treeCache; (g_cacheIdx; 1; 1; 1; parent); _dv; child]
  // Nil the data element      
  .[`g_treeCache; (g_cacheIdx; 1; 0; child); :; _n]
  // Append child index to free list
  .[`g_treeCache; (g_cacheIdx; 1; 3); ,; child]
}

// **** graph_removeChildLinks ****
// Descr: 	Removes all children from row of parent and parent from column of children
// Args: 	parent - handle to parent node
// Return:	none
graph_removeChildLinks: { [parent] 
  children: graph_getChildren[parent]
  j: 0; jBound: #children
  while[j < jBound
    graph_removeChildLink[parent; children[j]]
    j: j + 1
  ]
}

// **** isLeaf ****
// Descr: 	Returns predicate indicating whether node is a leaf node, i.e. has no children
// Args: 	node - handle to node in graph
//			graph - a  graph to be read
// Return:	predicate indicating whether node is a leaf 
graph_isLeaf: { [node]
  // No children list for node
  :(#(graph_getChildren[node])) = 0
}

// **** getChildren ****
// Descr: 	Retrieves handle list of children of node arg
// Args: 	node - handle to a node in the graph
//			graph - a graph to be read
// Return:	Integer vector of handles that are children of node
graph_getChildren: { [node]
  // Handle root case
  root: graph_getRoot[]
  if[node = root
    children: g_treeCache[g_cacheIdx][1][1][1][root]
    :children[1 + (!((#children) - 1))]
  ]

  :[~(node < (#(g_treeCache[g_cacheIdx][1][1][1]))); :(); ]
  :g_treeCache[g_cacheIdx][1][1][1][node]
}

// **** getParents ****
// Descr: 	Retrieves handle list of parents of node arg
// Args: 	node - handle to a node in the graph
//			graph - a graph to be read
// Return:	Integer vector of handles that are parents of node
graph_getParents: { [node]
  // Handle root case
  :[node = graph_getRoot[]; :(); ]

  :[~(node < (#(g_treeCache[g_cacheIdx][1][1][0]))); :(); ]
  :g_treeCache[g_cacheIdx][1][1][0][node]
}

// **** getData ****
// Descr: 	Retrieves the data item stored in the graph for a node
// Args: 	node - handle to a node in the graph
//			graph - a  graph to be read
// Return:	Data item, can be any K type
graph_getData: { [node]
  :g_treeCache[g_cacheIdx][1][0][node]
}

// **** setData ****
// Descr: 	Sets the data item stored in the graph for a node
// Args: 	data - child vertex data
//          node - node whose data is to be manipulated
// Return:	none
graph_setData: { [data; node]
  // Assign data element      
  .[`g_treeCache; (g_cacheIdx; 1; 0; node); :; data]
}

// /Graph


// -----------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------


// Graph Tests

// ** TESTS

// graph: test_getNextHandle1[]
// Return invariants:
// Will return current size if no nodes have been removed from the graph
// Will return the handle removed least recently (oldest) from the graph that is not in use
test_getNextHandle1: {
  ret: ()
    
  nextHandle: graph_getNextHandle[]
  child0: graph_addChild[`data0; root]
  
  ret: ret , (nextHandle = child0) 
     
  :ret
}


// graph: test_addChild_getChildCount[]
// Return invariants:
// Each call to addChild[] returns a handle to the node added that is unique among all nodes
// Data stored associated with handle of newly added node returned
// Each call updates the graph to record the relationship of parent to newly added node and newly added node to parent
test_addChild_getChildren_getParents_getNodeData: {
  ret: ()
  
  child1: graph_addChild[`data1; root]
  child2: graph_addChild[`data2; root]
  
  ret: ret , (~(child1 = child2))

  data1: graph_getData[child1]
  data2: graph_getData[child2]

  ret: ret , (~(data1 = data2))
  
  children: graph_getChildren[root]
  
  ret: ret , ((#children) = 3)
  ret: ret , ((children ? child1) < (#children))
  ret: ret , ((children ? child2) < (#children))
  
  parents: graph_getParents[child1]

  ret: ret , ((#parents) = 1)
  ret: ret , ((parents ? root) < (#parents))

  parents: graph_getParents[child2]

  ret: ret , ((#parents) = 1)
  ret: ret , ((parents ? root) < (#parents))
  
  child3: graph_addChild[`data3; root]
  child4: graph_addChild[`data4; root]
  child5: graph_addChild[`data5; root]

  ret: ret , ( (~(child3 = child4)) & (~(child3 = child5)) & (~(child4 = child5)) )
  ret: ret , (~(child1 = child2))

  data3: graph_getData[child3]
  data4: graph_getData[child4]
  data5: graph_getData[child5]

  ret: ret , ((data3 = `data3) & (data4 = `data4) & (data5 = `data5))
  ret: ret , (~(data1 = data2))

  children: graph_getChildren[root]

  ret: ret , ((#children) = 6)
  ret: ret , ((children ? child3) < (#children))
  ret: ret , ((children ? child4) < (#children))
  ret: ret , ((children ? child5) < (#children))
  
  parents: graph_getParents[child3]

  ret: ret , ((#parents) = 1)
  ret: ret , ((parents ? root) < (#parents))  

  parents: graph_getParents[child1]

  ret: ret , ((#parents) = 1)
  ret: ret , ((parents ? root) < (#parents))  
  
  // Test invalid handle for get children, for validation
  children: graph_getChildren[10000]
  
  ret: ret , ((#children) = 0)
  ret: ret , .utils.isEmptyList[children]
  
  parents: graph_getParents[10000]
  
  ret: ret , ((#parents) = 0)
  ret: ret , .utils.isEmptyList[parents]
          
  :ret
}

// graph: test_isLeaf[]
// Return invariants:
// Returns true if node has no children and false if it has one or more children
test_isLeaf: {
  ret: ()
  
  ret: ret , (~graph_isLeaf[root])
  
  child6: graph_addChild[`data6; root]
  
  ret: ret , (graph_isLeaf[child6])
      
  :ret
}

// graph: test_addChildLink_removeChildLink[]
// Return invariants:
// After call to addChildLink, child arg will be on children list of parent
// After call to removeChildLink, child arg will not be on children list of parent
test_addChildLink_removeChildLink: {
  ret: ()
  
  child7: graph_addChild[`data7; root]
  childrenOfRoot: graph_getChildren[root]
  firstChildOfRoot: *childrenOfRoot
  childrenOfFirstChild: graph_getChildren[firstChildOfRoot]
  
  ret: ret , ((childrenOfRoot ? child7) < (#childrenOfRoot))  
  ret: ret , (~((childrenOfFirstChild ? child7) < (#childrenOfFirstChild)))
  
  graph_addChildLink[firstChildOfRoot; child7]  
  childrenOfFirstChild: graph_getChildren[firstChildOfRoot]

  ret: ret , ((childrenOfFirstChild ? child7) < (#childrenOfFirstChild))
  
  parentsOfFirstChild: graph_getParents[firstChildOfRoot]

  ret: ret , ((parentsOfFirstChild ? root) < (#parentsOfFirstChild))

  parentsOfChild7: graph_getParents[child7]

  ret: ret , ((parentsOfChild7 ? firstChildOfRoot) < (#parentsOfChild7))
  
  graph_removeChildLink[firstChildOfRoot; child7]
  childrenOfFirstChild: graph_getChildren[firstChildOfRoot]

  ret: ret , (~((childrenOfFirstChild ? child7) < (#childrenOfFirstChild)))
       
  :ret
}

// graph: test_setData_getData[]
// Return invariants:
// After call to setData[] node arg will have data arg as its data, and this data will be returned by getData with 
//  that node as arg
test_setData_getData: {
  ret: ()
  
  child8: graph_addChild[`data8; root]
  
  ret: ret , (`data8 = graph_getData[child8])
       
  graph_setData[`data8_changed; child8]     

  ret: ret , (`data8_changed = graph_getData[child8])
  
  :ret
}

// graph: test_removeChildLinks[]
// Return invariants:
// After call to removeChildLinks, parent arg will have no children
test_removeChildLinks: {
  ret: ()
    
  ret: ret , ((#graph_getChildren[root]) > 0)  
  
  graph_removeChildLinks[root]  

  ret: ret , ((#graph_getChildren[root]) = 0)  
       
  :ret
}

// graph: test_getNextHandle2[]
// Return invariants:
// Will return current size if no nodes have been removed from the graph
// Will return the handle removed least recently (oldest) from the graph that is not in use
test_getNextHandle2: {
  ret: ()
    
  nextHandle: graph_getNextHandle[]
  child9: graph_addChild[`data9; root] 
  
  ret: ret , (nextHandle = child9) 
  
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
  retMsg: retMsg , (,("graph_UT TEST RESULTS"))
  retMsg: retMsg , (,("---------------------"))

  // Call Tests Here
  
  // test_getNextHandle1[]	
  ret: test_getNextHandle1[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test graph_getNextHandle(1)[] SUCCEEDED")) ; retMsg: retMsg , (,("Test graph_getNextHandle(1)[] FAILED"))]

  // test_addChild_getChildren_getParents_getNodeData[]	
  ret: test_addChild_getChildren_getParents_getNodeData[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test graph_addChild[], getChildren[], getParents[], getNodeData[], SUCCEEDED")) ; retMsg: retMsg , (,("Test graph_addChild[], getChildren[], getParents[], getNodeData[] FAILED"))]

  // test_isLeaf[]	
  ret: test_isLeaf[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test graph_isLeaf[] SUCCEEDED")) ; retMsg: retMsg , (,("Test graph_isLeaf[] FAILED"))]

  // test_addChildLink_removeChildLink[]	
  ret: test_addChildLink_removeChildLink[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test graph_addChildLink[], graph_removeChildLink[] SUCCEEDED")) ; retMsg: retMsg , (,("Test graph_addChildLink[], graph_removeChildLink[] FAILED"))]

  // test_setData_getData[]	
  ret: test_setData_getData[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test graph_setData[], graph_getData[] SUCCEEDED")) ; retMsg: retMsg , (,("Test graph_setData[], graph_getData[] FAILED"))]

  // test_removeChildLinks[]	
  ret: test_removeChildLinks[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test graph_removeChildLinks[] SUCCEEDED")) ; retMsg: retMsg , (,("Test graph_removeChildLinks[] FAILED"))]

  // test_getNextHandle2[]	
  ret: test_getNextHandle2[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test graph_getNextHandle(2)[] SUCCEEDED")) ; retMsg: retMsg , (,("Test graph_getNextHandle(2)[] FAILED"))]

  // /Call Tests Here

  retMsg: retMsg , (,(""))
  retMsg: retMsg , (,(""))
  
  :retMsg
}

// ** /HARNESS

// /Graph Tests