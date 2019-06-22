//
//  SelectLevelScene.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-22.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

class SelectLevelScene: SKScene {
    var gameDelegate: GameDelegate?
    
    var boards : [BoardView] = []
    var loadingText : SKLabelNode?
    
    func setup(delegate: GameDelegate, difficulty: SudokuRepository.Difficulty?) {
        self.gameDelegate = delegate
        
        loadingText = childNode(withName:"loading") as? SKLabelNode
        
        for i in 1...12 {
            let boardView = childNode(withName:"board\(i)") as? BoardView
            if let boardView = boardView {
                boardView.isHidden = true
                boards.append(boardView)
            }
        }
        DispatchQueue.global().asyncAfter(deadline: .now(), execute: {
            let repository = SudokuRepository()
            if let difficulty = difficulty {
                for i in 1...12 {
                    let boardNumbers = repository.getBoard(difficulty: difficulty, level: i)
                    if boardNumbers != nil {
                        DispatchQueue.main.async {
                            let board = Board.init(name: "Player", boardNumbers: boardNumbers!)
                            self.boards[i-1].setup(board: board)
                            self.boards[i-1].alpha = 0.3
                            self.boards[i-1].isHidden = false
                        }
                    }
                }
                DispatchQueue.main.async {
                    for i in 0..<12 {
                        if self.boards[i].alpha > 0.1 {
                            self.boards[i].alpha = 1.0
                        }
                    }
                    self.loadingText?.isHidden = true
                }
            }else {
                for i in 1...12 {
                    let boardNumbers = repository.getGeneratedBoard()
                    if boardNumbers != nil {
                        DispatchQueue.main.async {
                            let board = Board.init(name: "Player", boardNumbers: boardNumbers!)
                            self.boards[i-1].setup(board: board)
                            self.boards[i-1].alpha = 0.3
                            self.boards[i-1].isHidden = false
                        }
                    }
                }
                DispatchQueue.main.async {
                    for i in 0..<12 {
                        if self.boards[i].alpha > 0.1 {
                            self.boards[i].alpha = 1.0
                        }
                    }
                    self.loadingText?.isHidden = true
                }
            }
        })
        
    }
    
    override func didMove(to view: SKView) {
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        for i in 0..<12 {
            if boards[i].contains(touchLocation) {
                if boards[i].board != nil {
                    gameDelegate?.selectedBoard(board: boards[i].board!)
                    break
                }
            }
        }
    }
}
