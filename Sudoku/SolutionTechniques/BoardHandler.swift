//
//  BoardHandler.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-21.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

protocol BoardHandler {
    func squareOf(_ x:Int, _ y:Int) -> Int
    func setValue(x: Int, y: Int, value: Int, present: Bool)
    func valueAt(_ x: Int, _ y: Int) -> Int?
    func isValid(x: Int, y: Int, value: Int) -> Bool
    func candidatesAt(_ x: Int, _ y: Int) -> [Int]
    func removeCandidate(x: Int, y: Int, value: Int)
}

