//
//  SoundPlayer.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 02.08.2021.
//

import Foundation
import AVKit

class SoundPlayer: NSObject {
    
    static let musicPlayer = SoundPlayer()
    
    enum TypeSound {
        case game
        case menu
        case carCrash
        case selectButton
    }
    
    private var player: AVAudioPlayer?
    private var typePlayingSound: TypeSound?
    private let userDefaults = UserDefaults.standard
    
    func playSound(typeSound: TypeSound) {
        DispatchQueue.global().async {
            self.typePlayingSound = typeSound
            switch typeSound {
                case .carCrash:
                    if let audioFile = Bundle.main.url(forResource: "crashCar", withExtension: "mp3") {
                        do {
                            self.player = try AVAudioPlayer(contentsOf: audioFile)
                            guard let player = self.player else {
                                return
                            }
                            player.delegate = self
                            if let userSettingsData = self.userDefaults.value(forKey: .userSettings) as? Data {
                                do {
                                    let userSettings = try JSONDecoder().decode(SettingsClass.self, from: userSettingsData)
                                    player.volume = self.mapped(mappedValue: userSettings.effectsVolume, in_min: 0, in_max: 100, out_min: 0.0, out_max: 1.0)
                                } catch  {
                                    print(error.localizedDescription)
                                }
                            }
                            player.prepareToPlay()
                            player.play()
                        } catch  {
                            print(error.localizedDescription)
                        }
                        
                    }
                    break
                case .game:
                    if let audioFile = Bundle.main.url(forResource: "game_\(Int.random(in: 1...4))", withExtension: "mp3") {
                        do {
                            self.player = try AVAudioPlayer(contentsOf: audioFile)
                            guard let player = self.player else {
                                return
                            }
                            player.delegate = self
                            if let userSettingsData = self.userDefaults.value(forKey: .userSettings) as? Data {
                                do {
                                    let userSettings = try JSONDecoder().decode(SettingsClass.self, from: userSettingsData)
                                    player.volume = self.mapped(mappedValue: userSettings.musicVolume, in_min: 0, in_max: 100, out_min: 0.0, out_max: 1.0)
                                } catch  {
                                    print(error.localizedDescription)
                                }
                            }
                            player.prepareToPlay()
                            player.play()
                        } catch  {
                            print(error.localizedDescription)
                        }
                    }
                    break
                case .menu:
                    if let audioFile = Bundle.main.url(forResource: "menu_\(Int.random(in: 1...6))", withExtension: "mp3") {
                        do {
                            self.player = try AVAudioPlayer(contentsOf: audioFile)
                            guard let player = self.player else {
                                return
                            }
                            player.delegate = self
                            if let userSettingsData = self.userDefaults.value(forKey: .userSettings) as? Data {
                                do {
                                    let userSettings = try JSONDecoder().decode(SettingsClass.self, from: userSettingsData)
                                    player.volume = self.mapped(mappedValue: userSettings.musicVolume, in_min: 0, in_max: 100, out_min: 0.0, out_max: 1.0)
                                } catch  {
                                    print(error.localizedDescription)
                                }
                            }
                            player.prepareToPlay()
                            player.play()
                        } catch  {
                            print(error.localizedDescription)
                        }
                    }
                    break
                case .selectButton:
                    if let audioFile = Bundle.main.url(forResource: "selectButtonMenu", withExtension: "mp3") {
                        do {
                            self.player = try AVAudioPlayer(contentsOf: audioFile)
                            guard let player = self.player else {
                                return
                            }
                            player.delegate = self
                            if let userSettingsData = self.userDefaults.value(forKey: .userSettings) as? Data {
                                do {
                                    let userSettings = try JSONDecoder().decode(SettingsClass.self, from: userSettingsData)
                                    player.volume = self.mapped(mappedValue: userSettings.selectButtonVolume, in_min: 0, in_max: 100, out_min: 0.0, out_max: 1.0)
                                } catch  {
                                    print(error.localizedDescription)
                                }
                            }
                            player.prepareToPlay()
                            player.play()
                        } catch  {
                            print(error.localizedDescription)
                        }
                    }
                    break
            }
        }
    }
    
    func pausePlaying() {
        guard let player = player else {
            return
        }
        player.pause()
    }
    
    func stopPlaying() {
        guard let player = player else {
            return
        }
        player.stop()
        player.currentTime = 0
    }
    
    func setVolume(volume: Float) {
        guard let player = player else {
            return
        }
        player.volume = mapped(mappedValue: volume, in_min: 0, in_max: 100, out_min: 0.0, out_max: 1.0)
    }
    
    private func mapped(mappedValue: Float, in_min: Float, in_max: Float, out_min: Float, out_max: Float) -> Float {
        return (mappedValue - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
    }
    
    func play() {
        guard let player = player else {
            return
        }
        player.play()
    }

}
extension SoundPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let typePlayingSound = typePlayingSound else {
            return
        }
        
        switch typePlayingSound {
            case .carCrash:
                player.currentTime = 0
            case .game:
                playSound(typeSound: typePlayingSound)
            case .menu:
                playSound(typeSound: typePlayingSound)
            case .selectButton:
                player.currentTime = 0
        }
    }
}
