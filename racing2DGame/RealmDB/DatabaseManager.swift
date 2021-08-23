//
//  DatabaseManager.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 22.08.2021.
//

import Foundation
import RealmSwift
class DatabaseManager {
    static let shared = DatabaseManager()
    private let realm: Realm!

    private init() {
        do {
            self.realm = try Realm()
        } catch {
            print(error.localizedDescription)
            fatalError()
        }
    }

    func saveScore(userScore: Score) {
        do {
            try realm.write {
                realm.add(userScore)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func getUserScore() -> Results<Score> {
        let scores = realm.objects(Score.self)
        return scores
    }
}
