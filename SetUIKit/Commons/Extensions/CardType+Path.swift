//
//  CardType+Path.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/25/25.
//

import UIKit

extension CardType: ShapePath {
    func path(in rect: CGRect) -> UIBezierPath {
        switch self {
        case .diamond:
            return DiamondShape().path(in: rect)
        case .rectangle:
            return RectangleShape().path(in: rect)
        case .squiggle:
            return SquiggleShape().path(in: rect)
        }
    }
}
