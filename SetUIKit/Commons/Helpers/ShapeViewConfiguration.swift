//
//  ShapeViewConfiguration.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/18/25.
//

import UIKit

struct ShapeViewConfiguration {

    static func configure(
        _ shapeView: UIView,
        with configuration: Shape
    ) {
        let drawingRect = calculateDrawingRect(
            for: shapeView,
            configuration: configuration
        )
        let outlineLayer = createOutlineLayer(
            for: configuration.type,
            in: drawingRect,
            color: configuration.color,
            shading: configuration.shading
        )
        shapeView.layer.addSublayer(outlineLayer)
        if configuration.shading == .striped {
            let stripesLayer = createStripesLayer(
                bounds: CGRect(origin: .zero, size: drawingRect.size),
                color: UIColor.from(cardColor: configuration.color)
            )
            stripesLayer.frame = drawingRect
            let maskLayer = CAShapeLayer()
            maskLayer.path = outlineLayer.path
            maskLayer.frame = CGRect(origin: .zero, size: drawingRect.size)
            stripesLayer.mask = maskLayer
            shapeView.layer.addSublayer(stripesLayer)
        }
    }

    // MARK: - Private Methods

    private static func calculateDrawingRect(
        for shapeView: UIView,
        configuration: Shape
    ) -> CGRect {
        let insetRatio: CGFloat = 0.1
        let minSide = min(shapeView.bounds.width, shapeView.bounds.height)
        let zoomedSide = minSide * (1 - insetRatio * 2)
        return CGRect(
            x: (shapeView.bounds.width - zoomedSide) / 2,
            y: (shapeView.bounds.height - zoomedSide) / 2,
            width: zoomedSide,
            height: zoomedSide
        )
    }

    private static func createOutlineLayer(
        for type: CardType,
        in drawingRect: CGRect,
        color: CardColor,
        shading: CardShading
    ) -> CAShapeLayer {
        let path = path(for: type, in: drawingRect.size)

        let outlineLayer = CAShapeLayer()
        outlineLayer.path = path.cgPath
        outlineLayer.strokeColor = UIColor.from(cardColor: color).cgColor
        outlineLayer.fillColor =
            (shading == .filled)
            ? UIColor.from(cardColor: color).cgColor : UIColor.clear.cgColor
        outlineLayer.lineWidth = 2
        outlineLayer.frame = drawingRect
        return outlineLayer
    }

    private static func path(for type: CardType, in size: CGSize)
        -> UIBezierPath
    {
        switch type {
        case .square:
            return UIBezierPath(rect: CGRect(origin: .zero, size: size))
        case .circle:
            return UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
        case .triangle:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: size.width / 2, y: 0))
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            path.close()
            return path
        }
    }

    private static func createStripesLayer(bounds: CGRect, color: UIColor)
        -> CALayer
    {
        let stripeLayer = CALayer()
        stripeLayer.frame = bounds
        for i in stride(from: 0, to: Int(bounds.width), by: 6) {
            let line = CALayer()
            line.backgroundColor = color.withAlphaComponent(0.5).cgColor
            line.frame = CGRect(
                x: CGFloat(i),
                y: 0,
                width: 2,
                height: bounds.height
            )
            stripeLayer.addSublayer(line)
        }
        return stripeLayer
    }
}
