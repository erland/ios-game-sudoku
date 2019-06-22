//
//  BoardView.swift
//  Battleship
//
//  Created by Erland Isaksson on 2019-05-01.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

struct IntPosition {
    let x : Int
    let y : Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

class BoardView : SKSpriteNode, BoardObserver {
    
    var board: Board?
    var cellSize: CGFloat?
    var scale: CGFloat?
    var selectedCell : SKShapeNode?
    var solverCells : [SKShapeNode] = []
    
    func setup(board: Board) {
        self.cellSize = size.width/CGFloat(board.width)
        print("\(size.width) with \(board.width) gives cellSize=\(cellSize!)")
        self.board = board
        self.scale = cellSize!/50.0
        let gridTexture = BoardView.createBoardGridTexture(x: board.width, y: board.height, cellSize: cellSize!)
        
        let gridSprite = SKSpriteNode(texture: gridTexture)
        gridSprite.anchorPoint = CGPoint(x: 0.0,y: 1.0)
        gridSprite.position = CGPoint(x: -1.0, y: 1.0)
        gridSprite.zPosition = 15
        addChild(gridSprite)
        
        board.attachObserver(self)
    }
    
    private class func createBoardGridTexture(x: Int, y: Int, cellSize: CGFloat) -> SKTexture? {
        let boardWidth = CGFloat(x)*cellSize
        let boardHeight = CGFloat(y)*cellSize
        let border = SKShapeNode.init(rectOf: CGSize(width: boardWidth,
                                                     height: boardHeight))
        border.strokeColor = UIColor.brown
        border.lineWidth = 3
        
        for row in 1..<(y) {
            let line = BoardView.createLine(anchor: CGPoint(x: -boardWidth/2, y: -boardHeight/2),
                                            from: CGPoint(x: 0.0, y: CGFloat(row)*cellSize),
                                            to: CGPoint(x: boardWidth, y: CGFloat(row)*cellSize))
            line.strokeColor = UIColor.brown
            line.lineWidth = 1
            if row == 3 || row == 6 {
                line.lineWidth = 3
            }
            border.addChild(line)
        }
        for column in 1..<(x) {
            let line = BoardView.createLine(anchor: CGPoint(x: -boardWidth/2, y: -boardHeight/2),
                                            from: CGPoint(x: CGFloat(column)*cellSize, y: 0),
                                            to: CGPoint(x: CGFloat(column)*cellSize, y: boardHeight))
            line.strokeColor = UIColor.brown
            line.lineWidth = 1
            if column == 3 || column == 6 {
                line.lineWidth = 3
            }
            border.addChild(line)
        }
        let view = SKView(frame: CGRect(x: 0, y: 0, width: boardWidth, height: boardHeight))
        return view.texture(from: border)
    }
    
    private class func createLine(anchor: CGPoint, from:CGPoint, to: CGPoint) -> SKShapeNode {
        let lineShape = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: anchor.x+from.x, y: anchor.y+from.y))
        path.addLine(to: CGPoint(x: anchor.x+to.x, y: anchor.y+to.y))
        lineShape.path = path
        return lineShape
    }
    
    func numberAdded(number: Number) {
        let numberView = NumberView(number: number, cellSize: cellSize!)
        numberView.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        numberView.name = "number"
        numberView.zPosition = 20
        addChild(numberView)
    }
    func numberRemoved(number: Number) {
        if let numberView = viewForNumber(number: number) {
            numberView.removeFromParent()
        }
    }

    func select(position: CGPoint) ->  IntPosition? {
        if self.contains(position) {
            let x = Int((position.x-self.position.x)/cellSize!)
            let y = -Int((position.y-self.position.y)/cellSize!)
            select(x: x, y: y)
            return IntPosition(x,y)
        }
        return nil
    }
    func select(x: Int, y: Int) -> IntPosition? {
        if selectedCell != nil {
            selectedCell?.removeFromParent()
            selectedCell = nil
        }
        selectedCell = SKShapeNode(rectOf: CGSize(width: cellSize!, height: cellSize!), cornerRadius: cellSize!/8)
        selectedCell?.strokeColor = .orange
        selectedCell?.lineWidth = 5
        selectedCell?.position.x = CGFloat(x)*cellSize!+cellSize!/2
        selectedCell?.position.y = -CGFloat(y)*cellSize!-cellSize!/2
        selectedCell?.zPosition = 20
        if let n = board?.atPosition(x,y) {
            if n.permanent {
                selectedCell?.strokeColor = .gray
            }
        }
        addChild(selectedCell!)
        return IntPosition(x,y)
    }
    
    func clearSolverCells() {
        for shape in solverCells {
            shape.removeFromParent()
        }
        solverCells.removeAll()
    }
    func addSolverCellValue(x: Int, y: Int) {
        let solverCell = SKShapeNode(rectOf: CGSize(width: cellSize!, height: cellSize!), cornerRadius: cellSize!/8)
        solverCell.strokeColor = .green
        solverCell.lineWidth = 5
        solverCell.position.x = CGFloat(x)*cellSize!+cellSize!/2
        solverCell.position.y = -CGFloat(y)*cellSize!-cellSize!/2
        solverCell.zPosition = 30
        solverCells.append(solverCell)
        addChild(solverCell)
    }
    
    func addSolverCellCandidate(x: Int, y: Int) {
        let solverCell = SKShapeNode(rectOf: CGSize(width: cellSize!, height: cellSize!), cornerRadius: cellSize!/8)
        solverCell.strokeColor = .green
        solverCell.lineWidth = 3
        solverCell.position.x = CGFloat(x)*cellSize!+cellSize!/2+1
        solverCell.position.y = -CGFloat(y)*cellSize!-cellSize!/2-1
        solverCell.zPosition = 30
        solverCells.append(solverCell)
        addChild(solverCell)
    }

    func viewForNumber(number: Number) -> NumberView? {
        var result: NumberView?
        enumerateChildNodes(withName: "number") {
            (node, stop) in
            if node is NumberView {
                let numberView  = node as! NumberView
                if numberView.number === number {
                    result = numberView
                }
            }
        }
        return result
    }
}

