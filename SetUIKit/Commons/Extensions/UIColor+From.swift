//
//  UIColor+From.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

extension UIColor {
    static func from(cardColor: CardColor) -> UIColor {
        switch cardColor {
        case .red: return .red
        case .green: return .green
        case .purple: return .purple
        }
    }
}
