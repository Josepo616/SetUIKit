//
//  RectangleShape.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/25/25.
//

import UIKit

struct RectangleShape: ShapePath {
    func path(in rect: CGRect) -> UIBezierPath {
        let baseYPadding: CGFloat = 13
        let baseXPadding: CGFloat = 5
        let dynamicYPadding: CGFloat = min(baseYPadding, rect.height * 0.3)
        let dynamicXPadding: CGFloat = min(baseXPadding, rect.width * 0.1)

        let rectangleShape = CGRect(
            x: rect.origin.x - dynamicXPadding,
            y: rect.origin.y + dynamicYPadding,
            width: rect.width * 1.2,
            height: rect.height * 0.5
        )

        let cornerRadius: CGFloat = rectangleShape.width * 0.2
        return UIBezierPath(
            roundedRect: rectangleShape,
            cornerRadius: cornerRadius
        )
    }
}
