//
//  NakedPair.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class NakedPairs : SolverTechnique {
    let expectedCandidateCount : Int
    init(expectedCandidateCount: Int = 2) {
        self.expectedCandidateCount = expectedCandidateCount
    }
    func isMatch(candidates: [Int], wanted: [Int]) -> Bool {
        return candidates == wanted
    }
    func techniqueName() -> String {
        return "NakedPairs"
    }
    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
        let candidates = board.candidatesAt(x, y)
        if candidates.count != expectedCandidateCount {
            return false
        }
        var pairs : [Int] = [y]
        for row in 0..<9 {
            if row != y {
                let cellCandidates = board.candidatesAt(x, row)
                if isMatch(candidates: cellCandidates, wanted: candidates) {
                    pairs.append(row)
                    if pairs.count == expectedCandidateCount {
                        print("\(techniqueName()) row \(cellCandidates)  at \(x),\(y)")
                        var removed = false
                        for removeRow in 0..<9 {
                            if !pairs.contains(removeRow) {
                                for removeNum in candidates {
                                    if board.candidatesAt(x,removeRow).contains(removeNum) {
                                        print("Removing \(removeNum) from \(x),\(removeRow)")
                                        board.removeCandidate(x: x, y: removeRow, value: removeNum)
                                        removed = true
                                    }
                                }
                            }
                        }
                        if removed {
                            return true
                        }
                    }
                }
            }
        }
        pairs = [x]
        for column in 0..<9 {
            if column != x {
                let cellCandidates = board.candidatesAt(column, y)
                if isMatch(candidates: cellCandidates, wanted: candidates) {
                    pairs.append(column)
                    if pairs.count == expectedCandidateCount {
                        print("\(techniqueName()) column \(cellCandidates)  at \(x),\(y)")
                        var removed = false
                        for removeCol in 0..<9 {
                            if !pairs.contains(removeCol) {
                                for removeNum in candidates {
                                    if board.candidatesAt(removeCol,y).contains(removeNum) {
                                        print("Removing \(removeNum) from \(removeCol),\(y)")
                                        board.removeCandidate(x: removeCol, y: y, value: removeNum)
                                        removed = true
                                    }
                                }
                            }
                        }
                        if removed {
                            return true
                        }
                    }
                }
            }
        }
        
        let square = board.squareOf(x, y)
        let topRow = Int(square/3)*3
        let leftColumn = (square%3)*3
        
        pairs = [y*9+x]
        for row in 0..<3 {
            for column in 0..<3 {
                if (leftColumn+column) != x || (topRow+row) != y {
                    let cellCandidates = board.candidatesAt(leftColumn+column, topRow+row)
                    if isMatch(candidates: cellCandidates, wanted: candidates) {
                        pairs.append((topRow+row)*9+(leftColumn+column))
                        if pairs.count == expectedCandidateCount {
                            print("\(techniqueName()) square \(cellCandidates)  at \(x),\(y)")
                            var removed = false
                            for removeRow in 0..<3 {
                                for removeCol in 0..<3 {
                                    if !pairs.contains((topRow+removeRow)*9+(leftColumn+removeCol)) {
                                        for removeNum in candidates {
                                            if board.candidatesAt((leftColumn+removeCol),(topRow+removeRow)).contains(removeNum) {
                                                print("Removing \(removeNum) from \((leftColumn+removeCol)),\((topRow+removeRow))")
                                                board.removeCandidate(x: (leftColumn+removeCol), y: (topRow+removeRow), value: removeNum)
                                                removed = true
                                            }
                                        }
                                    }
                                }
                            }
                            if removed {
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
}
