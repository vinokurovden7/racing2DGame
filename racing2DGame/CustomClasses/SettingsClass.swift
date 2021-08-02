//
//  SettingsClass.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 08.06.2021.
//

import Foundation
class SettingsClass: Codable {
    var playerName = "Player"
    var selectedCarImageName = "yellowUser_icon"
    var selectedBarrier: [String:Bool] = ["barrier" : true, "traffic" : true]
    var speedGame: Float = 1.5
    var selectedTypeControll = 0
    var musicVolume: Float = 50.0
    var effectsVolume: Float = 50.0
    var selectButtonVolume: Float = 50.0
}
