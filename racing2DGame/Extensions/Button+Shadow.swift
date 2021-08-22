//
//  Button+Shadow.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 26.05.2021.
//

import UIKit

/// Направление тени
enum DirectionShadow {
    case left
    case right
    case top
    case bottom
    case upLeft
    case upRight
    case downLeft
    case downRight
}

extension UIView {

    /// Добавить тень
    /// - Parameter direction: направление тени
    func addShadow(direction: DirectionShadow = .bottom, color: UIColor = .purple) {
        var offset = CGSize()
        switch direction {
        case .bottom:
            offset = CGSize(width: 0, height: 15)
        case .downLeft:
            offset = CGSize(width: -15, height: 15)
        case .downRight:
            offset = CGSize(width: 15, height: 15)
        case .left:
            offset = CGSize(width: -15, height: 0)
        case .right:
            offset = CGSize(width: 15, height: 0)
        case .top:
            offset = CGSize(width: 0, height: -15)
        case .upLeft:
            offset = CGSize(width: -15, height: -15)
        case .upRight:
            offset = CGSize(width: 15, height: -15)
        }
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color.cgColor

    }

    /// Скруглить кнопку
    func rounded() {
        self.layer.cornerRadius = self.frame.height / 2
    }
}
