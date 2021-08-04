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
    private var audioFile: URL?
    private var userSettings: SettingsClass?
    private var volume: Float = 0.0
    private var playerEffect: AVAudioPlayer?

    func playSound(typeSound: TypeSound) {
        DispatchQueue.global().async {
            do {
                if let userSettingsData = self.userDefaults.value(forKey: .userSettings) as? Data {
                    self.userSettings = try JSONDecoder().decode(SettingsClass.self, from: userSettingsData)
                }
            } catch {
                print(error.localizedDescription)
            }
            guard let userSettings = self.userSettings else {
                return
            }
            self.typePlayingSound = typeSound
            switch typeSound {
            case .carCrash:
                self.audioFile = Bundle.main.url(forResource: "crashCar", withExtension: "mp3")
                self.volume = userSettings.effectsVolume / 100
            case .game:
                self.audioFile = Bundle.main.url(forResource: "game_\(Int.random(in: 1...4))", withExtension: "mp3")
                self.volume = userSettings.musicVolume / 100
            case .menu:
                self.audioFile = Bundle.main.url(forResource: "menu_\(Int.random(in: 1...6))", withExtension: "mp3")
                self.volume = userSettings.musicVolume / 100
            case .selectButton:
                self.audioFile = Bundle.main.url(forResource: "selectButtonMenu", withExtension: "mp3")
                self.volume = userSettings.selectButtonVolume / 100
            }
            guard let audioFile = self.audioFile else {
                return
            }
            do {
                self.player = try AVAudioPlayer(contentsOf: audioFile)
            } catch {
                print(error.localizedDescription)
            }
            guard let player = self.player else {
                return
            }
            player.volume = self.volume
            player.delegate = self
            player.prepareToPlay()
            player.play()
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
        player.volume = volume / 100
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
