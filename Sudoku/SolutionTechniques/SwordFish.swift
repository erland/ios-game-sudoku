//
//  SwordFish.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-25.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class SwordFish : SolverTechnique {
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
    
    func contains(master: [Int], subset: [Int]) -> Bool {
        if master.count>0 && subset.count>0 {
            for n in subset {
                if !master.contains(n) {
                    return false
                }
            }
            return true
        }else {
            return false
        }
    }
    
    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
        let candidates = board.candidatesAt(x, y)
        
        for num in candidates {
            let candidateRows = rowPositionsWithNumber(board: board, num: num, x: x)
            if candidateRows.count == 2 {
                for row in candidateRows {
                    if row != y {
                        let candidateColumns = columnPositionsWithNumber(board: board, num: num, y: row)
                        for col in candidateColumns {
                            if col != x {
                                let candidate2Rows = rowPositionsWithNumber(board: board, num: num, x: col)
                                if candidate2Rows.count == 2 {
                                    for row2 in candidate2Rows {
                                        if row2 != y && row2 != row {
                                            let candidate2Columns = columnPositionsWithNumber(board: board, num: num, y: row2)
                                            for col2 in candidate2Columns {
                                                if col2 != x && col2 != col {
                                                    let candidate3Rows = rowPositionsWithNumber(board: board, num: num, x: col2)
                                                    if candidate3Rows.count == 2 {
                                                        if candidate3Rows.contains(y) && candidate3Rows.contains(row2) {
                                                            print("SwordFish rows for \(num) at \(x),\(y)<->\(row) and \(col),\(row)<->\(row2) and \(col2),\(row2)<->\(y)")
                                                            var remove = false
                                                            for removeCol in 0..<9 {
                                                                if removeCol != x && removeCol != col2 {
                                                                    if board.candidatesAt(removeCol, y).contains(num) {
                                                                        print("Removing \(num) from \(removeCol),\(y)")
                                                                        board.removeCandidate(x: removeCol, y: y, value: num)
                                                                        remove = true
                                                                    }
                                                                }
                                                                if removeCol != col && removeCol != col2 {
                                                                    if board.candidatesAt(removeCol, row2).contains(num) {
                                                                        print("Removing \(num) from \(removeCol),\(row2)")
                                                                        board.removeCandidate(x: removeCol, y: row2, value: num)
                                                                        remove = true
                                                                    }
                                                                }
                                                                if removeCol != x && removeCol != col {
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
                                    }
                                }
                            }
                        }
                    }
                }
            }else if candidateRows.count == 3 {
                var interestingCols : [Int] = []
                for row in candidateRows {
                    let candidateCols = columnPositionsWithNumber(board: board, num: num, y: row)
                    for col in candidateCols {
                        let candidateRows2 = rowPositionsWithNumber(board: board, num: num, x: col)
                        if contains(master: candidateRows, subset: candidateRows2) && !interestingCols.contains(col) {
                            interestingCols.append(col)
                        }
                    }
                }
                if interestingCols.count == 3 {
                    print("SwordFish rows for \(num) at columns \(interestingCols[0]) and \(interestingCols[1]) and \(interestingCols[2])")
                    var remove = false
                    for row in candidateRows {
                        for col in 0..<9 {
                            if !interestingCols.contains(col) {
                                if board.candidatesAt(col, row).contains(num) {
                                    print("Removing \(num) from \(col),\(row)")
                                    board.removeCandidate(x: col, y: row, value: num)
                                    remove = true
                                }
                            }
                        }
                    }
                    if remove {
                        return true
                    }
                }
            }
            let candidateCols = columnPositionsWithNumber(board: board, num: num, y: y)
            if candidateCols.count == 2 {
                for col in candidateCols {
                    if col != x {
                        let candidateRows = rowPositionsWithNumber(board: board, num: num, x: col)
                        for row in candidateRows {
                            if row != y {
                                let candidate2Columns = columnPositionsWithNumber(board: board, num: num, y: row)
                                if candidate2Columns.count == 2 {
                                    for col2 in candidate2Columns {
                                        if col2 != x && col2 != col {
                                            let candidate2Rows = rowPositionsWithNumber(board: board, num: num, x: col2)
                                            for row2 in candidate2Rows {
                                                if row2 != y && row2 != row {
                                                    let candidate3Columns = columnPositionsWithNumber(board: board, num: num, y: row2)
                                                    if candidate3Columns.count == 2 {
                                                        if candidate3Columns.contains(x) && candidate3Columns.contains(col2) {
                                                            print("SwordFish columns for \(num) at \(x)<->\(col),\(y) and \(col)<->\(col2),\(row) and \(col2)<->\(x),\(row2)")
                                                            var remove = false
                                                            for removeRow in 0..<9 {
                                                                if removeRow != y && removeRow != row2 {
                                                                    if board.candidatesAt(x, removeRow).contains(num) {
                                                                        print("Removing \(num) from \(x),\(removeRow)")
                                                                        board.removeCandidate(x: x, y: removeRow, value: num)
                                                                        remove = true
                                                                    }
                                                                }
                                                                if removeRow != row && removeRow != row2 {
                                                                    if board.candidatesAt(col2, removeRow).contains(num) {
                                                                        print("Removing \(num) from \(col2),\(removeRow)")
                                                                        board.removeCandidate(x: col2, y: removeRow, value: num)
                                                                        remove = true
                                                                    }
                                                                }
                                                                if removeRow != y && removeRow != row {
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
                                }
                            }
                        }
                    }
                }
            }else if candidateCols.count == 3 {
                var interestingRows : [Int] = []
                for col in candidateCols {
                    let candidateRows = rowPositionsWithNumber(board: board, num: num, x: col)
                    for row in candidateRows {
                        let candidateCols2 = columnPositionsWithNumber(board: board, num: num, y: row)
                        if contains(master: candidateCols, subset: candidateCols2) && !interestingRows.contains(row) {
                            interestingRows.append(row)
                        }
                    }
                }
                if interestingRows.count == 3 {
                    print("SwordFish columns for \(num) at rows \(interestingRows[0]) and \(interestingRows[1]) and \(interestingRows[2])")
                    var remove = false
                    for col in candidateCols {
                        for row in 0..<9 {
                            if !interestingRows.contains(row) {
                                if board.candidatesAt(col, row).contains(num) {
                                    print("Removing \(num) from \(col),\(row)")
                                    board.removeCandidate(x: col, y: row, value: num)
                                    remove = true
                                }
                            }
                        }
                    }
                    if remove {
                        return true
                    }
                }
            }
        }
        return false
    }
}
