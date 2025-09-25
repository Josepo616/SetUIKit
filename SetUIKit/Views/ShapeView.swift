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
        let maxPossibleHeightPerShape =
            (availableHeight - totalSpacing) / CGFloat(count)
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
            let path = shape.type.path(in: shapeRect)
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

    private func drawStripes(
        in shapeRect: CGRect,
        color: UIColor,
        shapeType: CardType
    ) {
        let shapePath = shapeType.path(in: shapeRect)
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
}
