//
//  CandidateLines.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

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
            if !isNumberOutsideSquareRow(board: board, num: num, x: x, y: y) {
                print("CandidateLines row \(num)  at \(x),\(y)")
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
                print("CandidateLines column \(num)  at \(x),\(y)")
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
