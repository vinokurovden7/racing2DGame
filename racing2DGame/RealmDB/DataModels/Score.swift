//
//  Score.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 22.08.2021.
//

import Foundation
import RealmSwift

class Score: Object {
    @objc dynamic var playerName: String = ""
    @objc dynamic var score: Int = 0
    @objc dynamic var dateScore: Date = Date()

    convenience init(playerName: String, score: Int) {
        self.init()
        self.playerName = playerName
        self.score = score
    }
}
