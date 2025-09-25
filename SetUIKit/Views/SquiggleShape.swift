//
//  SquiggleShape.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/25/25.
//

import UIKit

struct SquiggleShape: ShapePath {
    func path(in rect: CGRect) -> UIBezierPath {
        let originalMinX: CGFloat = 5.0
        let originalMaxX: CGFloat = 112.4
        let originalMinY: CGFloat = 6.9
        let originalMaxY: CGFloat = 65.6

        let originalWidth = originalMaxX - originalMinX
        let originalHeight = originalMaxY - originalMinY

        let horizontalStretchFactor: CGFloat = 1.5
        let adjustedWidth = rect.width * horizontalStretchFactor
        let centeringOffset = (rect.width - adjustedWidth) / 2

        func scaleX(_ x: CGFloat) -> CGFloat {
            let scaled = ((x - originalMinX) / originalWidth) * adjustedWidth
            return rect.origin.x + centeringOffset + scaled
        }

        func scaleY(_ y: CGFloat) -> CGFloat {
            return rect.origin.y + ((y - originalMinY) / originalHeight)
                * rect.height
        }

        let path = UIBezierPath()
        path.move(to: CGPoint(x: scaleX(104.0), y: scaleY(15.0)))

        path.addCurve(
            to: CGPoint(x: scaleX(63.0), y: scaleY(54.0)),
            controlPoint1: CGPoint(x: scaleX(112.4), y: scaleY(36.9)),
            controlPoint2: CGPoint(x: scaleX(89.7), y: scaleY(60.8))
        )

        path.addCurve(
            to: CGPoint(x: scaleX(27.0), y: scaleY(53.0)),
            controlPoint1: CGPoint(x: scaleX(52.3), y: scaleY(51.3)),
            controlPoint2: CGPoint(x: scaleX(42.2), y: scaleY(42.0))
        )

        path.addCurve(
            to: CGPoint(x: scaleX(5.0), y: scaleY(40.0)),
            controlPoint1: CGPoint(x: scaleX(9.6), y: scaleY(65.6)),
            controlPoint2: CGPoint(x: scaleX(5.4), y: scaleY(58.3))
        )

        path.addCurve(
            to: CGPoint(x: scaleX(36.0), y: scaleY(12.0)),
            controlPoint1: CGPoint(x: scaleX(4.6), y: scaleY(22.0)),
            controlPoint2: CGPoint(x: scaleX(19.1), y: scaleY(9.7))
        )

        path.addCurve(
            to: CGPoint(x: scaleX(89.0), y: scaleY(14.0)),
            controlPoint1: CGPoint(x: scaleX(59.2), y: scaleY(15.2)),
            controlPoint2: CGPoint(x: scaleX(61.9), y: scaleY(31.5))
        )

        path.addCurve(
            to: CGPoint(x: scaleX(104.0), y: scaleY(15.0)),
            controlPoint1: CGPoint(x: scaleX(95.3), y: scaleY(10.0)),
            controlPoint2: CGPoint(x: scaleX(100.9), y: scaleY(6.9))
        )

        path.close()
        return path
    }
}
