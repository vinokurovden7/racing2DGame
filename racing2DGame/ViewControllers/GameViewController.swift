//
//  GameViewController.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 05.05.2021.
//

import UIKit
import CoreMotion

class GameViewController: CustomViewController {

    //MARK: IBOutlets:
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var centerConstraintCar: NSLayoutConstraint!
    @IBOutlet weak var rigthControlButton: CustomButton!
    @IBOutlet weak var leftControlButton: CustomButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var menuButton: CustomButton!
    
    //MARK: Variables
    private let firstRoadImageView = UIImageView(image: UIImage(named: "nightRoadBackground"))
    private let secondRoadImageView = UIImageView(image: UIImage(named: "nightRoadBackground"))
    private var arrayThree: [UIView:CGRect] = [:]
    private var arrayBarier: [UIView:(traffic: Bool, oncoming: Bool )] = [:]
    private var timeDuration: TimeInterval = 1.5
    private var showHelp = true
    private let arrayTreeNamesIcon = ["tree_one_icon", "tree_two_icon", "tree_four_icon", "tree_five_icon"]
    private let arrayTrafficCarNamesIcon = ["ambulance", "bus", "jeepCar", "orangeCar", "pinkCar", "policeCar", "redCar", "redMitsuCar", "taxiCar", "truck", "whiteCar", "whiteMersCar", "whiteRaceCar", "yellowCar"]
    private let arrayStartTimer: [Int:String] = [0 : "3", 1 : "2", 2 : "1", 3 : "start"]
    private var lastTrafficImageName = ""
    private let helpView = UIView()
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private var score = 0
    private var statusGame: StatusGame = .pause
    private let menuView = UIView()
    private let titleMenuViewLabel = UILabel()
    private let resumeMenuButton = CustomButton()
    private let restartMenuButton = CustomButton()
    private let returnToMainMenuMenuButton = CustomButton()
    private var scoreTimer = Timer()
    private let helpLabel = UILabel()
    private let multipleWidth: CGFloat = 0.0603865
    private let multipleHeight: CGFloat = 0.171522
    private let multipleDelimeterHeight: CGFloat = 0.0815217
    private let offsetPauseMenuButtons: CGFloat = 40
    private let fontSigePauseMenuButtons: CGFloat = 20
    private let upSizeJumpPauseMenuButtons: CGFloat = 10
    private let rotationUserCarAngle: CGFloat = 120
    private let moveSizeUserCar: CGFloat = 10
    private let countScreenCar = 2
    private let userDefaults = UserDefaults.standard
    private var playerName: String = ""
    private var startTimerSeconds = 0
    private var firstNumberImage = UILabel()
    private var selectedBarrier: [String:Bool] = [:]
    private var threeTimer = Timer()
    private var barrierTimer = Timer()
    private let motionManager = CMMotionManager()
    private var typeControll = 0
    private let soundCarCrashEffectsPlayer = SoundPlayer()
    private let soundEffectsPlayer = SoundPlayer()
    
    
    private enum DirectionRotation {
        case left
        case right
    }
    
    private enum StatusGame {
        case play
        case pause
        case stop
        case gameOver
        case resume
    }
    
    //MARK: Life cycles
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
        stopGame()
        SoundPlayer.musicPlayer.playSound(typeSound: .menu)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: objc func
    // Нажатие на экран обучения перед началом игры
    @objc func tapGestureAction() {
        self.centerConstraintCar.constant = 0
        UIView.animate(withDuration: 0.5, animations:  {
            self.view.layoutIfNeeded()
            self.helpView.alpha = 0
            self.rigthControlButton.setTitle("", for: .normal)
            self.leftControlButton.setTitle("", for: .normal)
            self.rigthControlButton.backgroundColor = .clear
            self.leftControlButton.backgroundColor = .clear
        } , completion: { _ in
            self.helpView.removeFromSuperview()
            self.showHelp = false
            self.statusGame = .play
            self.moveDelimeterView()
            self.showStartTimer()
        })
        
    }
    
    @objc func resumeMenuButtonAction(_ sender: CustomButton) {
        soundEffectsPlayer.playSound(typeSound: .selectButton)
        hidePauseMenu {
            self.statusGame = .resume
            self.checkStatusGame()
        }
    }
    
    @objc func restartMenuButtonAction(_ sender: CustomButton) {
        soundEffectsPlayer.playSound(typeSound: .selectButton)
        hidePauseMenu {
            UIView.animate(withDuration: 0.5) {
                self.menuButton.alpha = 0
            }
            self.restartGame()
        }
        
    }
    
    @objc func returnToMainMenuMenuButtonAction(_ sender: CustomButton) {
        soundEffectsPlayer.playSound(typeSound: .selectButton)
        hidePauseMenu {
            self.statusGame = .stop
            self.checkStatusGame()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    //MARK: IBActions:
    // Нажатие на левую кнопку поворота
    @IBAction func touchDownLeftButtonAction(_ sender: UIButton) {
        moveCar(direction: .left)
    }
    
    // Отпускание левой кнопки поворота
    @IBAction func touchUpInsideLeftButtonAction(_ sender: UIButton) {
        returnedRotationCar()
    }
    
    // Нажатие на правую кнопку поворота
    @IBAction func touchDownRightButtonAction(_ sender: UIButton) {
        moveCar(direction: .right)
    }
    
    // Отпускание правой кнопки поворота
    @IBAction func touchUpInsideRightButtonAction(_ sender: UIButton) {
        returnedRotationCar()
    }
    
    // Показать меню паузы
    @IBAction func showMenuButtonAction(_ sender: UIButton) {
        showPauseMenu(xPoint: sender.frame.maxX, yPoint: sender.frame.maxY)
    }
    
    //MARK: Custom func
    /// Движение машинки игрока
    /// - Parameters:
    ///   - direction: направление
    private func moveCar(direction: DirectionRotation) {
        switch direction {
        case .left:
            checkStatusGame()
            if statusGame == .play || showHelp {
                if carImage.frame.minX > firstRoadImageView.frame.minX {
                    centerConstraintCar.constant -= moveSizeUserCar
                } else {
                    setGameOverMode()
                }
                
                UIView.animate(withDuration: timeDuration / 15, delay: 0, options: [.curveLinear]) { [self] in
                    carImage.transform = CGAffineTransform(rotationAngle: -rotationUserCarAngle)
                    self.view.layoutIfNeeded()
                } completion: { [self] _ in
                    if leftControlButton.isHighlighted {
                        moveCar(direction: direction)
                    }
                }
            }
            
        case .right:
            
            checkStatusGame()
            if statusGame == .play || showHelp {
                if carImage.frame.maxX < firstRoadImageView.frame.maxX {
                    centerConstraintCar.constant += moveSizeUserCar
                } else {
                    setGameOverMode()
                }
                
                UIView.animate(withDuration: timeDuration / 15, delay: 0, options: [.curveLinear]) { [self] in
                    carImage.transform = CGAffineTransform(rotationAngle: rotationUserCarAngle)
                    
                    self.view.layoutIfNeeded()
                } completion: { [self] _ in
                    if rigthControlButton.isHighlighted {
                        moveCar(direction: direction)
                    }
                }
            }
        }
    }
    
    /// Вернуть поворот машинки игрока
    private func returnedRotationCar() {
        UIView.animate(withDuration: timeDuration / 15, delay: 0, options: [.curveLinear]) { [self] in
            carImage.transform = CGAffineTransform(rotationAngle: 0)
            
        }
    }
    
    
    /// Движение полосы разметки
    /// - Parameter movedView: view полосы разметки
    private func moveDelimeterView() {
        UIView.animate(withDuration: timeDuration / 7, delay: 0, options: [.curveLinear]) { [self] in
            if statusGame == .play {
                
                firstRoadImageView.frame.origin.y += self.view.frame.height * multipleDelimeterHeight
                secondRoadImageView.frame.origin.y += self.view.frame.height * multipleDelimeterHeight
            }
        } completion: { [self]  _ in
            
            checkStatusGame()
            if firstRoadImageView.frame.origin.y > self.view.frame.maxY {
                firstRoadImageView.frame.origin.y = self.view.frame.origin.y - self.view.frame.height * 2
            }
            if secondRoadImageView.frame.origin.y > self.view.frame.maxY {
                secondRoadImageView.frame.origin.y = self.view.frame.origin.y - self.view.frame.height * 2
            }
            moveDelimeterView()
        }
    }
    
    /// Добавить дерево на обочину
    private func addTree() {
        guard let randomTreeName = arrayTreeNamesIcon.randomElement() else {return}
        let image = UIImageView(image: UIImage(named: randomTreeName))
        image.contentMode = .scaleToFill
        view.insertSubview(image, at: 1)
        if Bool.random() {
            image.frame = CGRect(x: self.view.frame.origin.x + self.view.frame.width / 17, y: self.view.frame.origin.y - 20, width: self.view.frame.width * multipleWidth, height:  self.view.frame.width * multipleWidth)
        } else {
            image.frame = CGRect(x: self.view.frame.maxX - self.view.frame.width / 9, y: self.view.frame.origin.y - 20, width: self.view.frame.width * multipleWidth, height:  self.view.frame.width * multipleWidth)
        }
        arrayThree[image] = CGRect(origin: image.frame.origin, size: image.frame.size)
        view.insertSubview(image, at: 2)
        moveTreeView(movedView: image)
        
    }
    
    /// Движение дерева
    /// - Parameter movedView: двигаемое view дерева
    private func moveTreeView(movedView: UIView) {
        
        UIView.animate(withDuration: timeDuration / 7, delay: 0, options: [.curveLinear]) { [self] in
            if statusGame == .play {
                movedView.frame.origin.y += self.view.frame.height * multipleDelimeterHeight
            }
        } completion: { [self] _ in
            
            if carImage.frame.intersects(movedView.frame) && movedView.frame.maxY > carImage.frame.origin.y + carImage.frame.height / 2 {
                statusGame = .gameOver
            }
            
            checkStatusGame()
            if statusGame == .play {
                if movedView.frame.origin.y >= self.view.frame.height  {
                    movedView.removeFromSuperview()
                    arrayThree[movedView] = nil
                } else {
                    if movedView.frame.origin.y >= self.view.frame.origin.y + movedView.frame.height * 4 && arrayThree.count <= 5 && arrayThree.filter({$0.key.frame.origin.y <= self.view.frame.origin.y + movedView.frame.height * 4}).count == 0 {
                        addTree()
                    }
                    moveTreeView(movedView: movedView)
                }
            }
        }
    }
    
    /// Получить случайную картинку трафика
    /// - Returns: Наименование картинки
    private func getRandomTrafficImage() -> String {
        guard let trafficImageName = arrayTrafficCarNamesIcon.randomElement() else {return ""}
                
        if lastTrafficImageName.isEmpty {
            lastTrafficImageName = trafficImageName
            return trafficImageName
        } else {
            if lastTrafficImageName == trafficImageName {
                return getRandomTrafficImage()
            } else {
                lastTrafficImageName = trafficImageName
                return trafficImageName
            }
        }
    }
    
    private func getRandomBarrierName() -> String {
        return "Top_Road_Barrier"
    }
    
    /// Добавить барьер на трассу
    private func addBariers() {
        
        guard let traffic = selectedBarrier["traffic"], let barrier = selectedBarrier["barrier"] else {return}
        if traffic && !barrier {
            addTraffic()
        } else if !traffic && barrier {
            addBarrier()
        } else {
            if Bool.random() {
                addTraffic()
            } else {
                addBarrier()
            }
        }
        
    }
    
    private func addBarrier() {
        let image = UIImageView(image: UIImage(named: getRandomBarrierName()))
        image.contentMode = .scaleAspectFit
        if Bool.random() {
            image.frame = CGRect(x: CGFloat.random(in: self.view.center.x - self.view.frame.width / 4...self.view.center.x - self.view.frame.width / 8.25), y: self.view.frame.origin.y - 120, width: self.view.frame.width * multipleWidth * 2, height: 20)
        } else {
            image.frame = CGRect(x: CGFloat.random(in: self.view.center.x + self.view.frame.width / 19...self.view.center.x + self.view.frame.width / 5), y: self.view.frame.origin.y - 120, width: self.view.frame.width * multipleWidth * 2, height: 20)
        }
        
        if arrayBarier.filter({$0.key.frame.intersects(image.frame)}).count > 0  {
            addBariers()
            return
        }
        arrayBarier[image] = (traffic: false, oncoming: image.center.x < self.view.center.x)
        view.addSubview(image)
        moveBarierView(movedView: image, duration: timeDuration / 50)
    }
    
    private func addTraffic() {
        let image = UIImageView(image: UIImage(named: getRandomTrafficImage()))
        image.contentMode = .scaleAspectFill
        if Bool.random() {
            image.frame = CGRect(x: CGFloat.random(in: self.view.center.x - self.view.frame.width / 4...self.view.center.x - self.view.frame.width / 8.25), y: self.view.frame.origin.y - 120, width: self.view.frame.width * multipleWidth, height: self.view.frame.height * 0.171522)
        } else {
            image.frame = CGRect(x: CGFloat.random(in: self.view.center.x + self.view.frame.width / 19...self.view.center.x + self.view.frame.width / 5), y: self.view.frame.origin.y - 120, width: self.view.frame.width * multipleWidth, height: self.view.frame.height * 0.171522)
        }
        if arrayBarier.filter({$0.key.frame.intersects(image.frame)}).count > 0  {
            addBariers()
            return
        }
        arrayBarier[image] = (traffic: true, oncoming: image.center.x < self.view.center.x)
        view.addSubview(image)
        if image.frame.origin.x < self.view.center.x {
            image.transform = CGAffineTransform(rotationAngle: .pi)
            moveBarierView(movedView: image, duration: timeDuration / 80)
        } else {
            moveBarierView(movedView: image, duration: timeDuration / 20)
        }
    }
    
    /// Движение барьера
    /// - Parameter movedView: движимое view
    private func moveBarierView(movedView: UIView, duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear]) { [self] in
            if statusGame == .play {
                movedView.frame.origin.y += 10
            }
        } completion: { [self] _ in
            guard let barrier = arrayBarier[movedView] else {return}
            if carImage.frame.intersects(movedView.frame) {
                
                // Встречка
                if barrier.oncoming {
                    // Траффик
                    if barrier.traffic {
                        if movedView.frame.maxY - movedView.frame.height / 2.2 > carImage.frame.origin.y + carImage.frame.height / 2 {
                            statusGame = .gameOver
                        }
                    } else {
                        if movedView.frame.maxY > carImage.frame.origin.y + carImage.frame.height / 2 && (movedView.frame.origin.x + 15 <= carImage.frame.maxX - 15 || movedView.frame.maxX - 15 <= carImage.frame.origin.x + 15) {
                            statusGame = .gameOver
                        }
                    }
                } else {
                    if barrier.traffic {
                        
                        if movedView.frame.maxY > carImage.frame.origin.y + carImage.frame.height / 2 &&
                            movedView.frame.origin.y + movedView.frame.height / 2.2 < carImage.frame.maxY &&
                            (movedView.frame.origin.x + 2.5 <= carImage.frame.maxX - 2.5 || movedView.frame.maxX - 2.5 <= carImage.frame.origin.x + 2.5) {
                            statusGame = .gameOver
                        }
                        
                    } else {
                        if movedView.frame.maxY > carImage.frame.origin.y + carImage.frame.height / 2 && (movedView.frame.origin.x + 15 <= carImage.frame.maxX - 15 || movedView.frame.maxX - 15 <= carImage.frame.origin.x + 15) {
                            statusGame = .gameOver
                        }
                    }
                }
                
            }
            
            checkStatusGame()
            if statusGame == .play {
                if movedView.frame.origin.y >= self.view.frame.height {
                    movedView.removeFromSuperview()
                    arrayBarier[movedView] = nil
                } else {
                    moveBarierView(movedView: movedView, duration: duration)
                }
            }
        }
    }
    
    
    /// Установить режим Game over
    private func setGameOverMode() {
        self.soundCarCrashEffectsPlayer.playSound(typeSound: .carCrash)
        SoundPlayer.musicPlayer.stopPlaying()
        statusGame = .pause
        returnedRotationCar()
        var usersScoreArray: [GameScoreClass] = []
        if let gameScoresData = userDefaults.value(forKey: .gameScore) as? Data {
            do {
                usersScoreArray = try JSONDecoder().decode([GameScoreClass].self, from: gameScoresData)
            } catch {
                print(error.localizedDescription)
            }
        }
        let userScore = GameScoreClass()
        userScore.playerName = self.playerName
        userScore.score = score
        usersScoreArray.append(userScore)
        let userScoreData = try? JSONEncoder().encode(usersScoreArray)
        userDefaults.setValue(userScoreData, forKey: .gameScore)
        scoreTimer.invalidate()
        if !showHelp {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gameOverViewController = storyboard.instantiateViewController(identifier: "GameOverViewController") as GameOverViewController
            gameOverViewController.score = score
            gameOverViewController.closure = { [self] showMainScreen in
                if showMainScreen {
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    restartGame()
                }
            }
            present(gameOverViewController, animated: true)
        }
    }
    
    /// Первоначальная настройка
    private func firstSetup() {
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.addTarget(self, action: #selector(tapGestureAction))
        
        firstNumberImage.font = UIFont.chernobylFont(of: 50)
        firstNumberImage.textAlignment = .center
        firstNumberImage.textColor = .systemTeal
        firstNumberImage.layer.shadowOpacity = 1
        firstNumberImage.layer.shadowRadius = 4
        firstNumberImage.layer.shadowOffset = CGSize(width: 0, height: 15)
        firstNumberImage.layer.shadowColor = UIColor.purple.cgColor
        firstNumberImage.backgroundColor = .clear

        scoreLabel.alpha = 0
        
        helpLabel.text = "Dodge traffic\nFor turns, press the side buttons\nTo start the game, tap on the screen"
        helpLabel.font = .chernobylFont(of: 20)
        helpView.frame = self.view.bounds
        helpLabel.frame.size = CGSize(width: helpView.frame.width, height: 100)
        helpLabel.center = helpView.center
        helpLabel.textAlignment = .center
        helpLabel.textColor = .white
        helpLabel.numberOfLines = 0
        helpLabel.alpha = 0
        
        helpView.addSubview(helpLabel)
        helpView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.85)
        helpView.alpha = 0
        view.insertSubview(helpView, at: 1)
        
        rigthControlButton.backgroundColor = #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 0.5216298893)
        leftControlButton.backgroundColor =  #colorLiteral(red: 0.9961728454, green: 0.9902502894, blue: 1, alpha: 0.5216298893)
        rigthControlButton.alpha = 0
        leftControlButton.alpha = 0
        
        title = "Игра"
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut) {
            self.helpView.alpha = 1
            self.helpLabel.alpha = 1
        }
        
        if let settingsData = userDefaults.value(forKey: .userSettings) as? Data {
            do {
                let userSettings = try JSONDecoder().decode(SettingsClass.self, from: settingsData)
                switch userSettings.selectedTypeControll {
                    case 0:
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                            self.blinkButton(blinkedButton: self.leftControlButton) {
                                self.blinkButton(blinkedButton: self.rigthControlButton) {
                                    self.helpView.addGestureRecognizer(self.tapGestureRecognizer)
                                }
                            }
                            timer.invalidate()
                        }
                    case 1:
                        helpLabel.text = "Dodge traffic\nFor turns, rotate device\nTo start the game, tap on the screen"
                        let rotationDeviceImageView = UIImageView()
                        rotationDeviceImageView.image = UIImage(named: "rotate-arrow")
                        rotationDeviceImageView.contentMode = .scaleAspectFill
                        rotationDeviceImageView.frame.size = CGSize(width: 100, height: 100)
                        rotationDeviceImageView.frame.origin = CGPoint(x: helpLabel.frame.origin.x + helpLabel.frame.width / 2 - rotationDeviceImageView.frame.width / 2, y: helpLabel.frame.maxY + 20)
                        helpView.addSubview(rotationDeviceImageView)
                        self.helpView.addGestureRecognizer(self.tapGestureRecognizer)
                    default:
                        print("Unknown type controll")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func blinkButton(blinkedButton: UIButton, countBlink: Int = 1, completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
            blinkedButton.alpha = 1
        } completion: { _ in
            if countBlink > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
                    blinkedButton.alpha = 0
                } completion: { _ in
                    self.blinkButton(blinkedButton: blinkedButton, countBlink: countBlink - 1) {
                        completion()
                    }
                }
            } else {
                completion()
            }
        }

    }
    
    /// Остановить игру
    private func stopGame() {
        UIView.animate(withDuration: 0.5) {
            self.scoreLabel.alpha = 0
            self.menuButton.alpha = 0
        }
        motionManager.stopAccelerometerUpdates()
        scoreTimer.invalidate()
        barrierTimer.invalidate()
        threeTimer.invalidate()
        centerConstraintCar.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        score = 0
        scoreLabel.text = "score: \(score)"
        if let settingsData = userDefaults.value(forKey: .userSettings) as? Data {
            do {
                let userSettings = try JSONDecoder().decode(SettingsClass.self, from: settingsData)
                timeDuration = TimeInterval(userSettings.speedGame)
            } catch {
                print(error.localizedDescription)
            }
        }
        for barrier in arrayBarier.keys {
            UIView.animate(withDuration: 0.5, animations: {
                barrier.alpha = 0
            }, completion: { _ in
                barrier.removeFromSuperview()
            })
        }
        for treeView in arrayThree.keys {
            UIView.animate(withDuration: 0.5, animations: {
                treeView.alpha = 0
            }, completion: { _ in
                treeView.removeFromSuperview()
            })
        }
        arrayThree.removeAll()
        arrayBarier.removeAll()
    }
    
    /// Продолжить  игру
    private func resumeGame() {
        statusGame = .play
        startUpdateAcceleration()
        startScoreTimer()
        DispatchQueue.main.async { [self] in
            for tree in arrayThree.keys {
                tree.frame.origin.y -= tree.frame.height
                moveTreeView(movedView: tree)
            }
        }

        DispatchQueue.main.async { [self] in
            for barrier in arrayBarier {
                barrier.key.frame.origin.y -= 10
                if barrier.value.traffic {
                    if barrier.value.oncoming {
                        moveBarierView(movedView: barrier.key, duration: timeDuration / 80)
                    } else {
                        moveBarierView(movedView: barrier.key, duration: timeDuration / 20)
                    }
                } else {
                    moveBarierView(movedView: barrier.key, duration: timeDuration / 50)
                }
                
            }
        }
        startThreeTimer()
        startBarrierTimer()
        
    }
    
    /// Поставить игру на паузу
    private func pauseGame() {
        motionManager.stopAccelerometerUpdates()
        scoreTimer.invalidate()
        barrierTimer.invalidate()
        threeTimer.invalidate()
    }
    
    /// Рестарт игры
    private func restartGame() {
        stopGame()
        statusGame = .play
        showStartTimer()
    }
    
    /// Проверить статус игры
    private func checkStatusGame() {
        switch statusGame {
        case .pause:
            pauseGame()
        case .play:
            break
        case .resume:
            resumeGame()
        case .stop:
            stopGame()
        case .gameOver:
            setGameOverMode()
        }
    }
    
    /// Запустить счетчик очков
    private func startScoreTimer() {
        if statusGame == .play {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                scoreTimer = timer
                if carImage.frame.origin.x < self.view.center.x && carImage.frame.maxX < self.view.center.x {
                    score += 10
                } else {
                    score += 1
                }
                scoreLabel.text = "score: \(score)"
                if score == 10 {
                    timeDuration -= 0.25
                } else if score == 20 {
                    timeDuration -= 0.25
                } else if score == 30 {
                    timeDuration -= 0.25
                }
            }
        }
    }
    
    private func startThreeTimer() {
        Timer.scheduledTimer(withTimeInterval: timeDuration, repeats: true) { timer in
            self.threeTimer = timer
            self.addTree()
        }
    }
    
    private func startBarrierTimer() {
        Timer.scheduledTimer(withTimeInterval: timeDuration / 2, repeats: true) { timer in
            self.barrierTimer = timer
            self.addBariers()
        }
    }
    
    /// Запуск таймера перед началом игры
    private func showStartTimer() {
        SoundPlayer.musicPlayer.playSound(typeSound: .game)
        startTimerSeconds = 0
        firstNumberImage.text = arrayStartTimer[startTimerSeconds]
        firstNumberImage.frame.origin = CGPoint(x: self.view.frame.maxX, y: self.view.center.y - 25)
        firstNumberImage.frame.size = CGSize(width: self.view.frame.width * multipleWidth, height: self.view.frame.height * multipleHeight)
        self.view.addSubview(firstNumberImage)
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] _ in
            let centerPointX = self.view.center.x - 12.5
            moveNumber(pointX: centerPointX)
        }
    }
    
    private func startGame() {
        if typeControll == 1 {
            startUpdateAcceleration()
        }
        firstNumberImage.removeFromSuperview()
        startThreeTimer()
        startBarrierTimer()
        startScoreTimer()
        UIView.animate(withDuration: 0.5) {
            self.scoreLabel.alpha = 1
            self.menuButton.alpha = 1
        }
    }
    
    /// Двигать число таймера перед началом игры
    /// - Parameter pointX: позиция движения
    private func moveNumber(pointX: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, options: []) { [self] in
            firstNumberImage.frame.origin.x = pointX
        } completion: { [self] _ in
            if startTimerSeconds > 3 {
                return
            }
            if firstNumberImage.frame.origin.x == self.view.center.x - 12.5 {
                let leftPointX = self.view.frame.origin.x - firstNumberImage.frame.width
                moveNumber(pointX: leftPointX)
            } else if firstNumberImage.frame.origin.x == self.view.frame.origin.x - firstNumberImage.frame.width {
                startTimerSeconds += 1
                if startTimerSeconds < 3 {
                    firstNumberImage.text = arrayStartTimer[startTimerSeconds]
                    firstNumberImage.frame.origin.x = self.view.frame.maxX
                    let centerPointX = self.view.center.x - 12.5
                    moveNumber(pointX: centerPointX)
                } else {
                    firstNumberImage.frame.origin.x = self.view.frame.maxX
                    firstNumberImage.frame.origin.y = self.view.center.y - 25
                    firstNumberImage.frame.size = CGSize(width: self.view.frame.width * multipleWidth * 6, height: self.view.frame.height * multipleHeight)
                    firstNumberImage.text = arrayStartTimer[startTimerSeconds]
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [self] startTimer in
                        startGame()
                    }
                    let centerPointX = self.view.center.x - self.view.frame.width * multipleWidth * 6 / 2
                    moveNumber(pointX: centerPointX)
                }
            }
        }
    }
    
    /// Показать меню паузы
    /// - Parameters:
    ///   - xPoint: координата X
    ///   - yPoint: координата Y
    private func showPauseMenu(xPoint: CGFloat, yPoint: CGFloat) {
        if statusGame == .pause {
            hidePauseMenu {
                self.statusGame = .resume
                self.checkStatusGame()
            }
        } else {
            statusGame = .pause
            checkStatusGame()
            menuView.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.6021550665)
            menuView.layer.cornerRadius = 10
            menuView.frame = CGRect(x: xPoint + 10, y: yPoint + 10, width: 0, height: 0)
            menuView.layer.shadowOpacity = 1
            menuView.layer.shadowRadius = 40
            menuView.layer.shadowOffset = CGSize(width: 0, height: 0)
            menuView.layer.shadowColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.8).cgColor
            view.addSubview(menuView)
            
            UIView.animate(withDuration: 0.1, animations: {
                self.menuButton.alpha = 0
            } , completion: { _ in
                self.menuButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                UIView.animate(withDuration: 0.1) {
                    self.menuButton.alpha = 1
                }
            })
            
            UIView.animate(withDuration: 0.3) { [self] in
                menuView.frame.size = CGSize(width: self.view.frame.width - menuView.frame.origin.x - xPoint, height: 300)
            } completion: { [self] _ in
                
                titleMenuViewLabel.alpha = 0
                titleMenuViewLabel.text = "Pause"
                titleMenuViewLabel.font = .chernobylFont(of: fontSigePauseMenuButtons * 2)
                titleMenuViewLabel.frame = CGRect(x: 0, y: 0, width: menuView.frame.width, height: 50)
                titleMenuViewLabel.textAlignment = .center
                titleMenuViewLabel.textColor = .systemYellow
                titleMenuViewLabel.addShadow(color: #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 0.5))
                
                resumeMenuButton.alpha = 0
                resumeMenuButton.frame = CGRect(x: -menuView.frame.width - offsetPauseMenuButtons, y: titleMenuViewLabel.frame.maxY + offsetPauseMenuButtons / 2, width: menuView.frame.width - offsetPauseMenuButtons, height: offsetPauseMenuButtons)
                resumeMenuButton.setTitle("Resume", for: .normal)
                resumeMenuButton.titleLabel?.font = UIFont.chernobylFont(of: fontSigePauseMenuButtons)
                resumeMenuButton.addTarget(self, action: #selector(resumeMenuButtonAction(_:)), for: .touchUpInside)
                resumeMenuButton.backgroundColor = .systemTeal
                resumeMenuButton.rounded()
                resumeMenuButton.setTitleColor(.black, for: .normal)
                resumeMenuButton.addShadow(color: #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 0.5))
                
                restartMenuButton.alpha = 0
                restartMenuButton.frame = CGRect(x: -menuView.frame.width - offsetPauseMenuButtons, y: resumeMenuButton.frame.maxY + offsetPauseMenuButtons, width: menuView.frame.width - offsetPauseMenuButtons, height: offsetPauseMenuButtons)
                restartMenuButton.setTitle("Restart game", for: .normal)
                restartMenuButton.titleLabel?.font = UIFont.chernobylFont(of: fontSigePauseMenuButtons)
                restartMenuButton.addTarget(self, action: #selector(restartMenuButtonAction(_:)), for: .touchUpInside)
                restartMenuButton.backgroundColor = .systemTeal
                restartMenuButton.rounded()
                restartMenuButton.setTitleColor(.black, for: .normal)
                restartMenuButton.addShadow(color: #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 0.5))
                
                returnToMainMenuMenuButton.alpha = 0
                returnToMainMenuMenuButton.frame = CGRect(x: -menuView.frame.width - offsetPauseMenuButtons, y: restartMenuButton.frame.maxY + offsetPauseMenuButtons, width: menuView.frame.width - offsetPauseMenuButtons, height: offsetPauseMenuButtons)
                returnToMainMenuMenuButton.setTitle("Return to main menu", for: .normal)
                returnToMainMenuMenuButton.titleLabel?.font = UIFont.chernobylFont(of: fontSigePauseMenuButtons)
                returnToMainMenuMenuButton.addTarget(self, action: #selector(returnToMainMenuMenuButtonAction(_:)), for: .touchUpInside)
                returnToMainMenuMenuButton.backgroundColor = .systemRed
                returnToMainMenuMenuButton.rounded()
                returnToMainMenuMenuButton.setTitleColor(.white, for: .normal)
                returnToMainMenuMenuButton.addShadow(color: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 0.5))
                
                menuView.addSubview(titleMenuViewLabel)
                menuView.addSubview(resumeMenuButton)
                menuView.addSubview(restartMenuButton)
                menuView.addSubview(returnToMainMenuMenuButton)
                
                UIView.animate(withDuration: 0.3) {
                    titleMenuViewLabel.alpha = 1
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    resumeMenuButton.alpha = 1
                    resumeMenuButton.frame.origin.x = offsetPauseMenuButtons / 2
                }
                UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveEaseOut) {
                    restartMenuButton.alpha = 1
                    restartMenuButton.frame.origin.x = offsetPauseMenuButtons / 2
                }
                UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut) {
                    returnToMainMenuMenuButton.alpha = 1
                    returnToMainMenuMenuButton.frame.origin.x = offsetPauseMenuButtons / 2
                }

            }

        }
    }
    
    /// Скрыть меню паузы
    private func hidePauseMenu(completion : @escaping () -> ()) {
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            self.resumeMenuButton.frame.origin.y -= self.upSizeJumpPauseMenuButtons
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.resumeMenuButton.alpha = 0
                self.resumeMenuButton.frame.origin.y = self.menuView.frame.maxY
            }
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.1, options: .curveEaseOut) {
            self.restartMenuButton.frame.origin.y -= self.upSizeJumpPauseMenuButtons
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.restartMenuButton.alpha = 0
                self.restartMenuButton.frame.origin.y = self.menuView.frame.maxY
                self.titleMenuViewLabel.alpha = 0
            }
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.2, options: .curveEaseOut) {
            self.returnToMainMenuMenuButton.frame.origin.y -= self.upSizeJumpPauseMenuButtons
        } completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.returnToMainMenuMenuButton.alpha = 0
                self.returnToMainMenuMenuButton.frame.origin.y = self.menuView.frame.maxY
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.menuView.frame.size = CGSize(width: 0, height: 0)
                } , completion: { _ in
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        self.menuButton.alpha = 0
                    } , completion: { _ in
                        self.menuButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.menuButton.alpha = 1
                        }) { _ in
                            completion()
                        }
                    })
                    
                    self.resumeMenuButton.removeFromSuperview()
                    self.restartMenuButton.removeFromSuperview()
                    self.returnToMainMenuMenuButton.removeFromSuperview()
                    self.titleMenuViewLabel.removeFromSuperview()
                    self.menuView.removeFromSuperview()
                })
            }
        }
    }
    
    private func setupScreen() {
        if let settingsData = userDefaults.value(forKey: .userSettings) as? Data {
            do {
                let userSettings = try JSONDecoder().decode(SettingsClass.self, from: settingsData)
                carImage.image = UIImage(named: userSettings.selectedCarImageName)
                timeDuration = TimeInterval(userSettings.speedGame)
                playerName = userSettings.playerName
                selectedBarrier = userSettings.selectedBarrier
                typeControll = userSettings.selectedTypeControll
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        switch typeControll {
            case 1:
                self.rigthControlButton.isHidden = true
                self.leftControlButton.isHidden = true
            default:
                self.rigthControlButton.isHidden = false
                self.leftControlButton.isHidden = false
        }
        
        firstRoadImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 2)
        firstRoadImageView.contentMode = .scaleToFill
        self.view.insertSubview(firstRoadImageView, at: 0)
        
        secondRoadImageView.frame = CGRect(x: 0, y: self.view.frame.origin.y - self.view.frame.height * 2, width: self.view.frame.width, height: self.view.frame.height * 2)
        secondRoadImageView.contentMode = .scaleToFill
        self.view.insertSubview(secondRoadImageView, at: 0)
    }
    
    private func startUpdateAcceleration() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1/20
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data {
                    if Int(data.acceleration.x * 100) > 10 {
                        self.moveCar(direction: .right)
                    }
                    if Int(data.acceleration.x * 100) < -10 {
                        self.moveCar(direction: .left)
                    }
                    
                    if Int(data.acceleration.x * 100) > -10 && Int(data.acceleration.x * 100) < 10 {
                        self.returnedRotationCar()
                    }
                }
            }
        }
    }
    
}
