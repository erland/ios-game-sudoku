//
//  Solver.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-16.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation

class Solver {
    var board: Array<Int?>
    var rows: Array<Array<Bool>>
    var columns: Array<Array<Bool>>
    var squares: Array<Array<Bool>>
    var solutions : Array<String> = []

    convenience init() {
        self.init(boardString: "_________________________________________________________________________________")
    }
    init(boardString: String) {
        board = Array<Int?>(repeating: nil, count:9 * 9)
        rows = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        columns = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        squares = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        initializeBoard(boardString: boardString)
    }
    
    func initializeBoard(boardString: String) {
        board = Array<Int?>(repeating: nil, count:9 * 9)
        rows = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        columns = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        squares = Array<Array<Bool>>(repeating: Array<Bool>(repeating: false, count: 9), count: 9)
        
        for y in 0..<9 {
            for x in 0..<9 {
                let i = 9*y+x
                if boardString.count > i {
                    let ch = boardString[boardString.index(boardString.startIndex, offsetBy: i)]
                    if ch != "_" && ch != "0" {
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
        
        //print("squareOf(\(x),\(y)) = \(squareRow),\(squareColumn),\(squareRow * 3 + squareColumn)")
        return squareRow * 3 + squareColumn
    }
    
    func setValue(x: Int, y: Int, value: Int, present: Bool) {
        board[y*9+x] = value
        rows[y][value - 1] = present
        columns[x][value - 1] = present
        squares[squareOf(x,y)][value - 1] = present
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
    
    func solve() -> Bool {
        solutions.removeAll()
        solve(0,0)
        return solutions.count == 1
    }
    
    func generate() -> String? {
        let n = [1,2,3,4,5,6,7,8,9].shuffled()
        
        initializeBoard(boardString: "\(n[0])\(n[1])\(n[2])\(n[3])\(n[4])\(n[5])\(n[6])\(n[7])\(n[8])________________________________________________________________________")
        solve()
        if solutions.count>0 {
            let boardString = solutions[0]
            let positions = (0..<81).shuffled()
            initializeBoard(boardString: boardString)
            return generate(positions: positions, boardString: boardString)
        }
        return nil
    }
    
    func generate(positions: [Int?], boardString: String) -> String {
        if positions.count>0 {
            var modifiedPositions = positions
            let i = positions[Int.random(in: 0..<positions.count)]
            var modifiedString = boardString
            for j in [i!,(80-i!)] {
                let num = board[j]
                if let num = num {
                    modifiedString = String(modifiedString.prefix(j) + "_" + modifiedString.dropFirst(j + 1))
                    let x = j % 9
                    let y = j / 9
                    setValue(x: x, y: y, value: num, present: false)
                    board[j] = nil
                    modifiedPositions = modifiedPositions.filter { $0 != j }
                }
            }
            solutions.removeAll()
            if solve() {
                return generate(positions: modifiedPositions, boardString: modifiedString)
            }else {
                initializeBoard(boardString: boardString)
                return generate(positions: modifiedPositions, boardString: boardString)
            }
        }
        return boardString
    }

    func solve(_ x:Int, _ y:Int) -> Bool {
        var currentX = x
        var currentY = y
        // If last number of line
        if x == 9 {
            currentX = 0
            currentY = currentY + 1
            // If last number on board
            if currentY == 9 {
                solutions.append(asString())
                return true
            }
        }
        
        // If number already exists at this position
        if valueAt(currentX, currentY) != nil {
            // Goto next position
            return solve(currentX+1,currentY)
        }
        
        var solved = false
        
        for value in (1...9).shuffled() {
            if isValid(x: currentX, y: currentY, value: value) {
                setValue(x: currentX, y: currentY, value: value, present: true)
                if solve(currentX+1, currentY) {
                    solved = true
                    if solutions.count>1 {
                        return true
                    }
                }
                setValue(x: currentX, y: currentY, value: value, present: false)
            }
        }
        
        board[y*9+x] = nil
        return solved
    }
    
    func getCandidates(_ x: Int, _ y: Int) -> [Int] {
        var candidates : [Int] = []
        for n in 1...9 {
            if isValid(x: x, y: y, value: n) {
                candidates.append(n)
            }
        }
        return candidates
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
