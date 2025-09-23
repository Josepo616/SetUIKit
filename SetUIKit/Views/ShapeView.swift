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
            let shapeRect = CGRect(x: originX, y: originY, width: maxShapeSize, height: maxShapeSize)
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
        case .circle:
            return UIBezierPath(ovalIn: rect)
        case .square:
            return UIBezierPath(rect: rect)
        case .triangle:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.close()
            return path
        }
    }

    private func drawStripes(in shapeRect: CGRect, color: UIColor, shapeType: CardType) {
        let shapePath = path(for: shapeType, in: shapeRect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.saveGState()
        shapePath.addClip()
        let stripePath = UIBezierPath()
        let stripeSpacing: CGFloat = 5
        for x in stride(from: shapeRect.minX, to: shapeRect.maxX, by: stripeSpacing) {
            stripePath.move(to: CGPoint(x: x, y: shapeRect.minY))
            stripePath.addLine(to: CGPoint(x: x, y: shapeRect.maxY))
        }
        color.setStroke()
        stripePath.lineWidth = 0.5
        stripePath.stroke()
        context.restoreGState()
    }
}
