//
//  SingleGameScene.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-14.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class SingleGameScene: SKScene, BoardObserver {
    var gameDelegate: GameDelegate?
    var boardView : BoardView?
    var eraseButton : SKLabelNode?
    var candidatePad : NumberPad?
    var permanentPad : NumberPad?
    var selectedPos : IntPosition?
    
    func setup(delegate: GameDelegate, board: Board) {
        self.gameDelegate = delegate
        
        self.boardView = childNode(withName: "board") as? BoardView
        self.eraseButton = childNode(withName: "erase") as? SKLabelNode
        self.permanentPad = childNode(withName: "permanent") as? NumberPad
        self.permanentPad?.setup(color: .black)
        self.candidatePad = childNode(withName: "candidate") as? NumberPad
        self.candidatePad?.setup(color: .darkGray)
        print("Setup board view for \(board.name)")
        self.boardView?.setup(board: board)
        
        
        boardView?.board?.attachObserver(self)
    }
    deinit {
        boardView?.board?.detachObserver(self)
    }
    
    override func didMove(to view: SKView) {
        print("Moved to game scene")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        placeNumber(position: touchLocation)
    }
    
    func placeNumber(position: CGPoint) {
        if boardView!.contains(position) {
            selectedPos = boardView?.select(position: position)
        }else if candidatePad!.contains(position) {
            let n = candidatePad?.numberAt(position: position)
            if n != nil {
                if let selectedPos = selectedPos {
                    boardView!.board!.switchCandidateNumber(number: n!, x: selectedPos.x, y: selectedPos.y)
                }
            }
        }else if permanentPad!.contains(position) {
            let n = permanentPad?.numberAt(position: position)
            if n != nil {
                if let selectedPos = selectedPos {
                    boardView!.board!.addFinalNumber(number: n!, x: selectedPos.x, y: selectedPos.y)
                }
            }
        }else if eraseButton!.contains(position) {
            if let selectedPos = selectedPos {
                boardView!.board!.removeNumber(x: selectedPos.x, y: selectedPos.y)
            }
        }
        checkAndProcessGameEnding()
    }
    func checkAndProcessGameEnding() {
        if boardView!.board!.isAllNumbersPlaced() {
            gameDelegate?.gameComplete(playerName: boardView!.board!.name)
        }
        
    }
    
    func numberAdded(number: Number) {
        // TODO: Calculate game over
    }
    func numberRemoved(number: Number) {
        // TODO: Nothing ?
    }

}
