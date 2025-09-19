//
//  ShapeViewFactory.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

struct ShapeViewFactory {

    static func createShapeView(
        with configuration: Shape
    ) -> UIView {
        let shapeView = UIView(frame: configuration.frame)
        shapeView.backgroundColor = .clear
        ShapeViewConfiguration.configure(shapeView, with: configuration)
        return shapeView
    }
}
