//
//  SetGameViewControllerMock.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

import UIKit

@testable import SetUIKit

class SetGameViewControllerMock: SetGameViewController {
    let mockGameLogic: MockSetGameLogic
    init(gameLogic: MockSetGameLogic) {
        self.mockGameLogic = gameLogic
        super.init(
            startedAmount: 12,
            targetScrollView: UIScrollView(),
            gameState: .notStarted
        )
        self.gameLogic = mockGameLogic
    }
    required init?(coder: NSCoder) { fatalError() }
}
