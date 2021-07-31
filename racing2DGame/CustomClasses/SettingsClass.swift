//
//  SettingsClass.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 08.06.2021.
//

import Foundation
class SettingsClass: Codable {
    var playerName = "User1"
    var selectedCarImageName = "yellowUser_icon"
    var selectedBarrier: [String:Bool] = ["barrier" : true, "traffic" : true]
    var speedGame: Float = 1.5
}
