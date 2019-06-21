//
//  SinglePosition.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

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
            if !isNumberInRow(board: board, num: num, x: x, y: y) {
                print("SinglePosition row \(num) at \(x),\(y)")
                board.setValue(x: x, y: y, value: num, present: true)
                return true
            }
            if !isNumberInColumn(board: board, num: num, x: x, y: y) {
                print("SinglePosition column \(num) at \(x),\(y)")
                board.setValue(x: x, y: y, value: num, present: true)
                return true
            }
            if !isNumberInSquare(board: board, num: num, x: x, y: y) {
                print("SinglePosition square \(num) at \(x),\(y)")
                board.setValue(x: x, y: y, value: num, present: true)
                return true
            }
        }
        return false
    }
}
