// ************** 
// File: regex2.k
// Descr: Simple regular expression library
// **************

\d .regex
\l utils

// **** RegEx ****
// Supported Syntax/Operators:
// abc             - match one or more literal characters, exactly
// abc*            - match preceding sequence of literal characters zero or more times
// abc+            - match preceding sequence of literal characters one or more times
// abc$            - match preceding sequence of literal characters zero or one time
// abc^            - do not match preceding sequence of literal characters
// abc#{n}         - match preceding sequence of literal characters exactly n times, where n is an integer
// (abc|ABC)       - match any of the sequences of literal characters in the alternation
// (abc|ABC)*      - match any of the sequences of literal characters in the alternation zero or more times
// (abc|ABC)+      - match any of the sequences of literal characters in the alternation one or more times
// (abc|ABC)$      - match any of the sequences of literal characters in the alternation zero or one time
// (abc|ABC)^      - do not match any of the sequences of literal characters in the alternation
// (abc|ABC)#{n}   - match any of the sequences of literal characters in the alternation exactly n times, where n is an integer
//
// ^ can be standalone in which case the match is the negation of a successful literal or entity match
// ^ can combine with an immediately following operator, in which csae the match is the negation of the match sequence within the context
//    of the handler for the following operator
//    e.g.  abc^+  means match anything other than the sequence 'abc' one or more times
//     so for example this would match and return increment of 6:  abebbc
//
// Operator chars as literals are esaped with leading slashes, e.g. "\\++" matches one or more + characters
//
// Entities: match string may be any of the supported entities listed in ENTITIES
//
// Expressions must follow this format: MATCH_STR [OP[{N}]]
//  where bracketed elements are optional ... or ...
// Expressions must follow this format, with alternation supported: (MATCH_STR_1|MATCH_STR_1...)[OP[{N}]]
// Expressions may be chained: e.g. - LITERAL_SEQUENCE[OP](ENTITY1|ENTITY2)[OP{5}]
//
//  e.g. - Floats are defined this way: (\\+|-)$\\d*.\\d+                       // zero or more digits, one dot, one or more digits
//                                      (\\+|-)$\\d*.\\d+e#{1}(\\+|-)$\\d+      // zero or more digits, one dot, one or more digits, one e, zero or more either + or -, one or more digits

// Constants
NO_IDX: -1
NO_OP: " "
ENTITY_CHARS: "dcCwavrsplX"
OP_DELIMS: "*+^$#"
// Constants

// Entities
DIGIT: "0123456789"
LC_ALPHA: "abcdefghijklmnopqrstuvwxyz"
UC_ALPHA: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
ALPHA: LC_ALPHA,UC_ALPHA
ALPHA_NUM: ALPHA,DIGIT
VERB: "~!@#$%^&*-+=|<>,"
ADVERB: "\\'"
SPACE: ," "
WHITESPACE: " \t"
DELIM: "; \t\n:"
ANY: ,""

ENTITIES: (("\\d";DIGIT);("\\c";LC_ALPHA);("\\C";UC_ALPHA);("\\w";ALPHA);("\\a";ALPHA_NUM);("\\v";VERB);("\\r";ADVERB);("\\p";SPACE);("\\s";WHITESPACE);("\\l";DELIM);("\\X";ANY))
// Entities

// Handlers
// All handlers return number of consecutive characters matched from start of str, NO_IDX on failure to match

matchLit: { [matchStr; str; isNotOp; isAlternation]
  matchStrLen: getMatchStrLen[matchStr; isAlternation] 
  
  // TEMP DEBUG
  .utils.dbgPrint[str; "str"; "IN matchLit[]"; 0]        
  .utils.dbgPrint[matchStr; "matchStr"; "IN matchLit[]"; 0]        
  .utils.dbgPrint[matchStrLen; "matchStrLen"; "IN matchLit[]"; 0]        
  .utils.dbgPrint[#str; "#str"; "IN matchLit[]"; 0]        
  // /TEMP DEBUG
       
  // If matchStr after whitespace check < the desired matchStr length, no match
  :[(#str) < matchStrLen; :NO_IDX; ]
  
  matchIdx: 0; j: 0; k: 0
  while[((~(matchIdx = NO_IDX)) & (j < (#matchStr)) & (k < matchStrLen)) 
    isEntity: isEntityOpeningChar[matchStr; j]    
    isOpEscape: isOpEscapeChar[matchStr; j]
    isSlashEscape: isSlashEscapeChar[matchStr; j]

    // TEMP DEBUG
    .utils.dbgPrint[isEntity; "isEntity"; "IN matchLit[] LOOP"; 0]        
    .utils.dbgPrint[isOpEscape; "isOpEscape"; "IN matchLit[] LOOP"; 0]        
    .utils.dbgPrint[isSlashEscape; "isSlashEscape"; "IN matchLit[] LOOP"; 0]        
    .utils.dbgPrint[matchStr[j]; "matchStr[j]"; "IN matchLit[] LOOP"; 0]        
    // /TEMP DEBUG
    
    // If the next character is a \\ that is not an entity opener but is an escape char, cut it
    :[(~isEntity) & (isOpEscape | isSlashEscape); matchStr: matchStr _di 0; ] 
    
    // TEMP DEBUG
    .utils.dbgPrint[matchStr[j]; "matchStr[j]"; "IN matchLit[] LOOP AFTER (~isEntity) & (isOpEscape | isSlashEscape)"; 0]        
    .utils.dbgPrint[str[k]; "str[k]"; "IN matchLit[] LOOP AFTER (~isEntity) & (isOpEscape | isSlashEscape)"; 0]        
    // TEMP DEBUG    
     
    :[~isEntity; :[matchStr[j] = str[k]; j +: 1; matchIdx: NO_IDX]; ]
    
    if[isEntity
      entityMatchStr: getEntity[matchStr[j + (!2)]]
      isAnyMatch: .utils.extEquals[entityMatchStr; ANY]

      // TEMP DEBUG
      .utils.dbgPrint[isAnyMatch; "isAnyMatch"; "IN matchLit[]"; 0]        
      // /TEMP DEBUG

      // Handle special case ANY entity, matches any character in str
      :[isAnyMatch; j +: 2; ]      
      :[(~isAnyMatch) & (~((entityMatchStr ? (str[k])) < (#entityMatchStr))); matchIdx: NO_IDX; j +: 2]    
    ]
      
    k +: 1        
  ]
  
  :[(k = matchStrLen) & (~(matchIdx = NO_IDX)); :matchStrLen; :NO_IDX]
}

matchOneOrMore: { [matchStr; str; isNotOp; isAlternation]
  :[(#str[0]) = 0; :NO_IDX; ]

  matchIdxs: getMatchIdxs[matchStr; str; isNotOp; NO_IDX; isAlternation]   
  
  // TEMP DEBUG
  .utils.dbgPrint[matchIdxs; "matchIdxs"; "IN matchOneOrMore[]"; 0]        
  // /TEMP DEBUG
   
  :[(+/matchIdxs) = 0; :NO_IDX; ]  
  // Else use Group technique to find number of leading consecutively matched characters
  grpMatchIdxs: =matchIdxs  
  
  // TEMP DEBUG
  .utils.dbgPrint[grpMatchIdxs; "grpMatchIdxs"; "IN matchOneOrMore[]"; 0]        
  // /TEMP DEBUG
    
  // Handle all zero or all one case, if all zero return no match, if all 1 return length of list
  :[(#grpMatchIdxs) = 1; :[matchIdxs[grpMatchIdxs[0][0]] = 1; :#(grpMatchIdxs[0]); :NO_IDX]; ]
  // Handle mixed zero and one case, return number of leading consecutive 1's
  if[(#grpMatchIdxs) = 2
    leadingMatchIndexCount: getLeadingMatchIdxCount[matchIdxs; grpMatchIdxs; #matchIdxs]
    
    // TEMP DEBUG
    .utils.dbgPrint[leadingMatchIndexCount; "leadingMatchIndexCount"; "IN matchOneOrMore[]"; 0]        
    // /TEMP DEBUG
      
    :[leadingMatchIndexCount > 0; :leadingMatchIndexCount; :NO_IDX]
  ]
}

matchZeroOrMore: { [matchStr; str; isNotOp; isAlternation] 
  :[(#str[0]) = 0; :0; ]
  
  matchIdxs: getMatchIdxs[matchStr; str; isNotOp; NO_IDX; isAlternation]  

  // If isNotOp then invert the values of the matchIdxs
  :[isNotOp; matchIdxs: ~matchIdxs; ]
 
  // TEMP DEBUG
  .utils.dbgPrint[matchIdxs; "matchIdxs"; "IN matchZeroOrMore[]"; 0]        
  // /TEMP DEBUG
          
  // Else use Group technique to find number of leading consecutively matched characters  
  grpMatchIdxs: =matchIdxs
  :[(#grpMatchIdxs) = 1; :[matchIdxs[grpMatchIdxs[0][0]] = 1; :#(grpMatchIdxs[0]); :0]; ]
  if[(#grpMatchIdxs) = 2
    leadingMatchIdxCount: getLeadingMatchIdxCount[matchIdxs; grpMatchIdxs; #matchIdxs]
    :[leadingMatchIdxCount = NO_IDX; leadingMatchIdxCount: 0; ]
    :leadingMatchIdxCount
  ]
}

matchZeroOrOne: { [matchStr; str; isNotOp; isAlternation] 
  :[(#str[0]) = 0; :0; ]  

  matchIdxs: getMatchIdxs[matchStr; str; isNotOp; NO_IDX; isAlternation] 
  // If isNotOp then invert the values of the matchIdxs
  :[isNotOp; matchIdxs: ~matchIdxs]

  // TEMP DEBUG
  .utils.dbgPrint[matchIdxs; "matchIdxs"; "IN matchZeroOrOne[]"; 0]        
  // /TEMP DEBUG  
  
  // Match zero case, report increment of zero but that is valid
  :[(+/matchIdxs) = 0; :0; ]
  // Match one case, report 1
  :[(*matchIdxs) = 1; :1; :NO_IDX] 
}

matchN: { [matchStr; str; isNotOp; n; isAlternation] 
  // TEMP DEBUG
  // .utils.dbgPrint[#str[0]; "#str[0]"; "IN matchN[]"; 1]        
  // TEMP DEBUG

  :[(#str[0]) = 0; :[n = 0; :0; :NO_IDX]; ]
  
  matchIdxs: getMatchIdxs[matchStr; str; isNotOp; n; isAlternation]
  // If isNotOp then invert the values of the matchIdxs
  :[isNotOp; matchIdxs: ~matchIdxs; ]    
  
  // TEMP DEBUG
  .utils.dbgPrint[matchStr; "matchStr"; "IN matchN[]"; 0]        
  .utils.dbgPrint[str; "str"; "IN matchN[]"; 0]        
  .utils.dbgPrint[matchIdxs; "matchIdxs"; "IN matchN[]"; 0]        
  .utils.dbgPrint[n; "n"; "IN matchN[]"; 0]        
  // TEMP DEBUG
    
  :[(+/matchIdxs) = 0; :[n = 0; :0; :NO_IDX]; ]
  
  grpMatchIdxs: =matchIdxs  

  // TEMP DEBUG
  .utils.dbgPrint[grpMatchIdxs; "grpMatchIdxs"; "IN matchN[]"; 0]        
  .utils.dbgPrint[#grpMatchIdxs; "#grpMatchIdxs"; "IN matchN[]"; 0]        
  .utils.dbgPrint[#grpMatchIdxs[0]; "#grpMatchIdxs[0]"; "IN matchN[]"; 0]    
  .utils.dbgPrint[getLeadingMatchIdxCount[matchIdxs; grpMatchIdxs; n]; "getLeadingMatchIdxCount[matchIdxs; grpMatchIdxs; n]"; "IN matchN[]"; 0]        
  // TEMP DEBUG
  
  :[(#grpMatchIdxs) = 1; :[matchIdxs[grpMatchIdxs[0][0]] = 1; :[(#grpMatchIdxs[0]) = n; :n; :NO_IDX]; ] ; ]
  :[(#grpMatchIdxs) = 2; :[getLeadingMatchIdxCount[matchIdxs; grpMatchIdxs; n] = n; :n; :NO_IDX]; ]
}

matchNot: { [matchStr; str; isNotOp; isAlternation] 
  // Special case for NOT, an empty string always matches the NOT of any matchStr, but advances 0 characters
  :[(#str[0]) = 0; :0; ]
  // Otherwise, if lit doesn't match, advance by the length of matchStr, if lit matches, then NOT is a fail
  :[matchLit[matchStr; str; isNotOp; isAlternation] = NO_IDX; :getMatchStrLen[matchStr; isAlternation]; :NO_IDX]
}

// Ops/Handler Map
OPS_HANDLER_MAP: (("*";matchZeroOrMore);("+";matchOneOrMore);("^";matchNot);("$";matchZeroOrOne);("#";matchN))
// /Ops/Handler Map

// Handler Helpers
getLeadingMatchIdxCount: { [matchIdxs; grpMatchIdxs; n]
  // Depending on whether isNotOp or not, find which list is indexes of matches or not matches
  // Since the original list mixed match/not match indexes (0's and 1's) the two grouped lists of indexes list indexes that aren't necessarily contiguous
  // The number of characters matched/not matched is the number of adjacent indexes (starting from 0) that the list has
  // e.g. 0 2 3     matches one character
  //      0 1 2 3   matches four characters
  // To find list to consider, first find list that has 0 in first position, this is the only list that could possibly match
  list: (); :[grpMatchIdxs[0][0] = 0; list: grpMatchIdxs[0]; list: grpMatchIdxs[1]]    
  // If 0th value of matchIdxs isn't 1 (for ~isNotOp) or 0 (for isNotOp) just return no match and avoid more complex logic that follows
  :[~matchIdxs[list[0]]; :NO_IDX; ]
  // Now loop over list and count how many consecutive indexes it lists and the matchIdxs value at that position, starting from index 1 since we just tested index 0
  j: 1; isMatch: 1
  while[(j < (#list)) & isMatch
    
    // TEMP DEBUG
    .utils.dbgPrint[matchIdxs[list[j]]; "matchIdxs[list[j]]"; "IN getLeadingMatchIdxCount[]"; 0]          
    // /TEMP DEBUG
  
    :[(list[j] = j) & matchIdxs[list[j]]; j +: 1; isMatch: 0]
  ]
  
  :j    
}
// /Handler Helpers

// /Handlers

// Helpers
isWS: {[c] :((WHITESPACE ? c) < (#WHITESPACE))}
stripStrWS: {[str]  :str[&~isWS'str]}
isOp: {[op] :(+/(op = OPS_HANDLER_MAP[;0])) > 0}

isEntityOpeningChar: { [str; idx]
  :[(~((#str) > 1)) | (~(idx < ((#str) - 1))); :0; ]
  // Boundary case
  :(str[idx] = "\\") & ((ENTITY_CHARS ? str[(idx + 1)]) < (#ENTITY_CHARS))
}

getEntity: { [matchStr]
  keys: ENTITIES[;0][;1]
  matchKey: matchStr[1]
  :ENTITIES[*&(matchKey = keys)][1]
}

isOpEscapeChar: { [str; idx]
  :[(~((#str) > 1)) | (~(idx < ((#str) - 1))); :0; ]
  // Boundary case
  :(str[idx] = "\\") & (("*+^$#" ? str[(idx + 1)]) < (#"*+^$#"))  
}

isSlashEscapeChar: { [str; idx]
  :[(~((#str) > 1)) | (~(idx < ((#str) - 1))); :0; ]
  // Boundary case
  :((str[idx] = "\\") & (str[(idx + 1)] = "\\"))  
}

// Actual length in number of entities to match, not characters. So literal character = 1, and entity (two actual characters) = 1
getMatchStrLen: { [matchStr; isAlternation]
  len: 0
  j: 0 
  while[j < (#matchStr)    

    // TEMP DEBUG
    .utils.dbgPrint[matchStr[j]; "matchStr[j]"; "IN getMatchStrLen[]"; 0]        
    .utils.dbgPrint[isEntityOpeningChar[matchStr; j]; "isEntity"; "IN getMatchStrLen[]"; 0]        
    .utils.dbgPrint[isOpEscapeChar[matchStr; j]; "isOpEscape"; "IN getMatchStrLen[]"; 0]        
    .utils.dbgPrint[isSlashEscapeChar[matchStr; j]; "isSlashEscape"; "IN getMatchStrLen[]"; 0]        
    // /TEMP DEBUG
     
    :[isEntityOpeningChar[matchStr; j] | isOpEscapeChar[matchStr; j] | isSlashEscapeChar[matchStr; j]; j +: 2; j +: 1]   
    len +: 1
  ]

  :len
}

nextOpIdx: { [regex]
  ops: OP_DELIMS; numOps: #ops
  matchIdx: #regex
  j: 0
  while[j < numOps  
    // Find all matching indexes for current operator
    idxs: &({[c] :c = ops[j]}'regex)

    // TEMP DEBUG
    .utils.dbgPrint[idxs; "idxs"; "IN nextOpIdx[]"; 0]        
    // TEMP DEBUG
    
    // Scan matching indexes, first one that isn't escaped, test for being new operator at lowest index, if yes, reassign matchIdx
    k: 0; break: 0
    while[(k < (#idxs)) & (~break)
      curIdx: idxs[k]
      // If curIdx is less than previous matchIdx, and not escaped, this is the new left-most operator, new next op
      if[~(.utils.isEmptyVector[curIdx])
        if[curIdx = 0
          matchIdx: curIdx
          break: 1          
        ]        
        if[curIdx = 1
          if[(curIdx < matchIdx) & (~(regex[(curIdx - 1)] = "\\"))
              matchIdx: curIdx
              break: 1
          ]
        ]
        if[curIdx > 1
          if[((curIdx < matchIdx) & (~((regex[(curIdx - 1)] = "\\") & (~(regex[(curIdx - 2)] = "\\")))) )
              matchIdx: curIdx
              break: 1
          ]
        ]
      ]
      // Short circuit exit if curIdx is past preivous minimum, because list of indexes is sorted asc
      :[~(curIdx < matchIdx); break: 1; ]
      
      k +: 1
    ]
    
    j +: 1 
  ]
  
  :[matchIdx < (#regex); :matchIdx; :NO_IDX]
}

getAlternation: { [matchStr]  
  isAlternation: 0
  retMatchStrs: ()
  :[(#matchStr) = 0; :(isAlternation; retMatchStrs); ]  
  
  if[matchStr[0] = "("
    lidx: 0
    ridx: (matchStr ? ")")
    // Trim parentheses
    matchStr: matchStr[1 + (!((#matchStr) - 2))]
    
    // Find indexes of split operator |, these denote matchStr elements in the alternation
    // Alternation is a list of matchStrs
    pipeIdxs: &({[x] :x="|"}'matchStr)
    if[~.utils.isEmptyVector[pipeIdxs]
      isAlternation: 1    
      // Add bounding indexes
      matchStr: "|" , matchStr // , "|"
      pipeIdxs: 0 , (pipeIdxs + 1) , (#matchStr)
      // Extract pipe-delimited substrings from alternation, each becomes an element in the alternation
      j: 0
      while[j < ((#pipeIdxs) - 1)
        retMatchStrs: retMatchStrs , (, matchStr[(pipeIdxs[j] + 1) + (!(pipeIdxs[j + 1] - (pipeIdxs[j] + 1)))])
        j +: 1
      ]
    ]
  ]
  
  :(isAlternation; retMatchStrs)
}

getMatchIdxs: { [matchStr; str; isNotOp; n; isAlternation]  
  matchStrLen: getMatchStrLen[matchStr; isAlternation]      
  strLen: #str  
  :[strLen < matchStrLen; :,0; ]
  :[(~(n = NO_IDX)) & (strLen < n); :,0; ]
  :[~(n = NO_IDX); retLen: n; retLen: strLen]
  
  // If matchStr is a single character, then str can (potentially, depending on operator) match any number of leading consecutive character matches
  if[matchStrLen = 1  
    isEntity: isEntityOpeningChar[matchStr; 0] 
    isOpEscape: isOpEscapeChar[matchStr; 0]
    isSlashEscape: isSlashEscapeChar[matchStr; 0]
    
    // If first character is not an entity opener but is an escape, cut it because it will only be
    //  in matchStr as an escape char, not in str as something to match on
    // e.g. \\++    matchStr, mathch one or more '+' character
    //      +++     str, this is a valid match, no '\\'
    :[(~isEntity) & (isOpEscape | isSlashEscape); matchStr: matchStr _di 0; ]
               
    // If literal match, return comparison of single-char matchStr to all positions in str
    :[~isEntity; :str = (*matchStr); ]
    // If entity match, pass str char by char to compare to find on entity list and return list of matches for all positions in str
    if[isEntity
      curMatchStr: getEntity[matchStr]
      // Handle special case ANY entity, matches any character in str
      isAnyMatch: .utils.extEquals[curMatchStr; ANY]
      :[isAnyMatch; :1 + &retLen; ]
      :[~isAnyMatch; :{[x] :((curMatchStr ? x) < (#curMatchStr))}'str; ]
    ]
  ]
  
  // Otherwise loop over str and consecutive subranges of length matchStrLen to matchStr, we can match any number of these depending on operator
  // TODO - This is potentially N suboptimal if n != NO_IDX, in which case we should only consider seq[!n] characters of seq. Instead we greedily match what we can here
  //  including all the way to end of whatever, then check below if that number of matches >= n. Duh.
  j: 0; matchIdx: 0
  totMatchIdx: 0
  while[(((j * (matchStrLen + 1))) < strLen) & (~(matchIdx = NO_IDX)) 
    curStr: str[(j * matchStrLen) + (!matchStrLen)]

    // TEMP DEBUG
    .utils.dbgPrint[matchLit[matchStr; curStr; isNotOp; isAlternation]; "matchLit[matchStr; curStr; isNotOp; isAlternation]"; "IN getMatchIdxs[] MATCH LOOP"; 0]        
    .utils.dbgPrint[matchStr; "matchStr"; "IN getMatchIdxs[] MATCH LOOP"; 0]        
    .utils.dbgPrint[curStr; "curStr"; "IN getMatchIdxs[] MATCH LOOP"; 0]        
    .utils.dbgPrint[isNotOp; "isNotOp"; "IN getMatchIdxs[] MATCH LOOP"; 0]        
    .utils.dbgPrint[isAlternation; "isAlternation"; "IN getMatchIdxs[] MATCH LOOP"; 0]        
    // /TEMP DEBUG
    
    matchIdx: matchLit[matchStr; curStr; isNotOp; isAlternation]
    if[~(matchIdx = NO_IDX)
      j +: 1
      totMatchIdx +: matchIdx
    ]
  ]
  
  // Return list of 1's length of number of substrings matched * length of substring.  A bit clumsy, but the division of labor between this function
  //  and the handlers is this returns a list of indices and they apply logic to it, including not (where leading ones don't match, that is zero is
  //  meaningful).  So just generate a list of indices here, rather than count of matches, etc.  Also above block for single-count match just
  //  treats str as list and passes back index list from comparison, so handlers might get mixed list of 1s and 0s from that.
  :[n = NO_IDX; :[totMatchIdx > 0; :1 + &totMatchIdx; :,0]; ]
  
  // TEMP DEBUG
  .utils.dbgPrint[idxs; "HERE"; "IN getMatchIdxs[]"; 0]        
  .utils.dbgPrint[totMatchIdx; "totMatchIdx"; "IN getMatchIdxs[]"; 0]        
  // /TEMP DEBUG
        
  :[~(n = NO_IDX); :[~(n > totMatchIdx); :1 + &n; :,0]; ]
}

isMatch: {[ret] :1 = ret[0]}
getIncr: {[ret] :ret[1]}
// /Helpers

// Match/Scan
matchH: { [matchStr; str; op; isNotOp; n; isAlternation]
  :[~isAlternation; matchStr: ,matchStr; ]

  // TEMP DEBUG
  .utils.dbgPrint[matchStr; "matchStr"; "IN matchH[]"; 0]        
  .utils.dbgPrint[str; "str"; "IN matchH[]"; 0]        
  // /TEMP DEBUG

  j: 0
  matchIncr: NO_IDX; totIncr: 0
  while[j < (#matchStr) // & (matchIncr = NO_IDX)  
    // Set handler to call based on whether or not there is an operator
    :[(op = NO_OP) & (~isNotOp); handler: matchLit; ]
    // Handle case of isNotOp and no other op, just a NOT literal/entity match
    :[(op = NO_OP) & isNotOp; handler: matchNot; ]    
    :[~(op = NO_OP); handler: OPS_HANDLER_MAP[*&(op = OPS_HANDLER_MAP[;0])][1]; ]

    // TEMP DEBUG
    .utils.dbgPrint[totIncr _ str; "totIncr _ str"; "IN matchH[]"; 0]        
    .utils.dbgPrint[n; "n"; "IN matchH[]"; 0]        
    .utils.dbgPrint[matchIncr; "matchIncr"; "IN matchH[] INCR CONDITION"; 0]        
    .utils.dbgPrint[op; "op"; "IN matchH[] INCR CONDITION"; 0]        
    .utils.dbgPrint[handler; "handler"; "IN matchH[] INCR CONDITION"; 0]        
    .utils.dbgPrint[OPS_HANDLER_MAP[*&(op = OPS_HANDLER_MAP[;0])]; "OPS_HANDLER_MAP[*&(op = OPS_HANDLER_MAP[;0])]"; "IN matchH[] INCR CONDITION"; 0]        
    // /TEMP DEBUG    
    
    :[~(n = NO_IDX); matchIncr: handler . (matchStr[j]; totIncr _ str; isNotOp; n; isAlternation);  matchIncr: handler . (matchStr[j]; totIncr _ str; isNotOp; isAlternation)]
    
    // TEMP DEBUG
    .utils.dbgPrint[isAlternation; "isAlternation"; "j: 0 CONDITION"; 0]        
    .utils.dbgPrint[(~(matchIncr = NO_IDX)); "(~(matchIncr = NO_IDX))"; "j: 0 CONDITION"; 0]        
    .utils.dbgPrint[(~((op = "$") & (matchIncr = 0))); "(~((op = \"$\") & (matchIncr = 0)))"; "j: 0 CONDITION"; 0]        
    // /TEMP DEBUG
    
    if[isAlternation & (~(matchIncr = NO_IDX)) & (~(((op = "$") | (op = "*")) & (matchIncr = 0)))
      totIncr +: matchIncr
      j: 0
    ]

    // TEMP DEBUG
    .utils.dbgPrint[~isAlternation; "~isAlternation"; "j +: 1 CONDITION"; 0]        
    .utils.dbgPrint[(isAlternation & (matchIncr = NO_IDX)); "(isAlternation & (matchIncr = NO_IDX))"; "j +: 1 CONDITION"; 0]        
    .utils.dbgPrint[(isAlternation & ((op = "$") & (matchIncr = 0))); "(isAlternation & ((op = \"$\") & (matchIncr = 0)))"; "j +: 1 CONDITION"; 0]        
    // /TEMP DEBUG

    :[(~isAlternation) | (isAlternation & (matchIncr = NO_IDX)) | (isAlternation & (((op = "$") | (op = "*")) & (matchIncr = 0))); j +: 1; ]

    // TEMP DEBUG
    .utils.dbgPrint[matchIncr; "matchIncr"; "IN matchH[]"; 0]        
    .utils.dbgPrint[totIncr; "totIncr"; "IN matchH[]"; 0]        
    .utils.dbgPrint[j; "j"; "IN matchH[]"; 0]        
    // /TEMP DEBUG
  ]

  :[isAlternation; :totIncr; :matchIncr]
}
// /Match/Scan

// Match - Public Interface
match: { [regex; str; isSkipWS]
  isMatch: 0; totIncr: 0

  :[.utils.isChar[regex]; regex: ,regex; ]
  :[.utils.isChar[str]; str: ,str; ]
  :[isSkipWS; str: stripStrWS[str]; ]
    
  r: 0; rBound: #regex 
  while[r < rBound    
    n: NO_IDX
    op: NO_OP; isNotOp: 0
    matchStr: r _ regex

    // TEMP DEBUG
    .utils.dbgPrint[matchStr; "matchStr"; ""; 0]        
    .utils.dbgPrint[r _ regex; "r _ regex"; ""; 0]        
    .utils.dbgPrint[str; "str"; ""; 0]        
    // /TEMP DEBUG
    
    opIdx: nextOpIdx[r _ regex]
    
    // TEMP DEBUG
    .utils.dbgPrint[opIdx; "opIdx"; ""; 0]        
    // /TEMP DEBUG    
    
    // If op found, next call to match is substring following last call's substring up until this opIdx, increment r
    if[~(opIdx = NO_IDX)
      op: regex[r + opIdx]
      matchStr: regex[r + (!opIdx)]
      r +: (opIdx + 1)
      
      // Handle special case of ^ operator preceding and combining with another operator. In this case pass the NOT as a flag
      //  indicator and pass the following operator as op because the match will occur in that operator's handler
      if[(opIdx < ((#regex) - 1)) & (op = "^")
        tempOpIdx: nextOpIdx[r _ regex]

        // TEMP DEBUG
        .utils.dbgPrint[r _ regex; "r _ regex"; ""; 0]        
        .utils.dbgPrint[tempOpIdx; "tempOpIdx"; ""; 0]        
        .utils.dbgPrint[regex[r + tempOpIdx]; "op"; "NEW OP"; 0]        
        // TEMP DEBUG

        if[tempOpIdx = 0
          op: regex[r + tempOpIdx]
          r +: 1
          isNotOp: 1
        ]
      ]
    ]
    // If op not found, no more ops to find in this regex, so this call is last match call, so set r to exit condition
    :[opIdx = NO_IDX; r: rBound; ]
       
    // Test for matchN operator, which is modified by integer arg
    if[op = "#"
      // Then legal syntax is next characters are modifiers of #, which is matchN, e.g. \w#(3)
      lidx: r + 1
      ridx: lidx + ((lidx _ regex) ? "}")      
      n: 0$regex[lidx + (!(ridx - lidx))]
      r +: (ridx - r) + 1
    ]
    
    // Test for matchStr being an alternation
    alternationRet: getAlternation[matchStr]
    isAlternation: alternationRet[0]
    :[isAlternation; matchStr: alternationRet[1]; ]    
        
    // TEMP DEBUG
    .utils.dbgPrint[r; "r"; ""; 0]    
    .utils.dbgPrint[totIncr _ str; "totIncr _ str"; ""; 0]
    .utils.dbgPrint[matchStr; "matchStr"; "BEFORE CALL"; 0]
    .utils.dbgPrint[op; "op"; ""; 0]
    .utils.dbgPrint[n; "n"; ""; 0]
    .utils.dbgPrint[isAlternation; "isAlternation"; ""; 0]
    // /TEMP DEBUG
    
    // Match, if no match, return increment 0, false match
    matchIncr: matchH[matchStr; totIncr _ str; op; isNotOp; n; isAlternation]

    // TEMP DEBUG
    .utils.dbgPrint[matchIncr; "matchIncr"; "AFTER CALL"; 0]
    .utils.dbgPrint[r; "r"; "AFTER CALL"; 0]
    .utils.dbgPrint[rBound; "rBound"; "AFTER CALL"; 0]
    .utils.dbgPrint[r < rBound; "r < rBound"; "AFTER CALL"; 0]
    // TEMP DEBUG

    :[matchIncr = NO_IDX; :(isMatch; 0); totIncr +: matchIncr]
  ]
  
  
  // TEMP DEBUG
  .utils.dbgPrint[totIncr; "totIncr"; "RETURN"; 0]
  // TEMP DEBUG
      
  isMatch: 1
  :(isMatch; totIncr)
}
// /Match

// **** /RegEx **** 