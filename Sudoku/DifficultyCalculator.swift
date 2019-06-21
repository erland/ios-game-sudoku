//
//  DifficultyCalculator.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-17.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation


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
        return !isPresent
    }
}
