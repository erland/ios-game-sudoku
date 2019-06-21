//
//  NakedTriples.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class NakedTriples : NakedPairs {
    init() {
        super.init(expectedCandidateCount: 3)
    }
    override func techniqueName() -> String {
        return "NakedTriples"
    }
    
    override func isMatch(candidates: [Int], wanted: [Int]) -> Bool {
        if candidates.count>=2 && candidates.count<=3 {
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

