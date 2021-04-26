//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    var gameModeStrategy: GameModeStrategy!
    var gameMode: GameMode = .pvp
    private let gameboard = Gameboard()    
    lazy var referee = Referee(gameboard: self.gameboard)
    
    var currentState: GameState!{
        didSet {
            self.currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkGameMode()
        self.goToFirstState()
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
            
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        recordEvent(.restartGame)
        goToFirstState()
        self.gameboard.clear()
        self.gameboardView.clear()
    }
    private func goToFirstState() {
        self.currentState = gameModeStrategy.firstState()
    }
    
    private func goToNextState() {
        if let gameIsEndedState = gameModeStrategy.endState() {
            self.currentState = gameIsEndedState
            return
        }
        self.currentState = gameModeStrategy.nextState()
    }
    
    private func checkGameMode() {
        switch gameMode {
        case .pvAI:
            gameModeStrategy = AIGameModeStrategy(gameViewController: self,
                                                  gameboard: gameboard,
                                                  gameboardView: gameboardView,
                                                  referee: referee)
        default:
            gameModeStrategy = PVPGameModeStrategy(gameViewController: self,
                                                   gameboard: gameboard,
                                                   gameboardView: gameboardView,
                                                   referee: referee)
        }
    }
}
