//
//  SimpleColouring.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-26.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

class SimpleColouring : SolverTechnique {
    func rowPositionWithNumber(board: BoardHandler, num: Int, x: Int, y: Int) -> Int? {
        var result : [Int] = []
        for row in 0..<9 {
            if row != y && board.candidatesAt(x, row).contains(num) {
                result.append(row*9+x)
            }
        }
        if result.count == 1 {
            return result[0]
        }else {
            return nil
        }
    }
    
    func colidesWithCandidate(board: BoardHandler, num: Int, pos: Int, candidates: [Int]) -> Bool {
        let y = Int(pos/9)
        let x = pos%9
        let square = board.squareOf(x, y)
        for c in candidates {
            if c != pos {
                let candidateRow = Int(c/9)
                let candidateCol = c%9
                let candidateSquare = board.squareOf(candidateCol, candidateRow)
                if y == candidateRow {
                    //print("Number1 \(num) at \(x),\(y) collies with \(candidateCol),\(candidateRow)")
                    return true
                }
                if x == candidateCol {
                    //print("Number2 \(num) at \(x),\(y) collies with \(candidateCol),\(candidateRow)")
                    return true
                }
                if square == candidateSquare {
                    //print("Number3 \(num) at \(x),\(y) collies with \(candidateCol),\(candidateRow)")
                    return true
                }
            }
        }
        return false
    }

    func sharedPositions(board: BoardHandler, num: Int, candidates1: [Int], candidates2: [Int]) -> [Int] {
        var result : [Int] = []
        
        for c1 in candidates1 {
            let y1 = Int(c1/9)
            let x1 = c1%9
            let s1 = board.squareOf(x1, y1)
            for c2 in candidates2 {
                let y2 = Int(c2/9)
                let x2 = c2%9
                let s2 = board.squareOf(x2, y2)
                //print("Checking \(num) for shared \(x1),\(y1) and \(x2),\(y2)")
                if x1 != x2 && y1 != y2 {
                    if board.candidatesAt(x1,y2).contains(num) {
                        if !result.contains(y2*9+x1) {
                            //print("Adding shared corner1 pos: \(y2*9+x1)")
                            result.append(y2*9+x1)
                        }
                    }
                    if board.candidatesAt(x2,y1).contains(num) {
                        if !result.contains(y1*9+x2) {
                            //print("Adding shared corner2 pos: \(y1*9+x2)")
                            result.append(y1*9+x2)
                        }
                    }
                }
                
                // Same square
                if s1 == s2 {
                    let topRow = Int(s1/3)*3
                    let leftColumn = (s1%3)*3
                    for row in 0..<3 {
                        for col in 0..<3 {
                            if (leftColumn+col) != x1 && (topRow+row) != y1 && (leftColumn+col) != x2 && (topRow+row) != y2 {
                                if board.candidatesAt((leftColumn+col), (topRow+row)).contains(num) {
                                    if !result.contains((topRow+row)*9+(leftColumn+col)) {
                                        //print("Adding shared same square pos: \((topRow+row)*9+(leftColumn+col))")
                                        result.append((topRow+row)*9+(leftColumn+col))
                                    }
                                }
                            }
                        }
                    }
                }
                // Vertical square
                if s1 != s2 && s1%3 == s2%3 && x1 != x2 {
                    let topRow1 = Int(s1/3)*3
                    let topRow2 = Int(s2/3)*3
                    for row in 0..<3 {
                        if (topRow1+row) != y1 {
                            if board.candidatesAt(x2, topRow1+row).contains(num) {
                                if !result.contains((topRow1+row)*9+x2) {
                                    //print("Adding shared vertical1 square pos: \((topRow1+row)*9+x1)")
                                    result.append((topRow1+row)*9+x2)
                                }
                            }
                        }
                        if (topRow2+row) != y2 {
                            if board.candidatesAt(x1, topRow2+row).contains(num) {
                                if !result.contains((topRow2+row)*9+x1) {
                                    //print("Adding shared vertical2 square pos: \((topRow2+row)*9+x2)")
                                    result.append((topRow2+row)*9+x1)
                                }
                            }
                        }
                    }
                }
                // Horizontal square
                if s1 != s2 && Int(s1/3) == Int(s2/3) && y1 != y2 {
                    let leftColumn1 = (s1%3)*3
                    let leftColumn2 = (s2%3)*3
                    for col in 0..<3 {
                        if (leftColumn1+col) != x1 {
                            if board.candidatesAt(leftColumn1+col, y2).contains(num) {
                                if !result.contains(y2*9+leftColumn1+col) {
                                    //print("Adding shared horizontal1 square pos: \(y1*9+leftColumn1+col)")
                                    result.append(y2*9+leftColumn1+col)
                                }
                            }
                        }
                        if (leftColumn2+col) != x2 {
                            if board.candidatesAt(leftColumn2+col, y1).contains(num) {
                                if !result.contains(y1*9+leftColumn2+col) {
                                    //print("Adding shared horizontal2 square pos: \(y2*9+leftColumn2+col)")
                                    result.append(y1*9+leftColumn2+col)
                                }
                            }
                        }
                    }
                }
            }
        }
        return result
    }

    
    func columnPositionWithNumber(board: BoardHandler, num: Int, x: Int, y: Int) -> Int? {
        var result : [Int] = []
        for col in 0..<9 {
            if col != x && board.candidatesAt(col, y).contains(num) {
                result.append(y*9+col)
            }
        }
        if result.count == 1 {
            return result[0]
        }else {
            return nil
        }
    }
    func squarePositionWithNumber(board: BoardHandler, num: Int, x: Int, y: Int) -> Int? {
        var result : [Int] = []
        let square = board.squareOf(x, y)
        let topRow = Int(square/3)*3
        let leftColumn = (square%3)*3
        for row in 0..<3 {
            for col in 0..<3 {
                if (leftColumn+col != x || topRow+row != y) && board.candidatesAt(leftColumn+col, topRow+row).contains(num) {
                    result.append((topRow+row)*9+leftColumn+col)
                }
            }
        }
        if result.count == 1 {
            return result[0]
        }else {
            return nil
        }
    }

    func colorCandidates(board: BoardHandler, num: Int, x: Int, y: Int, storeNext: Bool, candidates: [Int]) -> [Int] {
        var nextCandidates : [Int] = []
        let rowCandidate = rowPositionWithNumber(board: board, num: num, x: x, y: y)
        let columnCandidate = columnPositionWithNumber(board: board, num: num, x: x, y: y)
        let squareCandidate = squarePositionWithNumber(board: board, num: num, x: x, y: y)
        //print("Colouring with \(storeNext)")
        if let rowCandidate = rowCandidate {
            //print("Detected row candidate at \(rowCandidate%9),\(Int(rowCandidate/9))")
            nextCandidates.append(rowCandidate)
        }
        if let columnCandidate = columnCandidate {
            //print("Detected column candidate at \(columnCandidate%9),\(Int(columnCandidate/9))")
            nextCandidates.append(columnCandidate)
        }
        if let squareCandidate = squareCandidate {
            //print("Detected square candidate at \(squareCandidate%9),\(Int(squareCandidate/9)) based on \(x),\(y)")
            if !nextCandidates.contains(squareCandidate) {
                nextCandidates.append(squareCandidate)
            }
        }

        var result = candidates
        for pos in nextCandidates {
            if !candidates.contains(pos) {
                let row = Int(pos/9)
                let col = pos%9
                if storeNext && !result.contains(pos){
                    //print("Adding \(pos%9),\(Int(pos/9))")
                    result.append(pos)
                }
                result = colorCandidates(board: board, num: num, x: col, y: row, storeNext: !storeNext, candidates: result)
            }
        }
        return result
    }
    
    func arrayPosAsString(_ positions: [Int]) -> String {
        var result = ""
        for p in positions {
            if result.count>0 {
                result = result + ", "
            }
            result = result + "(\(p%9),\(Int(p/9)))"
        }
        return result
    }
    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool {
        let candidates = board.candidatesAt(x, y)
        
        for num in candidates {
            //print("Finding first candidates")
            let firstColorCandidates = colorCandidates(board: board, num: num, x: x, y: y, storeNext: true, candidates: [])
            //print("Finding second candidates")
            let secondColorCandidates = colorCandidates(board: board, num: num, x: x, y: y, storeNext: false, candidates: [])
            var remove = false
            //print("first = \(firstColorCandidates) or \(arrayPosAsString(firstColorCandidates))")
            //print("second = \(secondColorCandidates) or \(arrayPosAsString(secondColorCandidates))")
            for pos in firstColorCandidates {
                //print("Evaluating \(pos%9),\(Int(pos/9))")
                if colidesWithCandidate(board: board, num: num, pos: pos, candidates: firstColorCandidates) {
                    remove = true
                    break
                }
            }
            if remove {
                print("SimpleColouring conflict for \(num) starting at \(x),\(y)")
                for pos in firstColorCandidates {
                    let x = pos%9
                    let y = Int(pos/9)
                    print("Removing \(num) from \(x),\(y)")
                    board.removeCandidate(x: x, y: y, value: num)
                }
                return true
            }
            
            let removePositions = sharedPositions(board: board, num: num, candidates1: firstColorCandidates, candidates2: secondColorCandidates)

            if removePositions.count>0 {
                print("SimpleColouring shared positions for \(num) starting at \(x),\(y)")
                for pos in removePositions {
                    let x = pos%9
                    let y = Int(pos/9)
                    print("Removing \(num) from \(x),\(y)")
                    board.removeCandidate(x: x, y: y, value: num)
                }
                return true
            }
        }
        return false
    }
}
