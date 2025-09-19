//
//  ShapesViewControllerDelegate.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/18/25.
//

protocol GameViewControllerDelegate: AnyObject {
    func didUpdateScore(to score: Int)
    func gameDidStart(to gameState: GameState)
    func didRotationHappened(to hasRotated: Bool)
}
