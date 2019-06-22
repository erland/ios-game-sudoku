//
//  Solver.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-16.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation

class BruteForceSolverBoard : AbstractSolverBoard {
    var solutions : Array<String> = []

    convenience init() {
        self.init(boardString: "_________________________________________________________________________________")
    }
    init(boardString: String) {
        super.init(boardString: boardString, debug: false, candidates: false)
    }
    
    func solve() -> Bool {
        solutions.removeAll()
        solve(0,0)
        return solutions.count == 1
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
    override func setValue(x: Int, y: Int, value: Int, present: Bool) {
        board[y*9+x] = value
        rows[y][value - 1] = present
        columns[x][value - 1] = present
        squares[squareOf(x,y)][value - 1] = present
    }
}
