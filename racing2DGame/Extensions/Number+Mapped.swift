//
//  Number+Mapped.swift
//  racing2DGame
//
//  Created by Денис Винокуров on 07.06.2021.
//

import Foundation
extension Double {
    func mapped(inMin: Double, inMax: Double, outMin: Double, outMax: Double) -> Double {
        return (self - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
    }
}

extension Float {
    func mapped(inMin: Float, inMax: Float, outMin: Float, outMax: Float) -> Float {
        return (self - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
    }
}

extension Int {
    func mapped(inMin: Int, inMax: Int, outMin: Int, outMax: Int) -> Int {
        return (self - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
    }
}
