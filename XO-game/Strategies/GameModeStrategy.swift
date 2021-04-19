//
//  GameModeStrategy.swift
//  XO-game
//
//  Created by N!kS on 19.04.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol GameModeStrategy {
    func firstState() -> GameState?
    func nextState() -> GameState?
    func endState() -> GameState?
}

class PVPGameModeStrategy: GameModeStrategy {
    var player: Player = .first
    weak var gameViewController: GameViewController?
    weak var gameboard: Gameboard?
    weak var gameboardView: GameboardView?
    weak var referee: Referee?
    init(gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, referee: Referee) {
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.referee = referee
    }
    
    func firstState() -> GameState? {
        guard let gameViewController = gameViewController,
              let gameboard = gameboard,
              let gameboardView = gameboardView
        else { return nil }
        player = .first
        return PlayerInputState(player: player,
                                gameViewController: gameViewController,
                                gameboard: gameboard,
                                gameboardView: gameboardView)
    }
    
    func nextState() -> GameState? {
        guard let gameViewController = gameViewController,
              let gameboard = gameboard,
              let gameboardView = gameboardView
        else { return nil }
        player = player.next
        return PlayerInputState(player: player,
                                gameViewController: gameViewController,
                                gameboard: gameboard,
                                gameboardView: gameboardView)
    }
    
    func endState() -> GameState? {
        guard let gameViewController = gameViewController,
              let referee = referee
        else { return nil }
        let winner = referee.determineWinner()
        return GameEndedState(winner: winner,
                              gameViewController: gameViewController)
        
    }
    
}

class AIGameModeStrategy: GameModeStrategy {
    var player: Player = .first
    weak var gameViewController: GameViewController?
    weak var gameboard: Gameboard?
    weak var gameboardView: GameboardView?
    weak var referee: Referee?
    init(gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, referee: Referee) {
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.referee = referee
    }

    func firstState() -> GameState? {
        guard let gameViewController = gameViewController,
              let gameboard = gameboard,
              let gameboardView = gameboardView
        else { return nil }
        player = .first
        return PlayerInputState(player: player,
                                gameViewController: gameViewController,
                                gameboard: gameboard,
                                gameboardView: gameboardView)
    }

    func nextState() -> GameState? {
        guard let gameViewController = gameViewController,
              let gameboard = gameboard,
              let gameboardView = gameboardView
        else { return nil }
        if player == .ai {
            player = .first
            return PlayerInputState(player: player,
                                    gameViewController: gameViewController,
                                    gameboard: gameboard,
                                    gameboardView: gameboardView)
        } else {
            player = .ai
            return AIInputState(player: player,
                                gameViewController: gameViewController,
                                gameboard: gameboard,
                                gameboardView: gameboardView)
        }
    }

    func endState() -> GameState? {
        guard let gameViewController = gameViewController,
              let referee = referee
        else { return nil }
        let winner = referee.determineWinner()
        return GameEndedState(winner: winner,
                              gameViewController: gameViewController)
    }
}
