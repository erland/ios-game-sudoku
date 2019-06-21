//
//  NakedQuad.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class NakedQuads : NakedPairs {
    init() {
        super.init(expectedCandidateCount: 4)
    }
    override func techniqueName() -> String {
        return "NakedQuads"
    }
    
    override func isMatch(candidates: [Int], wanted: [Int]) -> Bool {
        if candidates.count>=2 && candidates.count<=4 {
            for c in candidates {
                if !wanted.contains(c) {
                    return false
                }
            }
            return true
        }
        return false
    }
}
