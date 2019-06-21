//
//  MultipleLines.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

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
            if isNumberOnlyInSquareRow(board: board, num: num, x: x, y: y) {
                print("MultiplesLines row \(num)  at \(x),\(y)")
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
                print("MultiLine column \(num)  at \(x),\(y)")
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
