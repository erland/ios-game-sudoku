//
//  SingleGameScene.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-14.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit
import GameplayKit

class SingleGameScene: SKScene, BoardObserver, SolverObserver {
    var gameDelegate: GameDelegate?
    var boardView : BoardView?
    var eraseButton : SKLabelNode?
    var clearButton : SKLabelNode?
    var candidatePad : NumberPad?
    var permanentPad : NumberPad?
    var selectedPos : IntPosition?
    var showCandidatesButton : SKLabelNode?
    var resetCandidates = false
    var showHintButton : SKLabelNode?
    var hintName : SKLabelNode?

    func setup(delegate: GameDelegate, board: Board) {
        self.gameDelegate = delegate
        
        self.boardView = childNode(withName: "board") as? BoardView
        self.eraseButton = childNode(withName: "erase") as? SKLabelNode
        self.clearButton = childNode(withName: "clear") as? SKLabelNode
        self.showCandidatesButton = childNode(withName: "showCandidates") as? SKLabelNode
        self.showHintButton = childNode(withName: "showHint") as? SKLabelNode
        self.hintName = childNode(withName: "hintName") as? SKLabelNode
        self.hintName?.isHidden = true
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
        boardView?.clearSolverCells()
        hintName?.isHidden = true
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
        }else if clearButton!.contains(position) {
            for y in 0..<9 {
                for x in 0..<9 {
                    let number = boardView!.board!.atPosition(x, y)
                    if number != nil && !(number!.permanent) {
                        boardView!.board!.removeNumber(x: x, y: y)
                    }
                }
            }
            resetCandidates = false
            showCandidatesButton?.text = "Generate"
        }else if showCandidatesButton!.contains(position) {
            showCandidates()
        }else if showHintButton!.contains(position) {
            showHint()
        }
        checkAndProcessGameEnding()
    }
    func showCandidates() {
        if resetCandidates {
            resetCandidates = false
            showCandidatesButton?.text = "Generate"
            for y in 0..<9 {
                for x in 0..<9 {
                    boardView!.board!.clearCandidates(x: x, y: y)
                }
            }
        }else {
            showCandidatesButton?.text = "Remove"
            resetCandidates = true
            let boardString = boardView!.board!.asString()
            let solver = AbstractSolverBoard(boardString: boardString, debug: false)
            solver.resetCandidates()
            for y in 0..<9 {
                for x in 0..<9 {
                    boardView!.board!.clearCandidates(x: x, y: y)
                    for n in solver.candidatesAt(x, y) {
                        boardView!.board!.setCandidateNumber(number: n, x: x, y: y)
                    }
                }
            }
        }
    }
    
    func showHint() {
        boardView?.clearSolverCells()
        let boardString = boardView!.board!.asString()
        let solver = TechniqueSolverBoard(boardString: boardString, debug: false)
        solver.resetCandidates()
        for y in 0..<9 {
            for x in 0..<9 {
                let n = boardView!.board!.atPosition(x, y)
                if n != nil {
                    for c in solver.candidatesAt(x, y) {
                        if !(n!.getCandidates().contains(c)) {
                            solver.removeCandidate(x: x, y: y, value: c)
                        }
                    }
                }
            }
        }
        solver.attachObserver(self)
        if solver.solve(technique: SingleCandidate()) {
            print("Showed solution with Single Candidate")
            hintName?.text = "Single Candidate"
            hintName?.isHidden = false
        }else if solver.solve(technique: SinglePosition()) {
            print("Showed solution with Single Position")
            hintName?.text = "Single Position"
            hintName?.isHidden = false
        }else if solver.solve(technique: CandidateLines()) {
            print("Showed solution with Candidate Lines")
            hintName?.text = "Candidate Line"
            hintName?.isHidden = false
        }else if solver.solve(technique: MultipleLines()) {
            print("Showed solution with Multiple Lines")
            hintName?.text = "Multiple Lines"
            hintName?.isHidden = false
        }else if solver.solve(technique: NakedPairs()) {
            print("Showed solution with Naked Pair")
            hintName?.text = "Naked Pair"
            hintName?.isHidden = false
        }else if solver.solve(technique: NakedTriples()) {
            print("Showed solution with Naked Triples")
            hintName?.text = "Naked Triples"
            hintName?.isHidden = false
        }else if solver.solve(technique: NakedQuads()) {
            print("Showed solution with Naked Quads")
            hintName?.text = "Naked Quads"
            hintName?.isHidden = false
        }else if solver.solve(technique: HiddenPairs()) {
            print("Showed solution with Hidden Pair")
            hintName?.text = "Hidden Pair"
            hintName?.isHidden = false
        }else if solver.solve(technique: HiddenTriples()) {
            print("Showed solution with Hidden Triples")
            hintName?.text = "Hidden Triples"
            hintName?.isHidden = false
        }else if solver.solve(technique: HiddenQuads()) {
            print("Showed solution with Hidden Quads")
            hintName?.text = "Hidden Quads"
            hintName?.isHidden = false
        }else if solver.solve(technique: XWing()) {
            print("Showed solution with XWing")
            hintName?.text = "X-Wing"
            hintName?.isHidden = false
        }else if solver.solve(technique: YWing()) {
            print("Showed solution with YWing")
            hintName?.text = "Y-Wing"
            hintName?.isHidden = false
        }else {
            self.hintName?.isHidden = true
        }
    }
    
    func solverRemovedCandidate(x: Int, y: Int, value: Int) {
        boardView?.addSolverCellCandidate(x: x, y: y)
    }
    
    func solverSetValue(x: Int, y: Int, value: Int) {
        selectedPos = boardView?.select(x: x, y: y)
        boardView?.addSolverCellValue(x: x, y: y)
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
