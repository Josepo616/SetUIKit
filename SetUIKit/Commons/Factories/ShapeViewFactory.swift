//
//  ShapeViewFactory.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

struct ShapeViewFactory {

    static func createShapeView(with shape: Shape, count: Int) -> UIView {
        let shapeView = UIView(frame: shape.frame)
        shapeView.backgroundColor = .clear
        shapeView.subviews.forEach {
            $0.removeFromSuperview()
        }
        let label = UILabel(frame: shapeView.bounds)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = ShapeViewConfiguration.attributedText(
            for: shape,
            count: count
        )
        shapeView.addSubview(label)
        return shapeView
    }
}
