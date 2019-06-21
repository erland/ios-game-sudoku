//
//  SolverTechnique.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

protocol SolverTechnique {
    func solvePosition(board: BoardHandler, x: Int, y: Int) -> Bool
}
