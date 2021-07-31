//
//  MainMenuViewController.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 05.05.2021.
//

import UIKit

class MainMenuViewController: CustomViewController {

    //MARK: IBOutlets:
    @IBOutlet weak var playGameButton: CustomButton!
    @IBOutlet weak var tableScoreButton: CustomButton!
    @IBOutlet weak var settingButton: CustomButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    private let userDefaults = UserDefaults.standard
    enum OpeningScreen {
        case playScreen
        case tableScoreScreen
        case settingsScreen
    }
    
    //MARK: Life cycles:
    override func viewDidLoad() {
        super.viewDidLoad()
        captionLabel.alpha = 0
        checkPlayerName {_ in}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        captionLabel.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Скругление кнопок и добавление теней        
        playGameButton.rounded()
        playGameButton.addShadow()
        
        tableScoreButton.rounded()
        tableScoreButton.addShadow()
        
        settingButton.rounded()
        settingButton.addShadow()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateButton()
    }

    //MARK: IBActions:
    // Начать игру
    @IBAction func playGameButtonAction(_ sender: UIButton) {
        showScreen(screen: .playScreen)
    }
    
    // Таблица рекордов
    @IBAction func tableScoreButtonAction(_ sender: UIButton) {
        showScreen(screen: .tableScoreScreen)
    }
    
    // Настройки
    @IBAction func settingButtonAction(_ sender: UIButton) {
        showScreen(screen: .settingsScreen)
    }
    
    //MARK: Custom func
    private func animateButton() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut) {
            self.playGameButton.alpha = 1
        }
        UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseOut) {
            self.tableScoreButton.alpha = 1
        }
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut) {
            self.settingButton.alpha = 1
        }
        UIView.animate(withDuration: 1) {
            self.captionLabel.alpha = 1
        }

    }
    
    private func checkPlayerName(completion: @escaping (Bool) -> ()) {
        if let data = userDefaults.value(forKey: .userSettings) as? Data {
            do {
                let user = try JSONDecoder().decode(SettingsClass.self, from: data)
                if user.playerName.isEmpty {
                    self.showAlertWithTextField(titleAlert: "Player name", message: "Please enter the player's name to save the results", style: .alert) { playerName in
                        let defaultSettings = SettingsClass()
                        defaultSettings.playerName = playerName
                        let settingsData = try? JSONEncoder().encode(defaultSettings)
                        self.userDefaults.setValue(settingsData, forKey: .userSettings)
                        completion(true)
                    }
                }
                completion(true)
            } catch  {
                print(error.localizedDescription)
                completion(false)
            }
        } else {
            self.showAlertWithTextField(titleAlert: "Player name", message: "Please enter the player's name to save the results", style: .alert) { playerName in
                let defaultSettings = SettingsClass()
                defaultSettings.playerName = playerName
                let settingsData = try? JSONEncoder().encode(defaultSettings)
                self.userDefaults.setValue(settingsData, forKey: .userSettings)
                completion(true)
            }
            completion(false)
        }
        
    }
    
    private func showScreen(screen: OpeningScreen) {
        switch screen {
        case .playScreen:
            checkPlayerName { nameExist in
                if nameExist {
                    UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveEaseIn, animations: {
                        self.captionLabel.alpha = 0
                        self.playGameButton.alpha = 0
                    } , completion: { _ in
                        self.showViewController(showingViewController: GameViewController(), navigationController: true, modalPresentationStyle: .fullScreen)
                    })
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn) {
                        self.tableScoreButton.alpha = 0
                    }
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                        self.settingButton.alpha = 0
                    })
                }
            }
            
        case .tableScoreScreen:
            UIView.animate(withDuration: 0.5) {
                self.captionLabel.alpha = 0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn, animations: {
                self.playGameButton.alpha = 0
            })
            UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveEaseIn, animations: {
                self.tableScoreButton.alpha = 0
            }, completion: { _ in
                self.showViewController(storyboardName: String(describing: type(of: TableScoreViewController())), showingViewController: TableScoreViewController(), navigationController: true)
            })
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn, animations: {
                self.settingButton.alpha = 0
            })
        case .settingsScreen:
            UIView.animate(withDuration: 0.5) {
                self.captionLabel.alpha = 0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn, animations: {
                self.playGameButton.alpha = 0
            })
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn, animations: {
                self.tableScoreButton.alpha = 0
            })
            UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveEaseIn, animations: {
                self.settingButton.alpha = 0
            }, completion: { _ in
                self.showViewController(storyboardName: "Settings", showingViewController: SettingViewController(), navigationController: true)
            })
        }
    }
    
    
}



