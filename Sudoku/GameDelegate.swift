//
//  GameDelegate.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-14.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

protocol GameDelegate {
    //func addOpponent(player: String)
    //func removeOpponent(player: String)
    func selectedOpponent(player: String)
    func selectedDifficulty(difficulty: SudokuRepository.Difficulty?)
    func selectedCompletedBoards()
    func selectedInProgressBoards()
    func selectedBoard(board: Board, startTime: Int)
    //func readyToPlay(player: String, state: Marker.State)
    func gameComplete(playerName: String, board: Board, seconds: Int)
    func finishedGame()
    //func skipPlaceMarker(playerName: String)
    //func placeMarker(playerName: String, x: Int, state: Marker.State)
    //func placeMarkerConfirmed(playerName: String, x: Int, state: Marker.State)
}
