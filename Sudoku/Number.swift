//
//  Number.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-14.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//


import SpriteKit

protocol NumberObserver {
    func numberUpdated(number: Number)
}

enum NumberColor {
    case Green
    case Yellow
    case None
}
class Number : Hashable, NSCopying {
    var observers: [NumberObserver] = []
    var candidates : [Bool] = [false, false, false, false, false, false, false, false, false, false]
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
        self.final = false
        self.permanent = false
        self.error = false
        self.background = .None
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Number(self.x,self.y)
        copy.permanent = self.permanent
        copy.final = self.final
        copy.background = self.background
        
        return copy
    }
    
    func switchCandidate(number: Int) {
        if number>0 && number<=9 {
            candidates[number-1] = !candidates[number-1]
            notifyObservers()
        }
    }
    func setCandidate(number: Int) {
        if number>0 && number<=9 {
            candidates[number-1] = true
            notifyObservers()
        }
    }
    func clearCandidate(number: Int) {
        if number>0 && number<=9 {
            candidates[number-1] = false
            notifyObservers()
        }
    }
    func clearCandidates() {
        for number in 1...9 {
            candidates[number-1] = false
        }
        notifyObservers()
    }

    func getCandidates() -> [Int] {
        var result : [Int] = []
        for i in 0..<9 {
            if candidates[i] {
                result.append(i+1)
            }
        }
        return result
    }
    
    func attachObserver(observer: NumberObserver) {
        observers.append(observer)
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.numberUpdated(number: self)
        }
    }
    var x: Int {
        didSet {
            notifyObservers()
        }
    }
    var y: Int {
        didSet {
            notifyObservers()
        }
    }
    var number: Int? {
        didSet {
            notifyObservers()
        }
    }
    var permanent: Bool {
        didSet {
            notifyObservers()
        }
    }
    var error: Bool {
        didSet {
            notifyObservers()
        }
    }
    var final: Bool {
        didSet {
            notifyObservers()
        }
    }
    var background : NumberColor {
        didSet {
            notifyObservers()
        }
    }

    static func == (lhs: Number, rhs: Number) -> Bool {
        return lhs === rhs
    }
    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
}

