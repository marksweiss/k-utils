// Mark Weiss
// K2Q
// ************** 
// File: graph_UT.k
// Descr: Unit Tests for graph.k - graph data structure 
// \d graph -- loads graph.k and is intended to be run standalone with that module to test it
// **************

\l graph
\l utils


// ** TESTS

// graph: .graph.addChild_getChildCount[]
// Return invariants:
// Each call to addChild[] returns a monotonically increasing handle to the node added
// Data stored associated with handle of newly added node returned
// Each call updates the graph to record the relationship of parent to newly added node and newly added node to parent
// All calls return the same values after lock[] is called
test_addChild_getChildCount_getParentCount: {
  ret: ()
  
  graph: .graph.ctor[20]  
  root: .graph.getRoot[]
      
  graphRet: .graph.addChild[`data; root; graph]  
  child: graphRet[0]
  graph: graphRet[1]
  
  ret: ret , (.graph.getChildCount[root; graph] = 1)
  ret: ret , (.graph.getChildCount[child; graph] = 0)
  ret: ret , (.graph.getParentCount[root; graph] = 0)
  ret: ret , (.graph.getParentCount[child; graph] = 1)

  graphRet: .graph.addChild[`data2; root; graph]
  child2: graphRet[0]
  graph: graphRet[1] 
  
  ret: ret , (.graph.getChildCount[root; graph] = 2)
  ret: ret , (.graph.getChildCount[child; graph] = 0)
  ret: ret , (.graph.getChildCount[child2; graph] = 0)
  ret: ret , (.graph.getParentCount[child; graph] = 1)
  ret: ret , (.graph.getParentCount[child2; graph] = 1)
  
  // Now call lock[] and then retest
  graph: .graph.lock[graph]
  
  ret: ret , (.graph.getChildCount[root; graph] = 2)
  ret: ret , (.graph.getChildCount[child; graph] = 0)
  ret: ret , (.graph.getChildCount[child2; graph] = 0)
  ret: ret , (.graph.getParentCount[child; graph] = 1)
  ret: ret , (.graph.getParentCount[child2; graph] = 1)
  
  :ret
}

// graph: .graph.test_appendChild[]
// Return invariants:
// Graph will be updated to store relationship of parent to child and child to parent
test_appendChild: {
  ret: ()
  
  graph: .graph.ctor[20]  
  root: .graph.getRoot[]
  
  // Add two children to root    
  graphRet: .graph.addChild[`data; root; graph]  
  child1: graphRet[0]
  graph: graphRet[1]
  graphRet: .graph.addChild[`data2; root; graph]
  child2: graphRet[0]
  graph: graphRet[1]

  ret: ret , (.graph.getChildCount[root; graph] = 2)
  ret: ret , (.graph.getParentCount[root; graph] = 0)
  
  // Make first child of second
  ret: ret , (.graph.getChildCount[child2; graph] = 0)
  graph: .graph.appendChild[child1; child2; graph]
  ret: ret , (.graph.getChildCount[child2; graph] = 1)
  ret: ret , (.graph.getParentCount[child1; graph] = 2)

  // Make second child of first
  graph: .graph.appendChild[child2; child1; graph]
  ret: ret , (.graph.getChildCount[child1; graph] = 1)
  ret: ret , (.graph.getParentCount[child2; graph] = 2)

  // Idempotent on root
  ret: ret , (.graph.getChildCount[root; graph] = 2)
  ret: ret , (.graph.getParentCount[root; graph] = 0)
  
  // Now call lock[] and then retest
  graph: .graph.lock[graph]
  
  ret: ret , (.graph.getChildCount[root; graph] = 2)
  ret: ret , (.graph.getParentCount[root; graph] = 0)
    
  :ret
}

// graph: .graph.test_isLeaf_isRoot[]
// Return invariants:
// Node with child count of 0 returns true for isLeaf, any other child count returns false
// Node with parent count of 0 returns true for isRoot, any other parent count returns false
test_isLeaf_isRoot: {
  ret: ()
  
  graph: .graph.ctor[20]  
  root: .graph.getRoot[]
  ret: ret , (.graph.isRoot[root; graph] = 1)
  ret: ret , (.graph.isLeaf[root; graph] = 1)
      
  graphRet: .graph.addChild[`data; root; graph]  
  child1: graphRet[0]
  graph: graphRet[1]  
  ret: ret , (.graph.isRoot[root; graph] = 1)
  ret: ret , (.graph.isLeaf[root; graph] = 0)
  ret: ret , (.graph.isRoot[child1; graph] = 0)
  ret: ret , (.graph.isLeaf[child1; graph] = 1)
  
  graphRet: .graph.addChild[`data2; root; graph]
  child2: graphRet[0]
  graph: graphRet[1]
  // Make first child of second
  graph: .graph.appendChild[child1; child2; graph]
  ret: ret , (.graph.isRoot[root; graph] = 1)
  ret: ret , (.graph.isLeaf[root; graph] = 0)
  ret: ret , (.graph.isRoot[child1; graph] = 0)
  ret: ret , (.graph.isLeaf[child1; graph] = 1)  
  ret: ret , (.graph.isRoot[child2; graph] = 0)
  ret: ret , (.graph.isLeaf[child2; graph] = 0)  

  // Now call lock[] and then retest
  graph: .graph.lock[graph]

  ret: ret , (.graph.isRoot[root; graph] = 1)
  ret: ret , (.graph.isLeaf[root; graph] = 0)
  ret: ret , (.graph.isRoot[child1; graph] = 0)
  ret: ret , (.graph.isLeaf[child1; graph] = 1)  
  ret: ret , (.graph.isRoot[child2; graph] = 0)
  ret: ret , (.graph.isLeaf[child2; graph] = 0)  

  :ret
}

// graph: .graph.test_getParents_getChildren[]
// Return invariants:
// After each addChild[] or appendChild[] operation, getParents[] list of parents of child will include parent
//  and getChildren[] list of children of parent will include child
test_getParents_getChildren: {
  ret: ()
  
  graph: .graph.ctor[20]  
  root: .graph.getRoot[]
  
  // Add two children to root    
  graphRet: .graph.addChild[`data; root; graph]  
  child1: graphRet[0]
  graph: graphRet[1]
  graphRet: .graph.addChild[`data2; root; graph]
  child2: graphRet[0]
  graph: graphRet[1]
 
  children: .graph.getChildren[root; graph]
  ret: ret , (children[0] = child1)
  ret: ret , (children[1] = child2)

  parents1: .graph.getParents[child1; graph]
  ret: ret , (parents1[0] = root)
  parents2: .graph.getParents[child2; graph]
  ret: ret , (parents2[0] = root)
  
  // Make first child of second
  graph: .graph.appendChild[child1; child2; graph]
  children: .graph.getChildren[child2; graph]
  ret: ret , (children[0] = child1)

  // Make second child of first
  graph: .graph.appendChild[child2; child1; graph]
  children: .graph.getChildren[child1; graph]
  ret: ret , (children[0] = child2)
  
  // Now call lock[] and then retest
  graph: .graph.lock[graph]  

  ret: ret , (children[0] = child2)
  
  :ret
}

// graph: .graph.test_getData[]
// Return invariants:
//  Returns the data associated with the child handle argument, if the handle is valid for the graph, that is
//  if data has been populated for that index in the internal list of data elements of the graph, null otherwise
test_getData: {
  ret: ()
  
  graph: .graph.ctor[20]  
  root: .graph.getRoot[]
  
  // Add two children to root    
  graphRet: .graph.addChild[`data; root; graph]  
  child1: graphRet[0]
  graph: graphRet[1]
  graphRet: .graph.addChild[`data2; root; graph]
  child2: graphRet[0]
  graph: graphRet[1]
  
  ret: ret , (.graph.getData[child1; graph] = `data)
  ret: ret , (.graph.getData[child2; graph] = `data2)
  
  // Now call lock[] and then retest
  graph: .graph.lock[graph]  
  
  ret: ret , (.graph.getData[child1; graph] = `data)
  ret: ret , (.graph.getData[child2; graph] = `data2)
  
  :ret
}

// graph: .graph.contains[]
// Return invariants:
//  Returns true if the graph's data element list includes the data item argument passed in, false otherwise
test_contains: {
  ret: ()
  
  graph: .graph.ctor[20]  
  root: .graph.getRoot[]
  
  // Empty graph has no data
  ret: ret , (~(.graph.contains[`ANY_DATA; graph]))
  
  // Add two children to root    
  graphRet: .graph.addChild[`data; root; graph]  
  child1: graphRet[0]
  graph: graphRet[1]
  graphRet: .graph.addChild[`data2; root; graph]
  child2: graphRet[0]
  graph: graphRet[1]
  
  // Test case of containing data
  ret: ret , (.graph.contains[`data; graph])
  ret: ret , (.graph.contains[`data2; graph])
      
  // Test case of data not in the graph
  ret: ret , (~(.graph.contains[`data3; graph]))
    
  // Now call lock[] and then retest
  graph: .graph.lock[graph]    
  
  // Test case of containing data
  ret: ret , (.graph.contains[`data; graph])
  ret: ret , (.graph.contains[`data2; graph])
      
  // Test case of data not in the graph
  ret: ret , (~(.graph.contains[`data3; graph]))

  :ret
}

// graph: .graph.hasChild[]
// Return invariants:
//  Returns true if the graph includes the matchNode argument, false otherwise, where matchNode is a handle into the graph.
test_hasChild: {
  ret: ()
  
  graph: .graph.ctor[5]  
  root: .graph.getRoot[]
  
  // Add two children to root    
  graphRet: .graph.addChild[`data; root; graph]  
  child1: graphRet[0]
  graph: graphRet[1]
  graphRet: .graph.addChild[`data2; root; graph]
  child2: graphRet[0]
  graph: graphRet[1]
  
  // Test case of containing children
  ret: ret , (.graph.hasChild[child1; graph])
  ret: ret , (.graph.hasChild[child2; graph])
  
  child3: -1
  // Test case of child not in the graph
  ret: ret , (~(.graph.hasChild[child3; graph]))
    
  // Now call lock[] and then retest
  graph: .graph.lock[graph]    
  
  // Test case of containing data
  ret: ret , (.graph.hasChild[child1; graph])
  ret: ret , (.graph.hasChild[child2; graph])
      
  // Test case of data not in the graph
  ret: ret , (~(.graph.hasChild[child3; graph]))

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
  
  // test_addChild_getChildCount_getParentCount[]	
  ret: test_addChild_getChildCount_getParentCount[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .graph.addChild[], getChildCount[], getParentCount[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .graph.addChild[], getChildCount[], getParentCount[] FAILED"))]

  // test_appendChild[]	
  ret: test_appendChild[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .graph.appendChild[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .graph.appendChild[] FAILED"))]

  // test_isLeaf_isRoot[]	
  ret: test_isLeaf_isRoot[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .graph.isLeaf[], isRoot[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .graph.isLeaf[], isRoot[] FAILED"))]

  // test_getParents_getChildren[]	
  ret: test_getParents_getChildren[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .graph.getParents[], getChildren[] SUCCEEDED")) ; retMsg: retMsg , (,("Test .graph.getParents[], getChildren[] FAILED"))]

  // test_getData[]	
  ret: test_getData[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .graph.getData[] SUCCEEDED")) ; retMsg: retMsg , (,("Test graph.getData[] FAILED"))]

  // test_contains[]	
  ret: test_contains[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .graph.contains[] SUCCEEDED")) ; retMsg: retMsg , (,("Test graph.contains[] FAILED"))]

  // test_hasChild[]	
  ret: test_hasChild[]
  :[(+/ret) = (#ret); retMsg: retMsg , (,("Test .graph.hasChild[] SUCCEEDED")) ; retMsg: retMsg , (,("Test graph.hasChild[] FAILED"))]

  // /Call Tests Here

  retMsg: retMsg , (,(""))
  retMsg: retMsg , (,(""))
  
  :retMsg
}

// ** /HARNESS