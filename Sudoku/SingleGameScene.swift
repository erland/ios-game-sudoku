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
    var noBackgroundButton : SKShapeNode?
    var greenBackgroundButton : SKShapeNode?
    var yellowBackgroundButton : SKShapeNode?
    var candidatePad : NumberPad?
    var permanentPad : NumberPad?
    var selectedPos : IntPosition?
    var detectCandidatesButton : SKLabelNode?
    var removeCandidatesButton : SKLabelNode?
    var showHintButton : SKLabelNode?
    var quitButton : SKLabelNode?
    var memorizeButton : SKLabelNode?
    var hintName : SKLabelNode?
    var timeText : SKLabelNode?
    var recordLabel : SKLabelNode?
    var recordTime : SKLabelNode?
    var boardName : SKLabelNode?
    var timeCounter : Int = 0
    var memorizedFinalNumbers : String?
    var memorizedCandidateNumbers : String?
    var record : Int?
    var hints = 0

    override func sceneDidLoad() {
        localize()
    }
    
    func setup(delegate: GameDelegate, board: Board, startTime: Int) {
        self.gameDelegate = delegate
        
        self.boardView = childNode(withName: "board") as? BoardView
        self.eraseButton = childNode(withName: "erase") as? SKLabelNode
        self.memorizeButton = childNode(withName: "memory") as? SKLabelNode
        self.quitButton = childNode(withName: "quit") as? SKLabelNode
        self.clearButton = childNode(withName: "clear") as? SKLabelNode
        self.noBackgroundButton = childNode(withName: "white") as? SKShapeNode
        self.greenBackgroundButton = childNode(withName: "green") as? SKShapeNode
        self.yellowBackgroundButton = childNode(withName: "yellow") as? SKShapeNode
        self.boardName = childNode(withName: "boardName") as? SKLabelNode
        self.boardName?.text = board.name
        self.detectCandidatesButton = childNode(withName: "detectCandidates") as? SKLabelNode
        self.removeCandidatesButton = childNode(withName: "removeCandidates") as? SKLabelNode
        self.showHintButton = childNode(withName: "showHint") as? SKLabelNode
        self.hintName = childNode(withName: "hintName") as? SKLabelNode
        self.hintName?.isHidden = true
        self.permanentPad = childNode(withName: "permanent") as? NumberPad
        self.permanentPad?.setup(color: .black)
        self.candidatePad = childNode(withName: "candidate") as? NumberPad
        self.candidatePad?.setup(color: .gray)
        print("Setup board view for \(board.name)")
        self.boardView?.setup(board: board)
        self.timeText = childNode(withName: "time") as? SKLabelNode
        self.recordLabel = childNode(withName: "record") as? SKLabelNode
        self.recordTime = childNode(withName: "recordTime") as? SKLabelNode
        record = BoardStorage().getRecord(board: board)
        if record != nil {
            recordTime?.text = timeAsString(record!)
        }else {
            recordLabel?.isHidden = true
            recordTime?.isHidden = true
        }
        timeCounter = startTime
        displayTime()

        
        boardView?.board?.attachObserver(self)
    }
    deinit {
        boardView?.board?.detachObserver(self)
    }
    
    override func didMove(to view: SKView) {
        print("Moved to game scene")
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimer() {
        timeCounter = timeCounter + 1
        displayTime()
    }
    
    func timeAsString(_ seconds: Int) -> String {
        let hours = Int(seconds/3600)
        let minutes = String(format: "%02d",Int((seconds%3600)/60))
        let seconds = String(format: "%02d",Int(seconds%60))
        if hours == 0 {
            return  "\(minutes):\(seconds)"
        }else {
            return "\(hours):\(minutes):\(seconds)"
        }
    }

    func displayTime() {
        if record != nil && timeCounter>record! {
            timeText?.fontColor = .red
        }
        timeText?.text = "\(timeAsString(timeCounter))"
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
        }else if memorizeButton!.contains(position) {
            if memorizedFinalNumbers != nil {
                restoreBoard()
            }else {
                memorizeBoard()
            }
        }else if quitButton!.contains(position) {
            gameDelegate?.gameComplete(playerName: boardView!.board!.name, board: boardView!.board!, seconds: timeCounter, hints: hints)
        }else if clearButton!.contains(position) {
            clearBoard()
        }else if noBackgroundButton!.contains(position) {
            if let selectedPos = selectedPos {
                boardView!.board!.setBackground(background: .None, x: selectedPos.x, y: selectedPos.y)
            }
        }else if greenBackgroundButton!.contains(position) {
            if let selectedPos = selectedPos {
                boardView!.board!.setBackground(background: .Green, x: selectedPos.x, y: selectedPos.y)
            }
        }else if yellowBackgroundButton!.contains(position) {
            if let selectedPos = selectedPos {
                boardView!.board!.setBackground(background: .Yellow, x: selectedPos.x, y: selectedPos.y)
            }
        }else if eraseButton!.contains(position) {
            if let selectedPos = selectedPos {
                boardView!.board!.removeNumber(x: selectedPos.x, y: selectedPos.y)
            }
        }else if detectCandidatesButton!.contains(position) {
            detectCandidates()
        }else if removeCandidatesButton!.contains(position) {
            removeCandidates()
        }else if showHintButton!.contains(position) {
            showHint()
        }
        checkAndProcessGameEnding()
    }
    func clearBoard() {
        for y in 0..<9 {
            for x in 0..<9 {
                let number = boardView!.board!.atPosition(x, y)
                if number != nil && !(number!.permanent) {
                    boardView!.board!.removeNumber(x: x, y: y)
                }
            }
        }
    }
    func restoreBoard() {
        clearBoard()
        let board = boardView!.board!
        let boardNumbers = memorizedFinalNumbers!
        for y in 0..<9 {
            for x in 0..<9 {
                let i = 9*y+x
                if boardNumbers.count > i {
                    let ch = boardNumbers[boardNumbers.index(boardNumbers.startIndex, offsetBy: i)]
                    if ch != "_" && ch != "0" {
                        if let num = Int(String(ch)) {
                            board.addFinalNumber(number: num, x: x, y: y)
                        }
                    }
                }
            }
        }
        let candidateNumbers = memorizedCandidateNumbers!
        for y in 0..<9 {
            for x in 0..<9 {
                for c in 0..<9 {
                    let i = (9*y+x)*9+c
                    if candidateNumbers.count > i {
                        let ch = candidateNumbers[candidateNumbers.index(candidateNumbers.startIndex, offsetBy: i)]
                        if ch != "_" && ch != "0" {
                            if let num = Int(String(ch)) {
                                board.setCandidateNumber(number: num, x: x, y: y)
                            }
                        }
                    }
                }
            }
        }
        memorizedFinalNumbers = nil
        memorizedCandidateNumbers = nil
        memorizeButton?.text = NSLocalizedString("memorize", comment: "memorize")
    }
    func memorizeBoard() {
        memorizedFinalNumbers = ""
        memorizedCandidateNumbers = ""
        for y in 0..<9 {
            for x in 0..<9 {
                let number = boardView!.board!.atPosition(x, y)
                if let number = number {
                    if number.final {
                        memorizedFinalNumbers = memorizedFinalNumbers! + "\(number.number!)"
                        memorizedCandidateNumbers = memorizedCandidateNumbers! + "_________"
                    }else if number.permanent {
                        memorizedFinalNumbers = memorizedFinalNumbers! + "_"
                        memorizedCandidateNumbers = memorizedCandidateNumbers! + "_________"
                    }else {
                        memorizedFinalNumbers = memorizedFinalNumbers! + "_"
                        for c in 1...9 {
                            if number.candidates[c-1] {
                                memorizedCandidateNumbers = memorizedCandidateNumbers! + "\(c)"
                            }else {
                                memorizedCandidateNumbers = memorizedCandidateNumbers! + "_"
                            }
                        }
                    }
                }else {
                    memorizedFinalNumbers = memorizedFinalNumbers! + "_"
                    memorizedCandidateNumbers = memorizedCandidateNumbers! + "_________"
                }
            }
        }
        memorizeButton?.text=NSLocalizedString("restore", comment: "restore")
    }
    func detectCandidates() {
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
        hints = hints + 1
    }

    func removeCandidates() {
        for y in 0..<9 {
            for x in 0..<9 {
                boardView!.board!.clearCandidates(x: x, y: y)
                boardView!.board!.setBackground(background: .None, x: x, y: y)
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
        hints = hints + 1
        hintName?.isHidden = false
        hintName?.fontColor = UIColor.green
        if solver.solve(technique: SingleCandidate()) {
            print("Showed solution with Single Candidate")
            hintName?.text = "Single Candidate"
        }else if solver.solve(technique: SinglePosition()) {
            print("Showed solution with Single Position")
            hintName?.text = "Single Position"
        }else if solver.solve(technique: CandidateLines()) {
            print("Showed solution with Candidate Lines")
            hintName?.text = "Candidate Line"
        }else if solver.solve(technique: MultipleLines()) {
            print("Showed solution with Multiple Lines")
            hintName?.text = "Multiple Lines"
        }else if solver.solve(technique: NakedPairs()) {
            print("Showed solution with Naked Pair")
            hintName?.text = "Naked Pair"
        }else if solver.solve(technique: NakedTriples()) {
            print("Showed solution with Naked Triples")
            hintName?.text = "Naked Triples"
        }else if solver.solve(technique: NakedQuads()) {
            print("Showed solution with Naked Quads")
            hintName?.text = "Naked Quads"
        }else if solver.solve(technique: HiddenPairs()) {
            print("Showed solution with Hidden Pair")
            hintName?.text = "Hidden Pair"
        }else if solver.solve(technique: HiddenTriples()) {
            print("Showed solution with Hidden Triples")
            hintName?.text = "Hidden Triples"
        }else if solver.solve(technique: HiddenQuads()) {
            print("Showed solution with Hidden Quads")
            hintName?.text = "Hidden Quads"
        }else if solver.solve(technique: XWing()) {
            print("Showed solution with XWing")
            hintName?.text = "X-Wing"
        }else if solver.solve(technique: YWing()) {
            print("Showed solution with YWing")
            hintName?.text = "Y-Wing"
        }else if solver.solve(technique: SwordFish()) {
            print("Showed solution with SwordFish")
            hintName?.text = "Swordfish"
        }else if solver.solve(technique: SimpleColouring()) {
            print("Showed solution with SimpleColoring")
            hintName?.text = "Simple colouring"
        }else {
            hints = hints - 1
            hintName?.fontColor = UIColor.orange
            hintName?.text = NSLocalizedString("noHintAvailable", comment: "noHintAvailable")
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
            gameDelegate?.gameComplete(playerName: boardView!.board!.name, board: boardView!.board!, seconds: timeCounter, hints: hints)
        }
        
    }
    
    func numberAdded(number: Number) {
        // TODO: Calculate game over
    }
    func numberRemoved(number: Number) {
        // TODO: Nothing ?
    }

}
