//
//  HiddenQuads.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class HiddenQuads : HiddenTriples {
    init() {
        super.init(expectedCandidateCount: 4)
    }
    
    override func techniqueName() -> String {
        return "HiddenQuads"
    }
    override func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
        let candidates = board.candidatesAt(x, y)
        var potentialsPos : [[Int]] = [[],[],[],[],[],[],[],[],[]]
        var potentials : [Int] = []
        for c in 1...9 {
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
                            for p4 in potentials {
                                if p1 != p4 && p2 != p4 && p3 != p4 {
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
                                    for p in potentialsPos[p4-1] {
                                        combined.insert(p)
                                    }
                                    if combined.count == expectedCandidateCount {
                                        print("\(techniqueName()) row \([p1,p2,p3,p4])  at \(x),\(y)")
                                        var removed = false
                                        for pos in combined {
                                            for c in board.candidatesAt(pos, y) {
                                                if (c != p1) && (c != p2) && (c != p3) && (c != p4) {
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
            }
        }
        
        potentialsPos = [[],[],[],[],[],[],[],[],[]]
        potentials = []
        for c in 1...9 {
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
                            for p4 in potentials {
                                if p1 != p4 && p2 != p4 && p3 != p4 {
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
                                    for p in potentialsPos[p4-1] {
                                        combined.insert(p)
                                    }
                                    if combined.count == expectedCandidateCount {
                                        print("\(techniqueName()) column \([p1,p2,p3,p4])  at \(x),\(y)")
                                        var removed = false
                                        for pos in combined {
                                            for c in board.candidatesAt(x, pos) {
                                                if (c != p1) && (c != p2) && (c != p3) && (c != p4) {
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
            }
        }
        
        potentialsPos = [[],[],[],[],[],[],[],[],[]]
        potentials = []
        for c in 1...9 {
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
                            for p4 in potentials {
                                if p1 != p4 && p2 != p4 && p3 != p4 {
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
                                    for p in potentialsPos[p4-1] {
                                        combined.insert(p)
                                    }
                                    if combined.count == expectedCandidateCount {
                                        print("\(techniqueName()) square \([p1,p2,p3,p4])  at \(x),\(y)")
                                        var removed = false
                                        for pos in combined {
                                            let posX = Int(pos%9)
                                            let posY = Int(pos/9)
                                            for c in board.candidatesAt(posX, posY) {
                                                if (c != p1) && (c != p2) && (c != p3) && (c != p4) {
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
            }
        }
        
        return false
    }
}
