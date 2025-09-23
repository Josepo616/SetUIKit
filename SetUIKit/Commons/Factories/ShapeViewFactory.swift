//
//  ShapeViewFactory.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

struct ShapeViewFactory {
    static func createShapeView(with shape: Shape, count: Int) -> UIView {
        let shapeView = ShapeView(frame: shape.frame, shape: shape, count: count)
        return shapeView
    }
}
