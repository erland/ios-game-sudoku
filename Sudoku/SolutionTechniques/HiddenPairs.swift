//
//  HiddenPairs.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class HiddenPairs : SolverTechnique {
    let expectedCandidateCount : Int
    init(expectedCandidateCount: Int = 2) {
        self.expectedCandidateCount = expectedCandidateCount
    }
    
    func isRowCandidate(board: BoardHandler, x: Int, y: Int, num: Int) -> Bool {
        var count = 1
        for col in 0..<9 {
            if col != x {
                if board.candidatesAt(col, y).contains(num) {
                    count = count + 1
                }
            }
        }
        return count == expectedCandidateCount
    }
    
    func isFullRowCandidate(board: BoardHandler, y: Int, wanted: [Int]) -> Bool {
        var count = 0
        for col in 0..<9 {
            let candidates = board.candidatesAt(col, y)
            var match = true
            for num in wanted {
                if !candidates.contains(num) {
                    match = false
                    break
                }
            }
            if match {
                count = count + 1
            }
        }
        return count == expectedCandidateCount
    }
    
    func isColumnCandidate(board: BoardHandler, x: Int, y: Int, num: Int) -> Bool {
        var count = 1
        for row in 0..<9 {
            if row != y {
                if board.candidatesAt(x, row).contains(num) {
                    count = count + 1
                }
            }
        }
        return count == expectedCandidateCount
    }
    
    
    func isFullColumnCandidate(board: BoardHandler, x: Int, wanted: [Int]) -> Bool {
        var count = 0
        for row in 0..<9 {
            let candidates = board.candidatesAt(x, row)
            var match = true
            for num in wanted {
                if !candidates.contains(num) {
                    match = false
                    break
                }
            }
            if match {
                count = count + 1
            }
        }
        return count == expectedCandidateCount
    }
    
    func isSquareCandidate(board: BoardHandler, x: Int, y: Int, num: Int) -> Bool {
        var count = 1
        let square = board.squareOf(x, y)
        let topRow = Int(square/3)*3
        let leftColumn = (square%3)*3
        for row in 0..<3 {
            for col in 0..<3 {
                if row+topRow != y || col+leftColumn != x {
                    if board.candidatesAt(col+leftColumn,row+topRow).contains(num) {
                        count = count + 1
                    }
                }
            }
        }
        return count == expectedCandidateCount
    }
    
    
    func isFullSquareCandidate(board: BoardHandler, x: Int, y: Int, wanted: [Int]) -> Bool {
        var count = 0
        let square = board.squareOf(x, y)
        let topRow = Int(square/3)*3
        let leftColumn = (square%3)*3
        for row in 0..<3 {
            for col in 0..<3 {
                let candidates = board.candidatesAt(leftColumn+col, topRow+row)
                var match = true
                for num in wanted {
                    if !candidates.contains(num) {
                        match = false
                        break
                    }
                }
                if match {
                    count = count + 1
                }
            }
        }
        return count == expectedCandidateCount
    }
    
    func techniqueName() -> String {
        return "HiddenPairs"
    }
    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
        let candidates = board.candidatesAt(x, y)
        
        var potentials : [Int] = []
        for c in candidates {
            if isRowCandidate(board: board, x:x, y:y, num: c) {
                potentials.append(c)
            }
        }
        if potentials.count>1 {
            var result = false
            for p1 in potentials {
                for p2 in potentials {
                    if p2 != p1 {
                        if isFullRowCandidate(board: board, y: y, wanted: [p1,p2]) {
                            print("\(techniqueName()) row \([p1,p2])  at \(x),\(y)")
                            for col in 0..<9 {
                                let numbers = board.candidatesAt(col, y)
                                if numbers.contains(p1) && numbers.contains(p2) {
                                    for n in numbers {
                                        if n != p1 && n != p2 {
                                            print("Removing \(n) from \(col),\(y)")
                                            board.removeCandidate(x: col, y: y, value: n)
                                            result = true
                                        }
                                    }
                                }
                            }
                            if result {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        potentials = []
        for c in candidates {
            if isColumnCandidate(board: board, x:x, y:y, num: c) {
                potentials.append(c)
            }
        }
        if potentials.count>1 {
            var result = false
            for p1 in potentials {
                for p2 in potentials {
                    if p2 != p1 {
                        if isFullColumnCandidate(board: board, x: x, wanted: [p1,p2]) {
                            print("\(techniqueName()) column \([p1,p2])  at \(x),\(y)")
                            for row in 0..<9 {
                                let numbers = board.candidatesAt(x, row)
                                if numbers.contains(p1) && numbers.contains(p2) {
                                    for n in numbers {
                                        if n != p1 && n != p2 {
                                            print("Removing \(n) from \(x),\(row)")
                                            board.removeCandidate(x: x, y: row, value: n)
                                            result = true
                                        }
                                    }
                                }
                            }
                            if result {
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        potentials = []
        for c in candidates {
            if isSquareCandidate(board: board, x:x, y:y, num: c) {
                potentials.append(c)
            }
        }
        if potentials.count>1 {
            var result = false
            for p1 in potentials {
                for p2 in potentials {
                    if p2 != p1 {
                        if isFullSquareCandidate(board: board, x: x, y: y, wanted: [p1,p2]) {
                            print("\(techniqueName()) square \([p1,p2])  at \(x),\(y)")
                            let square = board.squareOf(x, y)
                            let topRow = Int(square/3)*3
                            let leftColumn = (square%3)*3
                            for row in 0..<3 {
                                for col in 0..<3 {
                                    let numbers = board.candidatesAt(leftColumn+col, topRow+row)
                                    if numbers.contains(p1) && numbers.contains(p2) {
                                        for n in numbers {
                                            if n != p1 && n != p2 {
                                                print("Removing \(n) from \(leftColumn+col),\(topRow+row)")
                                                board.removeCandidate(x: leftColumn+col, y: topRow+row, value: n)
                                                result = true
                                            }
                                        }
                                    }
                                }
                            }
                            if result {
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
