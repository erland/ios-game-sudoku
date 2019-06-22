//
//  Board.swift
//  Battleship
//
//  Created by Erland Isaksson on 2019-04-29.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import SpriteKit

protocol BoardObserver : class {
    func numberAdded(number: Number)
    func numberRemoved(number: Number)
}
class Board {
    let name: String
    let width: Int = 9
    let height: Int = 9
    let board: Array2D<Number>
    var numbers: Set<Number> = Set()
    var observers: [BoardObserver] = []
    let debug = false
    
    init(name: String) {
        self.name = name
        self.board = Array2D<Number>(columns: width, rows: height)
    }
    
    init(name: String, board: Array2D<Number>) {
        self.name = name
        self.board = board
    }
    
    convenience init(name: String, boardNumbers: String) {
        self.init(name: name)
        for y in 0..<height {
            for x in 0..<width {
                let i = width*y+x
                if boardNumbers.count > i {
                    let ch = boardNumbers[boardNumbers.index(boardNumbers.startIndex, offsetBy: i)]
                    if ch != "_" {
                        if let num = Int(String(ch)) {
                            addPermanentNumber(number: num, x: x, y: y)
                        }
                    }
                }
            }
        }
    }
    
    func attachObserver(_ observer: BoardObserver) {
        for number in numbers {
            observer.numberAdded(number: number)
        }
        observers.append(observer)
    }
    
    func detachObserver(_ observer: BoardObserver) {
        if let index = (self.observers.firstIndex(where: { $0 === observer })) {
            self.observers.remove(at: index)
        }
    }
    
    func atPosition(_ x: Int, _ y: Int) -> Number? {
        if x>=0 && x<width && y>=0 && y<height {
            return board[x, y]
        }else {
            return nil
        }
    }
    
    private func isInsideBoard(_ x: Int, _ y: Int) -> Bool {
        if x<0 || x >= width {
            // Outside board
            if debug {
                print("Outside board")
            }
            return false
        }else if y<0 || y >= height {
            if debug {
                print("Outside board")
            }
            return false
        }
        return true
    }
    
    func removeNumber(x: Int, y: Int) {
        if !isInsideBoard(x, y) {
            return
        }
        if board[x,y] == nil {
            return
        }
        if let n = board[x,y] {
            if !n.permanent {
                board[x,y] = nil
                numbers.remove(n)
                for observer in observers {
                    observer.numberRemoved(number: n)
                }
            }

        }
        
    }
    
    func switchCandidateNumber(number: Int, x: Int, y: Int) {
        if !isInsideBoard(x, y) {
            return
        }
        if board[x,y] != nil && (board[x,y]!.final || board[x,y]!.permanent) {
            // Already occupied
            if debug {
                print("Already occupied")
            }
            return
        }
        var addedNumber : Bool = false
        var n = board[x,y]
        if n == nil {
            addedNumber = true
            n = Number(x, y)
        }
        n?.switchCandidate(number: number)
        
        if addedNumber {
            board[x,y] = n
            numbers.insert(n!)
            for observer in observers {
                observer.numberAdded(number: n!)
            }
        }
    }
    
    func setCandidateNumber(number: Int, x: Int, y: Int) {
        if !isInsideBoard(x, y) {
            return
        }
        if board[x,y] != nil && (board[x,y]!.final || board[x,y]!.permanent) {
            // Already occupied
            if debug {
                print("Already occupied")
            }
            return
        }
        var addedNumber : Bool = false
        var n = board[x,y]
        if n == nil {
            addedNumber = true
            n = Number(x, y)
        }
        n?.setCandidate(number: number)
        
        if addedNumber {
            board[x,y] = n
            numbers.insert(n!)
            for observer in observers {
                observer.numberAdded(number: n!)
            }
        }
    }

    func clearCandidates(x: Int, y: Int) {
        if !isInsideBoard(x, y) {
            return
        }
        if board[x,y] != nil && (board[x,y]!.final || board[x,y]!.permanent) {
            // Already occupied
            if debug {
                print("Already occupied")
            }
            return
        }
        
        if board[x,y] == nil {
            // Already cleared
            return
        }
        for n in 1...9 {
            board[x,y]?.clearCandidate(number: n)
        }
    }

    
    func addFinalNumber(number: Int, x: Int, y: Int, permanent: Bool = false) {
        if !isInsideBoard(x, y) {
            return
        }
        if board[x,y] != nil && (board[x,y]!.final || board[x,y]!.permanent) {
            // Already occupied
            if debug {
                print("Already occupied")
            }
            return
        }
        
        var addedNumber : Bool = false
        var n = board[x,y]
        if n == nil {
            addedNumber = true
            n = Number(x, y)
        }
        n!.final = !permanent
        n!.permanent = permanent
        n!.number = number
        n!.error = !isValidBoard(number: n!)
        if addedNumber {
            board[x,y] = n
            numbers.insert(n!)
            for observer in observers {
                observer.numberAdded(number: n!)
            }
        }
        
        if debug {
            print("Board(\(name)): Added \(number) at: \(x),\(y)")
            debugBoard()
        }
    }
    
    func addPermanentNumber(number: Int, x: Int, y: Int) {
        addFinalNumber(number: number, x: x, y: y, permanent: true)
    }

    
    func isValidBoard(number: Number) -> Bool {
        for y in 0..<height {
            let n = board[number.x,y]
            if n != nil && !(n === number) && n?.number == number.number {
                return false
            }
        }
        for x in 0..<width {
            let n = board[x,number.y]
            if n != nil && !(n === number) && n?.number == number.number {
                return false
            }
        }
        let topLeftX = Int(number.x/3)*3
        let topLeftY = Int(number.y/3)*3
        for y in 0..<3 {
            for x in 0..<3 {
                let n = board[x+topLeftX,y+topLeftY]
                if n != nil && !(n === number) && n?.number == number.number {
                    return false
                }
            }
        }
        return true
    }
    
    func isAllNumbersPlaced() -> Bool {
        var result = true
        for y in 0..<height {
            for x in 0..<width {
                if board[x,y] == nil {
                    result = false
                    break
                }else if !(board[x,y]!.permanent || board[x,y]!.final) {
                    result = false
                    break
                }else if board[x,y]!.error {
                    result = false
                }
            }
            if !result {
                break
            }
        }
        return result
    }
    
    


    func asString() -> String {
        var result = ""
        for y in 0..<height {
            for x in 0..<width {
                if board[x,y] != nil {
                    let n = board[x,y]
                    if n!.permanent || n!.final {
                        result = result + "\(n!.number!)"
                    }else {
                        result = result + "_"
                    }
                }else {
                    result = result + "_"
                }
            }
        }
        return result
    }
    
    func debugBoard(debug: Bool? = nil) {
        if self.debug || (debug != nil && debug!) {
            
            print("Board contents")
            for y in 0..<height {
                for x in 0..<width {
                    if board[x,y] != nil {
                        let n = board[x,y]
                        if n!.permanent || n!.final {
                            print("\(n!.number!)", terminator: "")
                        }else {
                            print("_", terminator: "")
                        }
                    }else {
                        print("_", terminator: "")
                    }
                }
                print()
            }
        }
    }
    
}
