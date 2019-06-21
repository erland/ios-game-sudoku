//
//  SingleCandidate.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class SingleCandidate : SolverTechnique {
    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
        let candidates = board.candidatesAt(x, y)
        if candidates.count == 1 {
            print("SingleCandidate \(candidates[0]) at \(x),\(y)")
            board.setValue(x: x, y: y, value: candidates[0], present: true)
            return true
        }
        return false
    }
}

