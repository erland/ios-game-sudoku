//
//  GameViewController.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-14.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameDelegate {
    var board: Board?

    func finishedGame() {
        selectDifficulty()
    }
    
    func selectedOpponent(player: String) {
        //TOOD: Implement
    }
    
    func gameComplete(playerName: String, board: Board) {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SingleGameOverScene") as? SingleGameOverScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                scene.setup(delegate: self, board: board)
                
                view.presentScene(scene)
            }
        }
    }
    

    
    func selectedDifficulty(difficulty: SudokuRepository.Difficulty?) {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SelectLevelScene") as? SelectLevelScene {
                scene.setup(delegate: self, difficulty: difficulty)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                view.presentScene(scene)
            }
        }
    }
    
    func selectedBoard(board: Board) {
        startSingleGame(board: board)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectDifficulty()
    }

    func selectDifficulty() {
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            
            if let scene = SKScene(fileNamed: "SelectDifficultyScene") as? SelectDifficultyScene {
                scene.setup(delegate: self)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                view.presentScene(scene)
            }
        }

    }
    func startSingleGame(board: Board) {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SingleGameScene") as? SingleGameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                scene.setup(delegate: self, board: board)

                view.presentScene(scene)
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
