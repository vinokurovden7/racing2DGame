//
//  SettingViewController.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 05.05.2021.
//

import UIKit

class SettingViewController: CustomViewController {

    // MARK: IBOutlets:
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var closeScreenButton: UIButton!
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var selectCarLabel: UILabel!
    @IBOutlet weak var selectedCarImageView: UIImageView!
    @IBOutlet weak var leftChangeCarButton: CustomButton!
    @IBOutlet weak var rightChangeCarButton: CustomButton!
    @IBOutlet weak var selectBarrierLabel: UILabel!
    @IBOutlet weak var firstTypeBarrierImageView: UIImageView!
    @IBOutlet weak var secondTypeBarrierImageView: UIImageView!
    @IBOutlet weak var firstTypeBarrierSwich: UISwitch!
    @IBOutlet weak var secondTypeBarrierSwich: UISwitch!
    @IBOutlet weak var speedGameLabel: UILabel!
    @IBOutlet weak var speedGameSlider: UISlider!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var typeControllSegmentedControll: UISegmentedControl!
    @IBOutlet weak var volumeMusicSlider: UISlider!
    @IBOutlet weak var volumeSoundEffectsSlider: UISlider!
    @IBOutlet weak var volumeButtonSelectionSlider: UISlider!

    // MARK: Variables:
    private var selectedCarImage = 0
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let leftSwipeGestureRecognizer = UISwipeGestureRecognizer()
    private let rightSwipeGestureRecognizer = UISwipeGestureRecognizer()
    private let arrayTrafficCarNamesIcon = [0: "yellowUserCar_xenon_purpleNeon_icon",
                                            1: "ambulance",
                                            2: "bus",
                                            3: "jeepCar",
                                            4: "orangeCar",
                                            5: "pinkCar",
                                            6: "policeCar",
                                            7: "redCar",
                                            8: "redMitsuCar",
                                            9: "taxiCar",
                                            10: "truck",
                                            11: "whiteCar",
                                            12: "whiteMersCar",
                                            13: "whiteRaceCar",
                                            14: "yellowCar"]
    private let userDefaults = UserDefaults.standard
    private let soundEffectsPlayer = SoundPlayer()

    private enum DirectionCahngeCar {
        case next
        case previous
    }

    // MARK: Life cycles:
    override func viewDidLoad() {
        super.viewDidLoad()
        firstSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupScreen()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: IBActions:
    @IBAction func closeScreenButtonAction(_ sender: UIButton) {
        soundEffectsPlayer.playSound(typeSound: .selectButton)
        saveSettings()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func leftChangeCarButtonAction(_ sender: UIButton) {
        DispatchQueue.global().async {
            self.soundEffectsPlayer.playSound(typeSound: .selectButton)
        }
        changeCarImage(direction: .previous)
    }

    @IBAction func rightChangeCarButtonAction(_ sender: UIButton) {
        DispatchQueue.global().async {
            self.soundEffectsPlayer.playSound(typeSound: .selectButton)
        }
        changeCarImage(direction: .next)
    }

    @IBAction func firstBarrierSwichAction(_ sender: UISwitch) {
        DispatchQueue.global().async {
            self.soundEffectsPlayer.playSound(typeSound: .selectButton)
        }
        if !secondTypeBarrierSwich.isOn && !sender.isOn {
            secondTypeBarrierSwich.isOn = true
        }
    }

    @IBAction func secondBarrierSwitchAction(_ sender: UISwitch) {
        DispatchQueue.global().async {
            self.soundEffectsPlayer.playSound(typeSound: .selectButton)
        }
        if !firstTypeBarrierSwich.isOn && !sender.isOn {
            firstTypeBarrierSwich.isOn = true
        }
    }

    @IBAction func swichControlTypeAction(_ sender: UISegmentedControl) {
        DispatchQueue.global().async {
            self.soundEffectsPlayer.playSound(typeSound: .selectButton)
        }
    }

    @IBAction func volumeMusicSliderAction(_ sender: UISlider) {
        SoundPlayer.musicPlayer.setVolume(volume: sender.value)
    }

    @IBAction func volumeButtonSelectionSliderAction(_ sender: UISlider) {
        saveSettings()
    }

    // MARK: Custom Func:
    private func animateAllElements() {
        scrollView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.3) {
            self.scrollView.alpha = 1
        }
    }

    private func changeCarImage(direction: DirectionCahngeCar) {
        switch direction {
        case .next:
            let countImage = arrayTrafficCarNamesIcon.count - 1
            if selectedCarImage == countImage {
                selectedCarImage = 0
                setCarImage(imageIndex: selectedCarImage)
            } else {
                selectedCarImage += 1
                setCarImage(imageIndex: selectedCarImage)
            }
        case .previous:
            if selectedCarImage == 0 {
                selectedCarImage = arrayTrafficCarNamesIcon.count - 1
                setCarImage(imageIndex: selectedCarImage)
            } else {
                selectedCarImage -= 1
                setCarImage(imageIndex: selectedCarImage)
            }
        }
    }

    private func setCarImage(imageIndex: Int) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) {
            self.selectedCarImageView.alpha = 0
        } completion: { _ in
            guard let selectedImageName = self.arrayTrafficCarNamesIcon[imageIndex] else {return}
            self.selectedCarImageView.image = UIImage(named: selectedImageName)
            UIView.animate(withDuration: 0.25) {
                self.selectedCarImageView.alpha = 1
            }
        }

    }

    private func firstSetup() {
        leftSwipeGestureRecognizer.direction = .left
        leftSwipeGestureRecognizer.addTarget(self, action: #selector(leftSwipeAction(_:)))
        rightSwipeGestureRecognizer.direction = .right
        rightSwipeGestureRecognizer.addTarget(self, action: #selector(rightSwipeAction(_:)))
        scrollView.addGestureRecognizer(leftSwipeGestureRecognizer)
        scrollView.addGestureRecognizer(rightSwipeGestureRecognizer)
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureAction))
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func setupScreen() {
        if let settingsData = userDefaults.value(forKey: .userSettings) as? Data {
            do {
                let userSettings = try JSONDecoder().decode(SettingsClass.self, from: settingsData)
                selectedCarImageView.image = UIImage(named: userSettings.selectedCarImageName)
                if let selectedImageKey = arrayTrafficCarNamesIcon.filter({
                    $0.value.contains(userSettings.selectedCarImageName)
                }).keys.first {
                    selectedCarImage = selectedImageKey
                }
                speedGameSlider.value = userSettings.speedGame.mapped(inMin: 2.5, inMax: 0.5, outMin: 0, outMax: 3)
                playerNameTextField.text  = userSettings.playerName
                guard let firstType = userSettings.selectedBarrier["barrier"],
                      let secondType = userSettings.selectedBarrier["traffic"] else {return}
                firstTypeBarrierSwich.isOn = firstType
                secondTypeBarrierSwich.isOn = secondType
                typeControllSegmentedControll.selectedSegmentIndex = userSettings.selectedTypeControll
                soundEffectsPlayer.setVolume(volume: userSettings.effectsVolume)
                volumeMusicSlider.value = userSettings.musicVolume
                volumeSoundEffectsSlider.value = userSettings.effectsVolume
                volumeButtonSelectionSlider.value = userSettings.selectButtonVolume
            } catch {
                print(error.localizedDescription)
            }

        }

        guard let font = UIFont.chernobylFont(of: 20) else {return}
        let attributedString = NSAttributedString(string: "Enter palyer name",
                                                  attributes: [.foregroundColor: UIColor.lightGray,
                                                               .font: font])
        playerNameTextField.attributedPlaceholder = attributedString
        playerNameTextField.layer.borderColor = UIColor.white.cgColor
        playerNameTextField.layer.cornerRadius = playerNameLabel.frame.height / 2
        playerNameTextField.layer.borderColor = UIColor.white.cgColor
        playerNameTextField.clipsToBounds = true
        playerNameTextField.layer.borderWidth = 1
        animateAllElements()
    }

    private func saveSettings() {
        if playerNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            self.showAlert(titleAlert: "Error",
                           message: "Please, enter player name",
                           buttons: [("Ok", .default)],
                           completion: {_ in})
            return
        }
        let userSettings = SettingsClass()
        if let palyerName = playerNameTextField.text {
            userSettings.playerName = palyerName
        }
        userSettings.selectedBarrier = ["barrier": firstTypeBarrierSwich.isOn, "traffic": secondTypeBarrierSwich.isOn]
        if let selectedCarImageName = arrayTrafficCarNamesIcon[selectedCarImage] {
            userSettings.selectedCarImageName = selectedCarImageName
        }
        userSettings.speedGame = speedGameSlider.value.mapped(inMin: speedGameSlider.minimumValue,
                                                              inMax: speedGameSlider.maximumValue,
                                                              outMin: 2.5,
                                                              outMax: 0.5)

        userSettings.selectedTypeControll = typeControllSegmentedControll.selectedSegmentIndex

        userSettings.musicVolume = volumeMusicSlider.value
        userSettings.effectsVolume = volumeSoundEffectsSlider.value
        userSettings.selectButtonVolume = volumeButtonSelectionSlider.value

        do {
            let userSettingsData = try JSONEncoder().encode(userSettings)
            userDefaults.setValue(userSettingsData, forKey: .userSettings)
        } catch {
            print(error)
        }
    }

    // MARK: OBJC func:
    @objc private func tapGestureAction() {
        self.view.endEditing(true)
    }

    @objc private func leftSwipeAction(_ sender: UISwipeGestureRecognizer) {
        changeCarImage(direction: .previous)
    }

    @objc private func rightSwipeAction(_ sender: UISwipeGestureRecognizer) {
        changeCarImage(direction: .next)
    }

}
extension SettingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
    }

}
