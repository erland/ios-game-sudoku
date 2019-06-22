//
//  BoardGenerator.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-22.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation

class BoardGenerator : BruteForceSolverBoard {
    func generateWithLimits(tooEasyTechniques: [SolverTechnique] = [], maxTechniques: [SolverTechnique] = [], maxNumbers: Int = 0, timeoutSeconds: TimeInterval) -> String? {
        var board : String?
        
        let expirationTime = Date(timeIntervalSinceNow: timeoutSeconds)
        var filledBoard = generateFilledBoard()
        var i = 0
        while board == nil && expirationTime>Date(){
            let positions = (0..<81).shuffled()
            if i>10 {
                filledBoard = generateFilledBoard()
                i = 0
            }
            initializeBoard(boardString: filledBoard!)
            board = generate(positions: positions, boardString: filledBoard!)
            if board != nil {
                let numbers = 81 - board!.characters.filter { $0 == "_" }.count
                print("Generated board with \(numbers) numbers")
                if maxNumbers <= 0 || numbers<=maxNumbers {
                    print("Checking generated board with \(numbers) numbers")
                    AbstractSolverBoard(boardString: board!, debug: false, candidates: false).printBoard()
                    if tooEasyTechniques.count > 0 {
                        if TechniqueSolverBoard(boardString: board!, debug: false).solve(techniques: tooEasyTechniques) {
                            print("Discarding too easy board with \(numbers) numbers")
                            board = nil
                        }
                    }
                    if board != nil && maxTechniques.count > 0 {
                        if !TechniqueSolverBoard(boardString: board!, debug: false).solve(techniques: maxTechniques) {
                            print("Discarding too hard board with \(numbers) numbers")
                            board = nil
                        }
                    }
                }else {
                    board = nil
                }
            }
            i = i + 1
        }
        return board
    }
    
    func generateFilledBoard() -> String? {
        let n = [1,2,3,4,5,6,7,8,9].shuffled()
        
        initializeBoard(boardString: "\(n[0])\(n[1])\(n[2])\(n[3])\(n[4])\(n[5])\(n[6])\(n[7])\(n[8])________________________________________________________________________")
        solve()
        if solutions.count>0 {
            return solutions[0]
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
    

}
