//
//  GameOverViewController.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 18.05.2021.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var restartButton: CustomButton!
    @IBOutlet weak var returnToMainMenu: CustomButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var enableAutopilotSwicher: UISwitch!
    
    var score = 0
    
    var closure: ((Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        scoreLabel.text = "Score: \(score)"
    }
    
    @IBAction func enabledAutopilot(_ sender: UISwitch) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restartButton.layer.cornerRadius = restartButton.frame.height / 2
        returnToMainMenu.layer.cornerRadius = returnToMainMenu.frame.height / 2
    }
    
    @IBAction func restartButtonAction(_ sender: UIButton) {
        dismiss(animated: true) { [self] in
            self.closure?(false)
        }
    }
    
    @IBAction func returnToMainMenuButtonAction(_ sender: UIButton) {
        dismiss(animated: true) { [self] in
            self.closure?(true)
        }
    }
    
}
