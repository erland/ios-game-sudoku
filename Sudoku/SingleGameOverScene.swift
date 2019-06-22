//
//  SingleGameOverScene.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-14.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class SingleGameOverScene: SKScene {
    var gameDelegate: GameDelegate?
    var boardView: BoardView?
    var openedTime: TimeInterval?
    var status: SKLabelNode?
    
    func setup(delegate: GameDelegate, board: Board) {
        self.gameDelegate = delegate
        
        self.boardView = childNode(withName:"board") as? BoardView
        self.status = childNode(withName:"status") as? SKLabelNode
        self.boardView?.setup(board: board)
        if boardView!.board!.isAllNumbersPlaced() {
            status?.text = "Congratulations!"
        }else {
            status?.text = "Not completed"
        }
    }
    
    override func didMove(to view: SKView) {
        openedTime = NSDate().timeIntervalSince1970
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // We need to ensure the sceen is shown for 2 seconds before we allow player to continue
        if openedTime!<NSDate().timeIntervalSince1970-2 {
            gameDelegate?.finishedGame()
        }
    }
}
