//
//  ShapeViewConfiguration.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/18/25.
//

import UIKit

struct ShapeViewConfiguration {

    static func attributedText(for shape: Shape, count: Int)
        -> NSAttributedString
    {
        let symbol: String
        switch shape.type {
        case .triangle: symbol = "▲"
        case .circle: symbol = "●"
        case .square: symbol = "■"
        }
        let repeatedSymbols = Array(repeating: symbol, count: count).joined(
            separator: "\n"
        )
        let color = UIColor.from(cardColor: shape.color)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byClipping
        var attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 30, weight: .bold),
            .paragraphStyle: paragraphStyle,
        ]
        switch shape.shading {
        case .filled:
            attributes[.foregroundColor] = color
        case .empty:
            attributes[.strokeColor] = color
            attributes[.strokeWidth] = 3
        case .striped:
            attributes[.foregroundColor] = color.withAlphaComponent(0.15)
        }
        return NSAttributedString(
            string: repeatedSymbols,
            attributes: attributes
        )
    }
}
