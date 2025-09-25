//
//  ShapePath.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/25/25.
//

import UIKit

protocol ShapePath {
    func path(in rect: CGRect) -> UIBezierPath
}
