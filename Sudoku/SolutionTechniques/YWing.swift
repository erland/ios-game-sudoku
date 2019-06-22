//
//  YWing.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-22.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class YWing : SolverTechnique {
    func findOtherPairsWithNumber(board: BoardHandler, num: Int, x: Int, y: Int) -> [Int] {
        var result : [Int] = []
        for col in 0..<9 {
            if col != x {
                if board.candidatesAt(col, y).count == 2 && board.candidatesAt(col, y).contains(num) {
                    result.append(y*9+col)
                }
            }
        }
        for row in 0..<9 {
            if row != y {
                if board.candidatesAt(x, row).count == 2 && board.candidatesAt(x, row).contains(num) {
                    result.append(row*9+x)
                }
            }
        }
        let square = board.squareOf(x, y)
        let topRow = Int(square/3)*3
        let leftColumn = (square%3)*3
        for row in 0..<3 {
            for col in 0..<3 {
                if leftColumn+col != x || topRow+y != y {
                    if board.candidatesAt(leftColumn+col, topRow+row).count == 2 && board.candidatesAt(leftColumn+col, topRow+row).contains(num) {
                        result.append((topRow+row)*9+leftColumn+col)
                    }
                }
            }
        }
        return result
    }
    
    func findOtherPairsWithNumbers(board: BoardHandler, pair: [Int], x: Int, y: Int) -> [Int] {
        var result : [Int] = []
        for col in 0..<9 {
            if col != x {
                if board.candidatesAt(col, y).count == 2 && board.candidatesAt(col, y).contains(pair[0]) && board.candidatesAt(col, y).contains(pair[1]) {
                    result.append(y*9+col)
                }
            }
        }
        for row in 0..<9 {
            if row != y {
                if board.candidatesAt(x, row).count == 2 && board.candidatesAt(x, row).contains(pair[0]) && board.candidatesAt(x, row).contains(pair[1]) {
                    result.append(row*9+x)
                }
            }
        }
        return result
    }

    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
        let candidates = board.candidatesAt(x, y)
        if candidates.count != 2 {
            return false
        }
        for num in candidates {
            let otherPositions = findOtherPairsWithNumber(board: board, num: num, x: x, y: y)
            var firstNum = candidates[0]
            if firstNum == num {
                firstNum = candidates[1]
            }
            for otherPos in otherPositions {
                let otherX = otherPos%9
                let otherY = Int(otherPos/9)
                print("Found possible YWing for \(firstNum) at \(x),\(y) and \(otherX),\(otherY)")
                let otherCandidates = board.candidatesAt(otherX, otherY)
                var otherNum = otherCandidates[0]
                if otherNum == num {
                    otherNum = otherCandidates[1]
                }
                let thirdPositions = findOtherPairsWithNumbers(board: board, pair: [firstNum,otherNum], x: otherX, y: otherY)
                for thirdPos in thirdPositions {
                    let thirdX = thirdPos%9
                    let thirdY = Int(thirdPos/9)
                    print("Evaluating YWing for \(firstNum) at \(x),\(y) and \(otherX),\(otherY) and \(thirdX),\(thirdY)")
                    if (thirdX != x || thirdX != otherX) && (thirdY != y || thirdY != otherY) {
                        print("YWing for \(firstNum) at \(x),\(y) and \(otherX),\(otherY) and \(thirdX),\(thirdY)")
                        var removed = false
                        if board.candidatesAt(thirdX, y).contains(firstNum) {
                            print("Removing \(firstNum) from \(thirdX),\(y)")
                            board.removeCandidate(x: thirdX, y: y, value: firstNum)
                            removed = true
                        }
                        if board.candidatesAt(x, thirdY).contains(firstNum) {
                            print("Removing \(firstNum) from \(x),\(thirdY)")
                            board.removeCandidate(x: x, y: thirdY, value: firstNum)
                            removed = true
                        }
                        for removeRow in 0..<9 {
                            if board.squareOf(x, removeRow) == board.squareOf(thirdX, thirdY) {
                                if board.candidatesAt(x, removeRow).contains(firstNum) {
                                    print("Removing \(firstNum) from \(x),\(removeRow)")
                                    board.removeCandidate(x: x, y: removeRow, value: firstNum)
                                    removed = true
                                }
                            }
                            if board.squareOf(thirdX, removeRow) == board.squareOf(x, y) {
                                if board.candidatesAt(thirdX, removeRow).contains(firstNum) {
                                    print("Removing \(firstNum) from \(thirdX),\(removeRow)")
                                    board.removeCandidate(x: thirdX, y: removeRow, value: firstNum)
                                    removed = true
                                }
                            }
                        }
                        for removeCol in 0..<9 {
                            if board.squareOf(removeCol, y) == board.squareOf(thirdX, thirdY) {
                                if board.candidatesAt(removeCol, y).contains(firstNum) {
                                    print("Removing \(firstNum) from \(removeCol),\(y)")
                                    board.removeCandidate(x: removeCol, y: y, value: firstNum)
                                    removed = true
                                }
                            }
                            if board.squareOf(removeCol, thirdY) == board.squareOf(x, y) {
                                if board.candidatesAt(removeCol, thirdY).contains(firstNum) {
                                    print("Removing \(firstNum) from \(removeCol),\(thirdY)")
                                    board.removeCandidate(x: removeCol, y: thirdY, value: firstNum)
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
        return false
    }
}
