//
//  ShapeView.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/23/25.
//

import UIKit

class ShapeView: UIView {
    var shape: Shape
    var count: Int

    init(frame: CGRect, shape: Shape, count: Int) {
        self.shape = shape
        self.count = count
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard count > 0 else { return }

        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        let color = UIColor.from(cardColor: shape.color)
        let spacing: CGFloat = 10
        let availableHeight = rect.height
        let totalSpacing = CGFloat(count - 1) * spacing
        let maxPossibleHeightPerShape = (availableHeight - totalSpacing) / CGFloat(count)
        let maxShapeSize = min(rect.width * 0.6, maxPossibleHeightPerShape)
        let totalContentHeight = (CGFloat(count) * maxShapeSize) + totalSpacing
        let startY = (rect.height - totalContentHeight) / 2
        for i in 0..<count {
            let originY = startY + CGFloat(i) * (maxShapeSize + spacing)
            let originX = (rect.width - maxShapeSize) / 2
            let shapeRect = CGRect(
                x: originX,
                y: originY,
                width: maxShapeSize,
                height: maxShapeSize
            )
            let path = path(for: shape.type, in: shapeRect)
            switch shape.shading {
            case .filled:
                color.setFill()
                path.fill()
            case .empty:
                color.setStroke()
                path.lineWidth = 3
                path.stroke()
            case .striped:
                color.setStroke()
                path.lineWidth = 1.5
                path.stroke()
                drawStripes(in: shapeRect, color: color, shapeType: shape.type)
            }
        }
        context?.restoreGState()
    }

    private func path(for type: CardType, in rect: CGRect) -> UIBezierPath {
        switch type {
        case .diamond:
            return diamondPath(in: rect)
        case .rectangle:
            return customRectanglePath(in: rect)
        case .squiggle:
            return squigglePath(in: rect)
        }
    }
    private func drawStripes(
        in shapeRect: CGRect,
        color: UIColor,
        shapeType: CardType
    ) {
        let shapePath = path(for: shapeType, in: shapeRect)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.saveGState()
        shapePath.addClip()
        let stripePath = UIBezierPath()
        let stripeSpacing = shapeRect.width / 10
        let extendedRect = shapeRect.insetBy(dx: -10, dy: 0)

        for x in stride(
            from: extendedRect.minX,
            to: extendedRect.maxX,
            by: stripeSpacing
        ) {
            stripePath.move(to: CGPoint(x: x, y: extendedRect.minY))
            stripePath.addLine(to: CGPoint(x: x, y: extendedRect.maxY))
        }

        color.setStroke()
        stripePath.lineWidth = 0.5
        stripePath.stroke()
        context.restoreGState()
    }
    
    private func customRectanglePath(in rect: CGRect) -> UIBezierPath {
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

    
    private func diamondPath(in rect: CGRect) -> UIBezierPath {
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


    private func squigglePath(in bounds: CGRect) -> UIBezierPath {
        let originalMinX: CGFloat = 5.0
        let originalMaxX: CGFloat = 112.4
        let originalMinY: CGFloat = 6.9
        let originalMaxY: CGFloat = 65.6

        let originalWidth = originalMaxX - originalMinX
        let originalHeight = originalMaxY - originalMinY

        let horizontalStretchFactor: CGFloat = 1.5
        let adjustedWidth = bounds.width * horizontalStretchFactor
        let centeringOffset = (bounds.width - adjustedWidth) / 2

        func scaleX(_ x: CGFloat) -> CGFloat {
            let scaled = ((x - originalMinX) / originalWidth) * adjustedWidth
            return bounds.origin.x + centeringOffset + scaled
        }

        func scaleY(_ y: CGFloat) -> CGFloat {
            return bounds.origin.y + ((y - originalMinY) / originalHeight)
                * bounds.height
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
