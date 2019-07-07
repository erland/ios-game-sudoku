//
//  GameDelegate.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-14.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

protocol GameDelegate {
    func selectedOpponent(player: String)
    func selectedDifficulty(difficulty: SudokuRepository.Difficulty?)
    func selectedCompletedBoards()
    func selectedInProgressBoards()
    func selectedBoard(board: Board, startTime: Int)
    func gameComplete(playerName: String, board: Board, seconds: Int, hints: Int)
    func finishedGame()
}
