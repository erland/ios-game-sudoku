//
//  DifficultyCalculator.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-17.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation

protocol SolverTechnique {
    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool
}

protocol BoardHandler {
    func squareOf(_ x:Int, _ y:Int) -> Int
    func setValue(x: Int, y: Int, value: Int, present: Bool)
    func valueAt(_ x: Int, _ y: Int) -> Int?
    func isValid(x: Int, y: Int, value: Int) -> Bool
    func candidatesAt(_ x: Int, _ y: Int) -> [Int]
    func removeCandidate(x: Int, y: Int, value: Int)
}

class DifficultyCalculator : BoardHandler {
    var board: Array<Int?>
    var candidates: Array<Array<Int>>
    var rows: Array<Array<Bool>>
    var columns: Array<Array<Bool>>
    var squares: Array<Array<Bool>>
    
    init(boardString: String) {
        board = Array<Int?>(repeating: nil, count:9 * 9)
        candidates = Array<Array<Int>>(repeating: Array<Int>(), count: 9*9)
        rows = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        columns = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        squares = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        initializeBoard(boardString: boardString)
    }
    
    func initializeBoard(boardString: String) {
        board = Array<Int?>(repeating: nil, count:9 * 9)
        candidates = Array<Array<Int>>(repeating: Array<Int>(), count: 9*9)
        rows = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        columns = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        squares = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        
        for y in 0..<9 {
            for x in 0..<9 {
                let i = 9*y+x
                if boardString.count > i {
                    let ch = boardString[boardString.index(boardString.startIndex, offsetBy: i)]
                    if ch != "_" {
                        if let num = Int(String(ch)) {
                            setValue(x: x,y: y, value: num, present: true)
                        }
                    }
                }
            }
        }
        
    }
    
    func asString() -> String {
        var result = ""
        for i in 0..<81 {
            if board[i] != nil {
                result = result + "\(board[i]!)"
            }else {
                result = result + "_"
            }
        }
        return result
    }

    func squareOf(_ x:Int, _ y:Int) -> Int {
        let squareRow = y / 3
        let squareColumn = x / 3
        
        return squareRow * 3 + squareColumn
    }
    
    func setValue(x: Int, y: Int, value: Int, present: Bool) {
        board[y*9+x] = value
        rows[y][value - 1] = present
        columns[x][value - 1] = present
        squares[squareOf(x,y)][value - 1] = present
        print("Setting \(value) at \(x),\(y)")
        candidates[y*9+x] = []
        for row in 0..<9 {
            if candidates[row*9+x].contains(value) {
                print("Removing \(value) from \(x),\(row)")
                candidates[row*9+x] = candidates[row*9+x].filter({$0 != value})
            }
        }
        for column in 0..<9 {
            if candidates[y*9+column].contains(value) {
                print("Removing \(value) from \(column),\(y)")
                candidates[y*9+column] = candidates[y*9+column].filter({$0 != value})
            }
        }
        let square = squareOf(x, y)
        let topRow = Int(square/3)*3
        let leftColumn = (square%3)*3
        for row in 0..<3 {
            for column in 0..<3 {
                if candidates[(topRow+row)*9+(leftColumn+column)].contains(value) {
                    print("Removing \(value) from \(leftColumn+column),\(topRow+row)")
                    candidates[(topRow+row)*9+(leftColumn+column)] = candidates[(topRow+row)*9+(leftColumn+column)].filter({$0 != value})
                }
            }
        }
    }
    
    func valueAt(_ x: Int, _ y: Int) -> Int? {
        return board[y*9+x]
    }
    
    func printBoard() {
        for y in 0..<9 {
            if y % 3 == 0 {
                print(" -----------------------")
            }
            
            var rowString = ""
            for x in 0..<9 {
                if x % 3 == 0 {
                    rowString = rowString + "| "
                }
                
                rowString = rowString + (valueAt(x,y) != nil ? String(valueAt(x,y)!) : " ")
                rowString = rowString + " "
            }
            
            print("\(rowString)|")
        }
        
        print(" -----------------------")
    }
    
    class SingleCandidate : SolverTechnique {
        func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
            let candidates = board.candidatesAt(x, y)
            if candidates.count == 1 {
                board.setValue(x: x, y: y, value: candidates[0], present: true)
                return true
            }
            return false
        }
    }
    
    class SinglePosition : SolverTechnique {
        func isNumberInRow(board: BoardHandler, num: Int, x: Int, y: Int) -> Bool {
            for row in 0..<9 {
                if row != y {
                    if board.candidatesAt(x, row).contains(num) {
                        return true
                    }
                }
            }
            return false
        }
        func isNumberInColumn(board: BoardHandler, num: Int, x: Int, y: Int) -> Bool {
            for column in 0..<9 {
                if column != x {
                    if board.candidatesAt(column, y).contains(num) {
                        return true
                    }
                }
            }
            return false
        }
        func isNumberInSquare(board: BoardHandler, num: Int, x: Int, y: Int) -> Bool {
            let square = board.squareOf(x, y)
            let topRow = Int(square/3)*3
            let leftColumn = (square%3)*3
            for row in 0..<3 {
                for column in 0..<3 {
                    if row+topRow != y || column+leftColumn != x {
                        if board.candidatesAt(leftColumn+column, topRow+row).contains(num) {
                            return true
                        }
                    }
                }
            }
            return false
        }
        
        func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
            let candidates = board.candidatesAt(x, y)
            if candidates.count < 2 {
                return false
            }
            for num in candidates {
                print("SinglePosition \(num) at \(x),\(y)")
                if !isNumberInRow(board: board, num: num, x: x, y: y) {
                    board.setValue(x: x, y: y, value: num, present: true)
                    return true
                }
                if !isNumberInColumn(board: board, num: num, x: x, y: y) {
                    board.setValue(x: x, y: y, value: num, present: true)
                    return true
                }
                if !isNumberInSquare(board: board, num: num, x: x, y: y) {
                    board.setValue(x: x, y: y, value: num, present: true)
                    return true
                }
            }
            return false
        }
    }

    class CandidateLines : SolverTechnique {
        func isNumberOutsideSquareRow(board: BoardHandler, num: Int, x: Int, y: Int) -> Bool {
            let square = board.squareOf(x, y)
            let topRow = Int(square/3)*3
            let leftColumn = (square%3)*3
            for row in 0..<3 {
                if row+topRow != y {
                    for column in 0..<3 {
                        if board.candidatesAt(leftColumn+column, topRow+row).contains(num) {
                            return true
                        }
                    }
                }
            }
            return false
        }
        func isNumberOutsideSquareColumn(board: BoardHandler, num: Int, x: Int, y: Int) -> Bool {
            let square = board.squareOf(x, y)
            let topRow = Int(square/3)*3
            let leftColumn = (square%3)*3

            for column in 0..<3 {
                if column+leftColumn != x {
                    for row in 0..<3 {
                        if board.candidatesAt(leftColumn+column, topRow+row).contains(num) {
                            return true
                        }
                    }
                }
            }
            return false
        }

        func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
            let candidates = board.candidatesAt(x, y)
            let currentSquare = board.squareOf(x, y)
            for num in candidates {
                print("CandidateLines \(num)  at \(x),\(y)")
                if !isNumberOutsideSquareRow(board: board, num: num, x: x, y: y) {
                    var removed = false
                    for column in 0..<9 {
                        let square = board.squareOf(column,y)
                        if square != currentSquare {
                            if board.candidatesAt(column,y).contains(num) {
                                print("Removing \(num) from \(column),\(y)")
                                board.removeCandidate(x: column, y: y, value: num)
                                removed = true
                            }
                        }
                    }
                    if removed {
                        return true
                    }
                }
                
                if !isNumberOutsideSquareColumn(board: board, num: num, x: x, y: y) {
                    var removed = false
                    for row in 0..<9 {
                        let square = board.squareOf(x,row)
                        if square != currentSquare {
                            if board.candidatesAt(x,row).contains(num) {
                                print("Removing \(num) from \(x),\(row)")
                                board.removeCandidate(x: x, y: row, value: num)
                                removed = true
                            }
                        }
                    }
                    if removed {
                        return true
                    }
                }
            }
            return false
        }
    }

    class MultipleLines : SolverTechnique {
        func isNumberOnlyInSquareRow(board: BoardHandler, num: Int, x: Int, y: Int) -> Bool {
            let square = board.squareOf(x, y)

            for column in 0..<9 {
                if board.squareOf(column, y) != square {
                    if board.candidatesAt(column, y).contains(num) {
                        return false
                    }
                }
            }
            return true
        }
        func isNumberOnlyInSquareColumn(board: BoardHandler, num: Int, x: Int, y: Int) -> Bool {
            let square = board.squareOf(x, y)
            
            for row in 0..<9 {
                if board.squareOf(x, row) != square {
                    if board.candidatesAt(x, row).contains(num) {
                        return false
                    }
                }
            }
            return true
        }

        func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
            let candidates = board.candidatesAt(x, y)
            let square = board.squareOf(x, y)
            let topRow = Int(square/3)*3
            let leftColumn = (square%3)*3

            for num in candidates {
                print("MultiLine \(num)  at \(x),\(y)")
                if isNumberOnlyInSquareRow(board: board, num: num, x: x, y: y) {
                    var removed = false
                    for row in 0..<3 {
                        if topRow+row != y {
                            for column in 0..<3 {
                                if board.candidatesAt(leftColumn+column,topRow+row).contains(num) {
                                    print("Removing \(num) from \(leftColumn+column),\(topRow+row)")
                                    board.removeCandidate(x: leftColumn+column, y: topRow+row, value: num)
                                    removed = true
                                }

                            }
                        }
                    }
                    if removed {
                        return true
                    }
                }
                if isNumberOnlyInSquareColumn(board: board, num: num, x: x, y: y) {
                    var removed = false
                    for column in 0..<3 {
                        if leftColumn+column != x {
                            for row in 0..<3 {
                                if board.candidatesAt(leftColumn+column,topRow+row).contains(num) {
                                    print("Removing \(num) from \(leftColumn+column),\(topRow+row)")
                                    board.removeCandidate(x: leftColumn+column, y: topRow+row, value: num)
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
            return false
        }
    }

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
    
    class NakedQuad : NakedPairs {
        init() {
            super.init(expectedCandidateCount: 4)
        }
        override func techniqueName() -> String {
            return "NakedQuad"
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
                            print("\(techniqueName()) \(cellCandidates)  at \(x),\(y)")
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
                            print("\(techniqueName()) \(cellCandidates)  at \(x),\(y)")
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
                                print("\(techniqueName()) \(cellCandidates)  at \(x),\(y)")
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

    func candidatesAt(_ x: Int, _ y: Int) -> [Int] {
        return candidates[y*9+x]
    }
    func removeCandidate(x: Int, y: Int, value: Int) {
        candidates[y*9+x] = candidates[y*9+x].filter({$0 != value})
    }

    func solve(techniques: [SolverTechnique]) -> Bool {
        resetCandidates()
        var makesProgress = true
        while makesProgress {
            makesProgress = false
            for t in techniques {
                if solve(technique: t) {
                    makesProgress = true
                    break
                }
            }
        }
        for i in 0..<81 {
            if board[i] == nil {
                return false
            }
        }
        return true
    }
    
    func solve(technique: SolverTechnique) -> Bool {
        for y in 0..<9 {
            for x in 0..<9 {
                if board[y*9+x] == nil {
                    if technique.solvePosition(board: self, x: x, y: y) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func resetCandidates() {
        candidates = Array<Array<Int>>(repeating: Array<Int>(), count: 81)
        for y in 0..<9 {
            for x in 0..<9 {
                if board[y*9+x] == nil {
                    for n in 1...9 {
                        if isValid(x: x, y: y, value: n) {
                            candidates[y*9+x].append(n)
                        }
                    }
                }
            }
        }
    }
    
    func isValid(x: Int, y: Int, value: Int) -> Bool {
        let currentValue = value - 1
        
        let isPresent = rows[y][currentValue] || columns[x][currentValue] || squares[squareOf(x, y)][currentValue]
        //print("isValid rows = \(rows[y][currentValue]) for \(x),\(y)=\(value)")
        //print("isValid columns = \(columns[x][currentValue]) for \(x),\(y)=\(value)")
        //print("isValid squares = \(squares[squareOf(x, y)][currentValue]) for \(x),\(y)=\(value)")
        return !isPresent
    }
}
