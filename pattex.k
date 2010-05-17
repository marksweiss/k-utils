// ************** 
// File: pattex.k
// Descr: Pattern matching library based on regular expression syntax, but extended to suppport arbitrary 
//  patterns of symbols rather than just character pattern/seqing semantics
// **************

\d .pattex
\l utils

// **** PattEx ****
// Supported Syntax/Operators:
// `abc             - match exactly
// `abc*            - match zero or more
// `abc+            - match one or more
// `abc$            - match zero or one
// `abc^            - do not match 
// `abc#{n}         - match exactly n times, where n is an integer
// (`abc|`ABC)       - mach any in alternation exactly
// (`abc|`ABC)*      - match any in the alternation zero or more times
// (`abc|`ABC)+      - match any in the alternation one or more times
// (`abc|`ABC)$      - match any in the alternation zero or one time
// (`abc|`ABC)^      - do not match any in the alternation
// (`abc|`ABC)#{n}   - match any in the alternation exactly n times, where n is an integer
//
// ^ can be standalone in which case the match is the negation of a successful literal or entity match
// ^ can combine with an immediately following operator, in which csae the match is the negation of the match sequence within the context
//    of the handler for the following operator
//
// Operator chars as literals are esaped with leading slashes, e.g. "\\++" matches one or more
//
// Expressions must follow this format: MATCH_SEQ [OP[{N}]]
//  where bracketed elements are optional ... or ...
// Expressions must follow this format, with alternation supported: (MATCH_SEQ_1|MATCH_SEQ_1...)[OP[{N}]]
// Expressions may be chained: e.g. - LITERAL_SEQUENCE[OP](ENTITY1|ENTITY2)[OP{5}]
//

// Constants
NO_IDX: -1
NO_OP: `PTX_NO_OP
OP_DELIMS: `PTXOP_ZERO_MORE `PTXOP_ONE_MORE `PTXOP_ZERO_ONE `PTXOP_NOT `PTXOP_MATCH_N
// /Constants

// Entities
ANY: `PTX_ANY
// /Entities

// Handlers

matchLit: { [matchSeq; seq; isNotOp; isAlternation]
  matchSeqLen: #matchSeq
  seqLen: #seq
  :[seqLen < matchSeqLen; :NO_IDX; ]
  
  matchIdx: 0; j: 0  
  while[(~(matchIdx = NO_IDX)) & (j < matchSeqLen)  
    :[~((matchSeq[j] = ANY) | (matchSeq[j] = seq[j])); matchIdx: NO_IDX; j +: 1]    
  ]

  :[(j = matchSeqLen) & (~(matchIdx = NO_IDX)); :matchSeqLen; :NO_IDX]
}

matchOneOrMore: { [matchSeq; seq; isNotOp; isAlternation]
  :[(#seq) = 0; :NO_IDX; ]

  matchIdxs: getMatchIdxs[matchSeq; seq; isNotOp; NO_IDX; isAlternation]   
  
  :[(+/matchIdxs) = 0; :NO_IDX; ]  
  // Else use Group technique to find number of leading consecutively matched characters
  grpMatchIdxs: =matchIdxs  
  
  // Handle all zero or all one case, if all zero return no match, if all 1 return length of list
  :[(#grpMatchIdxs) = 1; :[matchIdxs[grpMatchIdxs[0][0]] = 1; :#(grpMatchIdxs[0]); :NO_IDX]; ]
  // Handle mixed zero and one case, return number of leading consecutive 1's
  if[(#grpMatchIdxs) = 2
    leadingMatchIndexCount: getLeadingMatchIdxCount[matchIdxs; grpMatchIdxs; #matchIdxs]    
    :[leadingMatchIndexCount > 0; :leadingMatchIndexCount; :NO_IDX]
  ]
}

matchZeroOrMore: { [matchSeq; seq; isNotOp; isAlternation] 
  :[(#seq) = 0; :0; ]
  
  matchIdxs: getMatchIdxs[matchSeq; seq; isNotOp; NO_IDX; isAlternation]  
  // If isNotOp then invert the values of the matchIdxs
  :[isNotOp; matchIdxs: ~matchIdxs; ]
 
  // Match zero case, report increment of zero but that is valid
  :[(+/matchIdxs) = 0; :0; ]
  // Else use Group technique to find number of leading consecutively matched characters  
  grpMatchIdxs: =matchIdxs
  :[(#grpMatchIdxs) = 1; :[matchIdxs[grpMatchIdxs[0][0]] = 1; :#(grpMatchIdxs[0]); :0]; ]
  if[(#grpMatchIdxs) = 2
    leadingMatchIdxCount: getLeadingMatchIdxCount[matchIdxs; grpMatchIdxs; #matchIdxs]
    :[leadingMatchIdxCount = NO_IDX; leadingMatchIdxCount: 0; ]
    :leadingMatchIdxCount
  ]
}

matchZeroOrOne: { [matchSeq; seq; isNotOp; isAlternation] 
  :[(#seq) = 0; :0; ]  

  matchIdxs: getMatchIdxs[matchSeq; seq; isNotOp; NO_IDX; isAlternation] 
  // If isNotOp then invert the values of the matchIdxs
  :[isNotOp; matchIdxs: ~matchIdxs]
  
  // Match zero case, report increment of zero but that is valid
  :[(+/matchIdxs) = 0; :0; ]
  // Match one case, report 1
  :[(*matchIdxs) = 1; :1; :NO_IDX] 
}

matchN: { [matchSeq; seq; isNotOp; n; isAlternation] 
  :[(#seq) = 0; :[n = 0; :0; :NO_IDX]; ]
  
  matchIdxs: getMatchIdxs[matchSeq; seq; isNotOp; n; isAlternation]  
        
    // If isNotOp then invert the values of the matchIdxs
  :[isNotOp; matchIdxs: ~matchIdxs; ]
  :[(+/matchIdxs) = 0; :[n = 0; :0; :NO_IDX]; ]
  
  grpMatchIdxs: =matchIdxs  
  
  if[(#grpMatchIdxs) = 1
    if[matchIdxs[grpMatchIdxs[0][0]] = 1
      if[(#grpMatchIdxs[0]) = n
        :n
      ]
      if[(~(#grpMatchIdxs[0]) = n)
        :NO_IDX
      ]
    ]
  ]
    
  :[(#grpMatchIdxs) = 2; :[getLeadingMatchIdxCount[matchIdxs; grpMatchIdxs; n] = n; :n; :NO_IDX]; ]
}

matchNot: { [matchSeq; seq; isNotOp; isAlternation] 
  // Special case for NOT, an empty seqing always matches the NOT of any matchSeq, but advances 0 characters
  :[(#seq) = 0; :0; ]
  // Otherwise, if lit doesn't match, advance by the length of matchSeq, if lit matches, then NOT is a fail
  :[matchLit[matchSeq; seq; isNotOp; isAlternation] = NO_IDX; :(#matchSeq); :NO_IDX]
}

// Ops/Handler Map
OPS_HANDLER_MAP: ((`PTXOP_ZERO_MORE;matchZeroOrMore);(`PTXOP_ONE_MORE;matchOneOrMore);(`PTXOP_NOT;matchNot);(`PTXOP_ZERO_ONE;matchZeroOrOne);(`PTXOP_MATCH_N;matchN))
// /Ops/Handler Map

// Handler Helpers
getLeadingMatchIdxCount: { [matchIdxs; grpMatchIdxs; n]
  // Depending on whether isNotOp or not, find which list is indexes of matches or not matches
  // Since the original list mixed match/not match indexes (0's and 1's) the two grouped lists of indexes list indexes that aren't necessarily contiguous
  // To find list to consider, first find list that has 0 in first position, this is the only list that could possibly match
  list: (); :[grpMatchIdxs[0][0] = 0; list: grpMatchIdxs[0]; list: grpMatchIdxs[1]]    
  // If 0th value of matchIdxs isn't 1 (for ~isNotOp) or 0 (for isNotOp) just return no match and avoid more complex logic that follows
  :[~matchIdxs[list[0]]; :NO_IDX; ]
  // Now loop over list and count how many consecutive indexes it lists and the matchIdxs value at that position, starting from index 1 since we just tested index 0
  j: 1; isMatch: 1
  while[(j < (#list)) & isMatch  
    :[(list[j] = j) & matchIdxs[list[j]]; j +: 1; isMatch: 0]
  ]
  
  :j    
}
// /Handler Helpers

// /Handlers

// Helpers
isOp: {[op] :(+/(op = OPS_HANDLER_MAP[;0])) > 0}

nextOpIdx: { [pattex]
  ops: OP_DELIMS; numOps: #ops
  pattexLen: #pattex
  matchIdx: pattexLen
  j: 0
  while[j < numOps  
    // Find all matching indexes for current operator
    idxs: &({[c] :c = ops[j]}'pattex)
        
    // Scan matching indexes, test for being new operator at lowest index, if yes, reassign matchIdx
    k: 0; break: 0
    while[(k < (#idxs)) & (~break)
      curIdx: idxs[k]
      // If curIdx is less than previous matchIdx, this is the new left-most operator, new next op
      if[~((.utils.isEmptyVector[curIdx]) & ((curIdx = 0) | ((curIdx = 1) & (curIdx < matchIdx)) | ((curIdx > 1) & ((curIdx < matchIdx)))))
        matchIdx: curIdx
        break: 1
      ]
      // Short circuit exit if curIdx is past preivous minimum, because list of indexes is sorted asc
      :[~(curIdx < matchIdx); break: 1; ]
      
      k +: 1
    ]
    
    j +: 1 
  ]
  
  :[matchIdx < pattexLen; :matchIdx; :NO_IDX]
}

getAlternation: { [matchSeq]  
  isAlternation: 0
  retmatchSeqs: ()
  :[(#matchSeq) = 0; :(isAlternation; retmatchSeqs); ]  
  
  if[matchSeq[0] = `"("
    lidx: 0
    ridx: (matchSeq ? `")")
    // Trim parentheses
    matchSeq: matchSeq[1 + (!((#matchSeq) - 2))]
    
    // Find indexes of split operator |, these denote matchSeq elements in the alternation
    // Alternation is a list of matchSeqs
    pipeIdxs: &({[x] :x=`"|"}'matchSeq)
    if[~.utils.isEmptyVector[pipeIdxs]
      isAlternation: 1    
      // Add bounding indexes
      matchSeq: `"|" , matchSeq // , "|"
      pipeIdxs: 0 , (pipeIdxs + 1) , (#matchSeq)
      // Extract pipe-delimited subsequences from alternation, each becomes an element in the alternation
      j: 0
      while[j < ((#pipeIdxs) - 1)
        retmatchSeqs: retmatchSeqs , (, matchSeq[(pipeIdxs[j] + 1) + (!(pipeIdxs[j + 1] - (pipeIdxs[j] + 1)))])
        j +: 1
      ]
    ]
  ]
  
  :(isAlternation; retmatchSeqs)
}

getMatchIdxs: { [matchSeq; seq; isNotOp; n; isAlternation]  
  matchSeqLen: #matchSeq    
  seqLen: #seq  
  :[seqLen < matchSeqLen; :,0; ]
  :[(~(n = NO_IDX)) & (seqLen < n); :,0; ]
  
  // If matchSeq is a single element, then seq can (potentially, depending on operator) match any number of leading consecutive matches
  // Return comparison of single-element matchSeq to all positions in seq
  :[(matchSeqLen = 1) & (~((*matchSeq) = ANY)) & (~(n > 1)); :,((*seq) = (*matchSeq)); ]
  // If the matchSeq is a single ANY, then by definition every position in seq matches it, so return a list of 1's length of seq or of n if n != NO_IDX
  :[(matchSeqLen = 1) & ((*matchSeq) = ANY) & (n = NO_IDX); :1 + &seqLen; ]
  :[(matchSeqLen = 1) & ((*matchSeq) = ANY) & (~(n = NO_IDX)); :1 + &n; ]

  // Otherwise loop over seq and consecutive subranges of length matchSeqLen to matchSeq, we can match any number of these depending on operator
  // If we have an n, only consider seq[!n]
  :[~(n = NO_IDX); seq: seq[!n]; ]
  j: 0; matchIdx: 0
  totMatchIdx: 0
  while[(((j * matchSeqLen)) < seqLen) & (~(matchIdx = NO_IDX))
      curseq: seq[(j * matchSeqLen) + (!matchSeqLen)]
      matchIdx: matchLit[matchSeq; curseq; isNotOp; isAlternation]
        
      if[~(matchIdx = NO_IDX)
        j +: 1
        totMatchIdx +: matchIdx
      ]      
  ]

  // Return list of 1's length of number of matched indexes.  A bit clumsy, but the division of labor between this function
  //  and the handlers is this returns a list of indices and they apply logic to it, including not (where leading ones don't match, that is zero is
  //  meaningful).  So just generate a list of indices here, rather than count of matches, etc.  Also above block for single-count match just
  //  treats seq as list and passes back index list from comparison, so handlers might get mixed list of 1s and 0s from that.  
  :[n = NO_IDX; :[totMatchIdx > 0; :1 + &totMatchIdx; :,0]; ]
  :[~(n = NO_IDX); :[~(n > totMatchIdx); :1 + &n; :,0]; ]  // TODO Should simplify to n = totMatchIdx because we chopped seq to #n above
}

isMatch: {[ret] :1 = ret[0]}
getIncr: {[ret] :ret[1]}
// /Helpers

// Match/Scan
matchH: { [matchSeq; seq; op; isNotOp; n; isAlternation]
  :[~isAlternation; matchSeq: ,matchSeq; ]

  j: 0
  matchIncr: NO_IDX; totIncr: 0
  while[j < (#matchSeq) // & (matchIncr = NO_IDX)  
    // Set handler to call based on whether or not there is an operator
    :[(op = NO_OP) & (~isNotOp); handler: matchLit; ]
    // Handle case of isNotOp and no other op, just a NOT literal/entity match
    :[(op = NO_OP) & isNotOp; handler: matchNot; ]    
    :[~(op = NO_OP); handler: OPS_HANDLER_MAP[*&(op = OPS_HANDLER_MAP[;0])][1]; ]    
    :[~(n = NO_IDX); matchIncr: handler . (matchSeq[j]; totIncr _ seq; isNotOp; n; isAlternation);  matchIncr: handler . (matchSeq[j]; totIncr _ seq; isNotOp; isAlternation)]
        
    if[isAlternation & (~(matchIncr = NO_IDX)) & (~ (((op = `PTXOP_ZERO_ONE) | (op = `PTXOP_ZERO_MORE)) & (matchIncr = 0)) )
      totIncr +: matchIncr
      j: 0
    ]

    :[(~isAlternation) | (isAlternation & (matchIncr = NO_IDX)) | (isAlternation & (((op = `PTXOP_ZERO_ONE) | (op = `PTXOP_ZERO_MORE)) & (matchIncr = 0))); j +: 1; ]
  ]

  :[isAlternation; :totIncr; :matchIncr]
}
// /Match/Scan

// Match - Public Interface
match: { [pattex; seq]

  isMatch: 0; totIncr: 0

  :[(#pattex) = 1; pattex: ,pattex; ]
  :[(#seq) = 1; seq: ,seq; ]
    
  r: 0; rBound: #pattex 
  while[r < rBound    
    n: NO_IDX
    op: NO_OP; isNotOp: 0
    matchSeq: r _ pattex
    
    opIdx: nextOpIdx[r _ pattex]

    // If op found, next call to match is subsequence following last call's subsequence up until this opIdx, increment r
    if[~(opIdx = NO_IDX)
      op: pattex[r + opIdx]
      matchSeq: pattex[r + (!opIdx)]
      r +: (opIdx + 1)
      
      // Handle special case of ^ operator preceding and combining with another operator. In this case pass the NOT as a flag
      //  indicator and pass the following operator as op because the match will occur in that operator's handler
      if[(opIdx < ((#pattex) - 1)) & (op = `PTXOP_NOT)
        tempOpIdx: nextOpIdx[r _ pattex]

        if[tempOpIdx = 0
          op: pattex[r + tempOpIdx]
          r +: 1
          isNotOp: 1
        ]
      ]
    ]
    // If op not found, no more ops to find in this pattex, so this call is last match call, so set r to exit condition
    :[opIdx = NO_IDX; r: rBound; ]
       
    // Test for matchN operator, which is modified by integer arg
    if[op = `PTXOP_MATCH_N
      // Then legal syntax is next symbol is modifier of MATCH_N, number of matches
      n: 0$($pattex[r])  // $ converts symbol to string, 0$ converts string to int
      r +: 1
    ]
    
    // Test for matchSeq being an alternation
    alternationRet: getAlternation[matchSeq]
    isAlternation: alternationRet[0]
    :[isAlternation; matchSeq: alternationRet[1]; ]    
        
    // Match, if no match, return increment 0, false match
    matchIncr: matchH[matchSeq; totIncr _ seq; op; isNotOp; n; isAlternation]

    :[matchIncr = NO_IDX; :(isMatch; 0); totIncr +: matchIncr]
  ]
        
  isMatch: 1
  :(isMatch; totIncr)
}
// /Match

// **** /PattEx **** 