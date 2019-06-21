//
//  XWing.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class XWing : SolverTechnique {
    func columnWithSameNumbers(board: BoardHandler, num: Int, x: Int, y: Int, otherY: Int) -> Int? {
        for col in 0..<9 {
            if col != x {
                if board.candidatesAt(col, y).contains(num) && board.candidatesAt(col, otherY).contains(num) {
                    return col
                }
            }
        }
        return nil
    }
    
    func rowWithSameNumbers(board: BoardHandler, num: Int, x: Int, y: Int, otherX: Int) -> Int? {
        for row in 0..<9 {
            if row != y {
                if board.candidatesAt(x, row).contains(num) && board.candidatesAt(otherX, row).contains(num) {
                    return row
                }
            }
        }
        return nil
    }
    
    func rowPositionsWithNumber(board: BoardHandler, num: Int, x: Int) -> [Int] {
        var result : [Int] = []
        for row in 0..<9 {
            if board.candidatesAt(x, row).contains(num) {
                result.append(row)
            }
        }
        return result
    }
    
    func columnPositionsWithNumber(board: BoardHandler, num: Int, y: Int) -> [Int] {
        var result : [Int] = []
        for col in 0..<9 {
            if board.candidatesAt(col, y).contains(num) {
                result.append(col)
            }
        }
        return result
    }
    
    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
        let candidates = board.candidatesAt(x, y)
        
        for num in candidates {
            let candidateRows = rowPositionsWithNumber(board: board, num: num, x: x)
            if candidateRows.count==2 {
                for row in candidateRows {
                    if row != y {
                        let col = columnWithSameNumbers(board: board, num: num, x: x, y: y, otherY: row)
                        if let col = col {
                            if rowPositionsWithNumber(board: board, num: num, x: col).count == 2 {
                                var remove = false
                                print("XWing for \(num) at \(x),\(y) and \(col),\(row)")
                                for removeCol in 0..<9 {
                                    if removeCol != x && removeCol != col {
                                        if board.candidatesAt(removeCol, y).contains(num) {
                                            print("Removing \(num) from \(removeCol),\(y)")
                                            board.removeCandidate(x: removeCol, y: y, value: num)
                                            remove = true
                                        }
                                        if board.candidatesAt(removeCol, row).contains(num) {
                                            print("Removing \(num) from \(removeCol),\(row)")
                                            board.removeCandidate(x: removeCol, y: row, value: num)
                                            remove = true
                                        }
                                    }
                                }
                                if remove {
                                    return true
                                }
                            }
                        }
                    }
                }
            }
            
            let candidateCols = columnPositionsWithNumber(board: board, num: num, y: y)
            if candidateCols.count==2 {
                for col in candidateCols {
                    if col != x {
                        let row = rowWithSameNumbers(board: board, num: num, x: x, y: y, otherX: col)
                        if let row = row {
                            if columnPositionsWithNumber(board: board, num: num, y: row).count == 2 {
                                var remove = false
                                print("XWing for \(num) at \(x),\(y) and \(col),\(row)")
                                for removeRow in 0..<9 {
                                    if removeRow != y && removeRow != row {
                                        if board.candidatesAt(x, removeRow).contains(num) {
                                            print("Removing \(num) from \(x),\(removeRow)")
                                            board.removeCandidate(x: x, y: removeRow, value: num)
                                            remove = true
                                        }
                                        if board.candidatesAt(col, removeRow).contains(num) {
                                            print("Removing \(num) from \(col),\(removeRow)")
                                            board.removeCandidate(x: col, y: removeRow, value: num)
                                            remove = true
                                        }
                                    }
                                }
                                if remove {
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
