//
//  BoardStorage.swift
//  Sudoku
//
//  Created by Erland Isaksson on 2019-06-23.
//  Copyright © 2019 Erland Isaksson. All rights reserved.
//

import Foundation

struct StoredBoard : Codable {
    let name : String
    let seconds : Int
    let permanent : String
    let final : String
    let candidates : String
}

struct BoardRecord : Codable {
    let permanent : String
    let seconds : Int
}

class BoardStorage {

    func initializeBoard(_ storedBoard: StoredBoard) -> Board {
        let board = Board(name: storedBoard.name, boardNumbers: storedBoard.permanent)
        let boardNumbers = storedBoard.final
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
        let candidateNumbers = storedBoard.candidates
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
        return board

    }
    func getCompletedBoards() -> [StoredBoard] {
        return loadData(StoredBoard.self, forKey: "completed")
    }
    
    func getBoardsInProgress() -> [StoredBoard] {
        return loadData(StoredBoard.self, forKey: "inProgress")
    }
    
    func storeBoardInProgress(board: Board, seconds: Int) {
        let storedBoard = serializeBoard(board: board, seconds: seconds)
        var boards = loadData(StoredBoard.self, forKey: "inProgress")
        for (i,b) in boards.enumerated() {
            if b.permanent == storedBoard.permanent {
                boards.remove(at: i)
                break
            }
        }
        boards.insert(storedBoard, at: 0)
        while boards.count>60 {
            boards.remove(at: boards.count-1)
        }
        storeData(boards, forKey: "inProgress")
    }
    
    func removeBoardInProgress(storedBoard: StoredBoard) {
        var boards = loadData(StoredBoard.self, forKey: "inProgress")
        var removed = false
        for (i,b) in boards.enumerated() {
            if b.permanent == storedBoard.permanent {
                boards.remove(at: i)
                removed = true
                break
            }
        }
        if removed {
            storeData(boards, forKey: "inProgress")
        }
    }
    
    func storeCompletedBoard(board: Board, seconds: Int) {
        let storedBoard = serializeBoard(board: board, seconds: seconds, onlyPermanent: true)
        registerRecord(boardNumbers: storedBoard.permanent, seconds: seconds)
        var boards = loadData(StoredBoard.self, forKey: "completed")
        for (i,b) in boards.enumerated() {
            if b.permanent == storedBoard.permanent {
                boards.remove(at: i)
                break
            }
        }
        boards.insert(storedBoard, at: 0)
        while boards.count>60 {
            boards.remove(at: boards.count-1)
        }
        storeData(boards, forKey: "completed")
        removeBoardInProgress(storedBoard: storedBoard)
    }
    
    func serializeBoard(board: Board, seconds: Int, onlyPermanent: Bool = false) -> StoredBoard {
        var permanent = ""
        var final = ""
        var candidates = ""
        for y in 0..<9 {
            for x in 0..<9 {
                let n = board.atPosition(x, y)
                if n == nil {
                    candidates = candidates + "_________"
                    permanent = permanent + "_"
                    final = final + "_"
                }else if n!.permanent {
                    candidates = candidates + "_________"
                    permanent = permanent + "\(n!.number!)"
                    final = final + "_"
                }else if n!.final {
                    candidates = candidates + "_________"
                    permanent = permanent + "_"
                    final = final + "\(n!.number!)"
                }else {
                    for c in 1...9 {
                        if n!.candidates[c-1] {
                            candidates = candidates + "\(c)"
                        }else {
                            candidates = candidates + "_"
                        }
                    }
                    permanent = permanent + "_"
                    final = final + "_"
                }
            }
        }
        if onlyPermanent {
            return StoredBoard.init(name: board.name, seconds: seconds, permanent: permanent, final: "", candidates: "")
        }else {
            return StoredBoard.init(name: board.name, seconds: seconds, permanent: permanent, final: final, candidates: candidates)
        }
    }
    func registerRecord(boardNumbers: String, seconds: Int) {
        
        var records = loadData(BoardRecord.self, forKey: "records")
        var shouldBeAdded = true
        for (i,r) in records.enumerated() {
            if r.permanent == boardNumbers {
                if r.seconds < seconds {
                    shouldBeAdded = false
                }else {
                    records.remove(at: i)
                }
                break
            }
        }
        if shouldBeAdded {
            records.append(BoardRecord.init(permanent: boardNumbers, seconds: seconds))
        }
        storeData(records, forKey: "records")
    }

    func getRecord(boardNumbers: String) -> Int? {
        
        let records = loadData(BoardRecord.self, forKey: "records")
        for r in records {
            if r.permanent == boardNumbers {
                return r.seconds
            }
        }
        return nil
    }

    func getInProgress(boardNumbers: String) -> Int? {
        
        let started = loadData(BoardRecord.self, forKey: "inProgress")
        for b in started {
            if b.permanent == boardNumbers {
                return b.seconds
            }
        }
        return nil
    }

    func storeData<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        UserDefaults.standard.set(data, forKey: defaultName)
    }
    
    func loadData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = UserDefaults.standard.array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
    
}
