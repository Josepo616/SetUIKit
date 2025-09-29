//
//  DiamondShape.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/24/25.
//

import UIKit

struct DiamondShape: ShapePath {
    func path(in rect: CGRect) -> UIBezierPath {
        let width = rect.width
        let height = rect.height
        let center = CGPoint(x: rect.midX, y: rect.midY)

        let top = CGPoint(x: center.x, y: center.y - height / 3)
        let right = CGPoint(x: center.x + width / 1.65, y: center.y)
        let bottom = CGPoint(x: center.x, y: center.y + height / 3)
        let left = CGPoint(x: center.x - width / 1.65, y: center.y)

        let path = UIBezierPath()
        path.move(to: top)
        path.addLine(to: right)
        path.addLine(to: bottom)
        path.addLine(to: left)
        path.close()

        return path
    }
}
