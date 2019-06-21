//
//  HiddenTriples.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class HiddenTriples : SolverTechnique {
    let expectedCandidateCount : Int
    init(expectedCandidateCount: Int = 3) {
        self.expectedCandidateCount = expectedCandidateCount
    }
    
    func rowOccurrences(board: BoardHandler, y: Int, num: Int) -> [Int] {
        var result : [Int] = []
        for col in 0..<9 {
            if board.candidatesAt(col, y).contains(num) {
                result.append(col)
            }
        }
        return result
    }
    
    func columnOccurrences(board: BoardHandler, x: Int, num: Int) -> [Int] {
        var result : [Int] = []
        for row in 0..<9 {
            if board.candidatesAt(x, row).contains(num) {
                result.append(row)
            }
        }
        return result
    }
    
    func squareOccurrences(board: BoardHandler, x: Int, y: Int, num: Int) -> [Int] {
        var result : [Int] = []
        let square = board.squareOf(x, y)
        let topRow = Int(square/3)*3
        let leftColumn = (square%3)*3
        for row in 0..<3 {
            for col in 0..<3 {
                if board.candidatesAt(leftColumn+col, topRow+row).contains(num) {
                    result.append((topRow+row)*9+leftColumn+col)
                }
            }
        }
        return result
    }
    
    
    func techniqueName() -> String {
        return "HiddenTriples"
    }
    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
        let candidates = board.candidatesAt(x, y)
        
        var potentialsPos : [[Int]] = [[],[],[],[],[],[],[],[],[]]
        var potentials : [Int] = []
        for c in candidates {
            let occurrences = rowOccurrences(board: board, y:y, num: c)
            if occurrences.count>1 && occurrences.count <= expectedCandidateCount {
                potentialsPos[c-1] = occurrences
                potentials.append(c)
            }
        }
        
        for p1 in potentials {
            for p2 in potentials {
                if p1 != p2 {
                    for p3 in potentials {
                        if p2 != p3 && p1 != p3 {
                            var combined : Set<Int> = []
                            for p in potentialsPos[p1-1] {
                                combined.insert(p)
                            }
                            for p in potentialsPos[p2-1] {
                                combined.insert(p)
                            }
                            for p in potentialsPos[p3-1] {
                                combined.insert(p)
                            }
                            if combined.count == expectedCandidateCount {
                                print("\(techniqueName()) row \([p1,p2,p3])  at \(x),\(y)")
                                var removed = false
                                for pos in combined {
                                    for c in board.candidatesAt(pos, y) {
                                        if (c != p1) && (c != p2) && (c != p3) {
                                            print("Removing \(c) from \(pos),\(y)")
                                            board.removeCandidate(x: pos, y: y, value: c)
                                            removed = true
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
        }
        
        potentialsPos = [[],[],[],[],[],[],[],[],[]]
        potentials = []
        for c in candidates {
            let occurrences = columnOccurrences(board: board, x:x, num: c)
            if occurrences.count>1 && occurrences.count <= expectedCandidateCount {
                potentialsPos[c-1] = occurrences
                potentials.append(c)
            }
        }
        
        for p1 in potentials {
            for p2 in potentials {
                if p1 != p2 {
                    for p3 in potentials {
                        if p2 != p3 && p1 != p3 {
                            var combined : Set<Int> = []
                            for p in potentialsPos[p1-1] {
                                combined.insert(p)
                            }
                            for p in potentialsPos[p2-1] {
                                combined.insert(p)
                            }
                            for p in potentialsPos[p3-1] {
                                combined.insert(p)
                            }
                            if combined.count == expectedCandidateCount {
                                print("\(techniqueName()) column \([p1,p2,p3])  at \(x),\(y)")
                                var removed = false
                                for pos in combined {
                                    for c in board.candidatesAt(x, pos) {
                                        if (c != p1) && (c != p2) && (c != p3) {
                                            print("Removing \(c) from \(x),\(pos)")
                                            board.removeCandidate(x: x, y: pos, value: c)
                                            removed = true
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
        }
        
        potentialsPos = [[],[],[],[],[],[],[],[],[]]
        potentials = []
        for c in candidates {
            let occurrences = squareOccurrences(board: board, x:x, y:y, num: c)
            if occurrences.count>1 && occurrences.count <= expectedCandidateCount {
                potentialsPos[c-1] = occurrences
                potentials.append(c)
            }
        }
        
        for p1 in potentials {
            for p2 in potentials {
                if p1 != p2 {
                    for p3 in potentials {
                        if p2 != p3 && p1 != p3 {
                            var combined : Set<Int> = []
                            for p in potentialsPos[p1-1] {
                                combined.insert(p)
                            }
                            for p in potentialsPos[p2-1] {
                                combined.insert(p)
                            }
                            for p in potentialsPos[p3-1] {
                                combined.insert(p)
                            }
                            if combined.count == expectedCandidateCount {
                                print("\(techniqueName()) square \([p1,p2,p3])  at \(x),\(y)")
                                var removed = false
                                for pos in combined {
                                    let posX = Int(pos%9)
                                    let posY = Int(pos/9)
                                    for c in board.candidatesAt(posX, posY) {
                                        if (c != p1) && (c != p2) && (c != p3) {
                                            print("Removing \(c) from \(posX),\(posY)")
                                            board.removeCandidate(x: posX, y: posY, value: c)
                                            removed = true
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
        }
        
        return false
    }
}
