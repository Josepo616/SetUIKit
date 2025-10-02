//
//  CardModelTests.swift
//  SetUIKitTests
//
//  Created by JoseAlvarez on 10/2/25.
//

import XCTest
@testable import SetUIKit

final class CardTests: XCTestCase {

    var card: Card!

    override func setUp() {
        super.setUp()
        card = CardStub.makeCard()
    }

    override func tearDown() {
        card = nil
        super.tearDown()
    }

    /// Given: a card obtained from a stable stub
    /// When: toggling isSelected from false to true
    /// Then: the property reflects the change
    func test_toggleIsSelectedProperty_shouldChangeState() {
        // Given
        XCTAssertFalse(card.isSelected, "Given: card should start unselected (false)")

        // When
        card.isSelected = true

        // Then
        XCTAssertTrue(card.isSelected, "Then: card should be selected (true) after toggling")
    }
}
