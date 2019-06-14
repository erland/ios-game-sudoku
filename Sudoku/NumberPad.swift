//
//  NumberPad.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-14.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

class NumberPad : SKSpriteNode {
    var cellSize: CGFloat?
    
    func setup(color: UIColor) {
        self.cellSize = size.width/3

        let gridTexture = NumberPad.createNumberPadGridTexture(x: 3, y: 3, cellSize: cellSize!)
        
        let gridSprite = SKSpriteNode(texture: gridTexture)
        gridSprite.anchorPoint = CGPoint(x: 0.0,y: 1.0)
        gridSprite.position = CGPoint(x: -1.0, y: 1.0)
        gridSprite.zPosition = 15
        addChild(gridSprite)
        for y in 0..<3 {
            for x in 0..<3 {
                let label = SKLabelNode(fontNamed:"Chalkduster")
                label.name = "number"
                label.text = "\(y*3+(x+1))"
                label.fontSize = 50
                label.horizontalAlignmentMode = .center
                label.verticalAlignmentMode = .center
                label.position = CGPoint(x: cellSize!*CGFloat(x)+cellSize!/2, y: -cellSize!*CGFloat(y)-cellSize!/2)
                label.fontColor = color
                addChild(label)
            }
        }

    }
    
    private class func createNumberPadGridTexture(x: Int, y: Int, cellSize: CGFloat) -> SKTexture? {
        let boardWidth = CGFloat(x)*cellSize
        let boardHeight = CGFloat(y)*cellSize
        let border = SKShapeNode.init(rectOf: CGSize(width: boardWidth,
                                                     height: boardHeight))
        border.strokeColor = UIColor.brown
        border.lineWidth = 3
        
        for row in 1..<(y) {
            let line = NumberPad.createLine(anchor: CGPoint(x: -boardWidth/2, y: -boardHeight/2),
                                            from: CGPoint(x: 0.0, y: CGFloat(row)*cellSize),
                                            to: CGPoint(x: boardWidth, y: CGFloat(row)*cellSize))
            line.strokeColor = UIColor.brown
            line.lineWidth = 1
            border.addChild(line)
        }
        for column in 1..<(x) {
            let line = NumberPad.createLine(anchor: CGPoint(x: -boardWidth/2, y: -boardHeight/2),
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
    
    func numberAt(position: CGPoint) -> Int {
        let x = Int((position.x-self.position.x)/cellSize!)
        let y = -Int((position.y-self.position.y)/cellSize!)
        return y*3+(x+1)
    }
    private class func createLine(anchor: CGPoint, from:CGPoint, to: CGPoint) -> SKShapeNode {
        let lineShape = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: anchor.x+from.x, y: anchor.y+from.y))
        path.addLine(to: CGPoint(x: anchor.x+to.x, y: anchor.y+to.y))
        lineShape.path = path
        return lineShape
    }
}
