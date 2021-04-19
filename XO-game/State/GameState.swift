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
            ()
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

class GameEndedState: GameState {
    
    let winner: Player?
    unowned let gameViewController: GameViewController
    
    init(winner: Player?, gameViewController: GameViewController) {
        self.winner = winner
        self.gameViewController = gameViewController
    }
    
    var isCompleted: Bool = false
    
    func begin() {
        
        self.gameViewController.winnerLabel.isHidden = false
        if let player = self.winner {
            self.gameViewController.winnerLabel.text = "\(self.winnerName(from: player)) win"
        } else {
            self.gameViewController.winnerLabel.text = "No winner"
        }
        self.gameViewController.firstPlayerTurnLabel.isHidden = true
        self.gameViewController.secondPlayerTurnLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) { }
    
    func winnerName(from player: Player) -> String {
        switch player {
        case .first:
            return "1st player"
        case .second:
            return "2nd player"
        default:
            return "AI"
        }
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
