//
//  MainViewController.swift
//  XO-game
//
//  Created by N!kS on 16.04.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectGameMode: UISegmentedControl!
    private var selectedGameMode: GameMode = .pvp
    
    
    @IBAction func checkGameMode(_ sender: UISegmentedControl) {
        switch selectGameMode.selectedSegmentIndex {
        case 1:
            selectedGameMode = .pvAI
        case 2:
            selectedGameMode = .strategy
        default:
            selectedGameMode = .pvp
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    private func setupView() {
        let text = "Tic Tac Toe Game"
        titleLabel.text = text
        //selectGameMode.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameViewController,
           let id = segue.identifier,
           id == "startGame"
        {
            destination.gameMode = selectedGameMode
        }
    }
}
