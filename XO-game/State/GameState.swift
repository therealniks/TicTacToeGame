//
//  GameState.swift
//  XO-game
//
//  Created by v.prusakov on 4/12/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol GameState {
    
    var isCompleted: Bool { get }
    func begin()
    func addMark(at position: GameboardPosition)
}

class PlayerInputState: GameState {
    var isCompleted: Bool = false
    let player: Player
    weak var gameViewController: GameViewController?
    weak var gameboard: Gameboard?
    weak var gameboardView: GameboardView?
    
    init(player: Player, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    func begin() {
        switch player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        case .ai:
            break
        }
        self.gameViewController?.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        guard let gameboardView = self.gameboardView,
              gameboardView.canPlaceMarkView(at: position)
        else { return }
        let mark = self.player == .first ? XView() : OView()
        self.gameboard?.setPlayer(self.player, at: position)
        self.gameboardView?.placeMarkView(mark, at: position)
        self.isCompleted = true
    }
}

class AIInputState: PlayerInputState {
    
    override func begin() {
        self.gameViewController?.firstPlayerTurnLabel.isHidden = true
        self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        self.gameViewController?.secondPlayerTurnLabel.text = "AI"
        self.gameViewController?.winnerLabel.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.move()
        }
    }
    
    override func addMark(at position: GameboardPosition) { }
    
    private func move() {
        let markView = OView()
        if let position = generatePosition() {
            self.gameboard?.setPlayer(self.player, at: position)
            self.gameboardView?.placeMarkView(markView, at: position)
            super.isCompleted = true
        }
    }
    
    func generatePosition()-> GameboardPosition? {
        guard let gameboardView = self.gameboardView else { return nil }
        var row = Int.random(in: 0...2)
        var column = Int.random(in: 0...2)
        var position = GameboardPosition(column: column, row: row)
        while !gameboardView.canPlaceMarkView(at: position) {
            row = Int.random(in: 0...2)
            column = Int.random(in: 0...2)
            position = GameboardPosition(column: column, row: row)
        }
        return position
    }
}

class GameEndedState: GameState {
    
    public let isCompleted = false
    public let winner: Player?
    private(set) weak var gameViewController: GameViewController?
    
    public init(winner: Player?, gameViewController: GameViewController?) {
        self.winner = winner
        self.gameViewController = gameViewController
    }
    
    public func begin() {
        self.gameViewController?.winnerLabel.isHidden = false
        if let winner = winner {
            self.gameViewController?.winnerLabel.text = self.winnerName(from: winner) + " win"
        } else {
            self.gameViewController?.winnerLabel.text = "No winner"
        }
        self.gameViewController?.firstPlayerTurnLabel.isHidden = true
        self.gameViewController?.secondPlayerTurnLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) { }
    
    private func winnerName(from winner: Player) -> String {
        switch winner {
        case .first: return "1st player"
        case .second: return "2nd player"
        case .ai: return "AI"
        }
    }
}
