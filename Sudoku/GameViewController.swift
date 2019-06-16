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
        startSingleGame()
    }
    
    func selectedOpponent(player: String) {
        //TOOD: Implement
    }
    
    func gameComplete(playerName: String) {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SingleGameOverScene") as? SingleGameOverScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                scene.setup(delegate: self, board: board!)
                
                view.presentScene(scene)
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.ignoresSiblingOrder = true
            startSingleGame()
        }
    }

    func startSingleGame() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "SingleGameScene") as? SingleGameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                //board = Board(name: "Player", boardNumbers: "2____1_49__8____61___7_6528654__9_1__924__6___31___4_2_2_387_5_347195286_8_6_41_7")
                //board = Board(name: "Player", boardNumbers: "86793421554312679819258734692641385778465912331527896423174568965839147247986253_")
                let repository = SudokuRepository()
                var boardNumbers = repository.getBoard(difficulty: .Easy, level: 1)
                while true {
                    let solver = Solver()
                    let str = solver.generate()
                    if let str = str {
                        let count = str.characters.filter { $0 == "_" }.count
                        if count>51 {
                            boardNumbers = str
                            break
                        }
                    }
                }
                board = Board(name: "Player", boardNumbers: boardNumbers)
                /*
                for _ in 0..<1000 {
                    let solver = Solver()
                    let str = solver.generate()
                    if let str = str {
                        let count = str.characters.filter { $0 == "_" }.count
                        if count>50 {
                            print("Board with: \(81-count) numbers")
                            solver.initializeBoard(boardString: str)
                            solver.printBoard()
                        }
                    }
                }
 */

                scene.setup(delegate: self, board: board!)
                /*
                 board.switchCandidateNumber(number: 1, x: 1, y: 1)
                 board.switchCandidateNumber(number: 2, x: 1, y: 1)
                 board.switchCandidateNumber(number: 3, x: 1, y: 1)
                 board.switchCandidateNumber(number: 4, x: 1, y: 1)
                 board.switchCandidateNumber(number: 5, x: 1, y: 1)
                 board.switchCandidateNumber(number: 6, x: 1, y: 1)
                 board.switchCandidateNumber(number: 7, x: 1, y: 1)
                 board.switchCandidateNumber(number: 8, x: 1, y: 1)
                 board.switchCandidateNumber(number: 9, x: 1, y: 1)
                 board.addFinalNumber(number: 5, x: 0, y: 1)
                 */
                // Present the scene
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
