//
//  UserDefaults+Keys.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 07.06.2021.
//

import Foundation
extension UserDefaults {

    func setValue(_ value: Any?, forKey key: UserDefaultsKeys) {
        self.setValue(value, forKey: key.rawValue)
    }

    func value(forKey key: UserDefaultsKeys) -> Any? {
        return self.value(forKey: key.rawValue)
    }

    func integer(forKey key: UserDefaultsKeys) -> Int {
        return self.integer(forKey: key.rawValue)
    }

    func bool(forKey key: UserDefaultsKeys) -> Bool {
        return self.bool(forKey: key.rawValue)
    }

    func double(forKey key: UserDefaultsKeys) -> Double {
        return self.double(forKey: key.rawValue)
    }

    func float(forKey key: UserDefaultsKeys) -> Float {
        return self.float(forKey: key.rawValue)
    }

    func object(forKey key: UserDefaultsKeys) -> Any? {
        return self.object(forKey: key.rawValue)
    }

}
