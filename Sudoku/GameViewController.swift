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
                //var boardNumbers = repository.getBoard(difficulty: .VeryHard, level: 1)
                //var boardNumbers = "2____1_49__8____61___7_6528654__9_1__924__6___31___4_2_2_387_5_347195286_8_6_41_7"
                //var boardNumbers = "86793421554312679819258734692641385778465912331527896423174568965839147247986253_"
                // naked pairs
                //var boardNumbers = "597_4__3_348____6_612_9__8475____49_8_9____7_4__6___5_17__2_64_96__83_2_28_____1_"
                // naked triples
                //var boardNumbers = "__3_____1_9__35268__________7____18613_86_725286___943_41_8_3___5_2_6_1______3_7_"
                // naked quad
                //var boardNumbers = "_9________28___9_6___7_9__2____26__43___1_________7__3_1_____59__4_8__31_82__1__7"
                // hidden pair
                //var boardNumbers = "_________9_46_7____768_41__3_97_1_8_7_8___3_1_513_87_2__75_261___54_32_8_________"
                //var boardNumbers = "72_4_8_3__8_____474_1_768_281_739______851______264_8_2_968_41334______8168943275"
                // hidden triples
                //var boardNumbers = "28____473534827196_71_34_8_3__5___4____34__6_46_79_31__9_2_3654__3__9821____8_937"
                //var boardNumbers = "5__62__37__489________5____93________2____6_57_______3_____9_________7__68_57___2"
                // hidden quad
                //var boardNumbers = "816573294392______4572_9__6941___5687854961236238___4_279_____1138____7_564____82"
                var boardNumbers = "_3_____1___8_9____4__6_8______57694____98352____124___276__519____7_9____95___47_"
                let solver = Solver(boardString: boardNumbers)
                solver.printBoard()
                if solver.solve() {
                    print("Solved board")
                    solver.initializeBoard(boardString: solver.solutions[0])
                    solver.printBoard()
                }
                let calculator = DifficultyCalculator(boardString: boardNumbers)
                if calculator.solve(techniques: [DifficultyCalculator.SingleCandidate(),
                                                 DifficultyCalculator.CandidateLines(),
                                                 DifficultyCalculator.HiddenQuad()]) {
                    print("Solved")
                    calculator.printBoard()
                }else {
                    print("Not solved")
                    calculator.printBoard()
                }
                boardNumbers = calculator.asString()
                /*
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
                
                for _ in 0..<50 {
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
                board = Board(name: "Player", boardNumbers: boardNumbers)
                scene.setup(delegate: self, board: board!)
                solver.initializeBoard(boardString: boardNumbers)
                for y in 0..<9 {
                    for x in 0..<9 {
                        let candidates = solver.getCandidates(x, y)
                        for c in candidates {
                            board?.switchCandidateNumber(number: c, x: x, y: y)
                        }
                    }
                }
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
