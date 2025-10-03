//
//  SetGameCardsMock.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

@testable import SetUIKit

struct SetGameCardsMock {
    static func makeDeckMock() -> [Card] {
        return CardsFactory.makeCards()
    }
}
