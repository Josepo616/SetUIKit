//
//  CardViewTests.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

import XCTest
@testable import SetUIKit

final class CardViewTests: XCTestCase {

    var sut: CardView!
    var card: Card!
    var size: CGSize!

    override func setUp() {
        super.setUp()
        card = CardStub.makeCard()
        size = CGSize(width: 100, height: 150)
        sut = CardView(card: card, size: size)
    }

    override func tearDown() {
        sut = nil
        card = nil
        size = nil
        super.tearDown()
    }

    /// Given: a CardView created with a stub card
    /// When: updateSelection(true) is called
    /// Then: the border color animates to cyan; updateSelection(false) restores label color
    func test_updateSelection_changesBorderColor() {
        // Given: Ensure initial state uses label color
        XCTAssertNotNil(sut.layer.borderColor)

        // When -> Then (selected = true)
        let exp1 = expectation(description: "Wait for selection animation to complete (true)")
        sut.updateSelection(isSelected: true)

        // Espera un poco más para la animación
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            // Then
            XCTAssertEqual(self.sut.layer.borderColor, UIColor.cyan.cgColor, "Border color should be cyan after selecting")
            exp1.fulfill()
        }

        wait(for: [exp1], timeout: 1.0)

        // When -> Then (selected = false)
        let exp2 = expectation(description: "Wait for selection animation to complete (false)")
        sut.updateSelection(isSelected: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            XCTAssertEqual(self.sut.layer.borderColor, UIColor.label.cgColor, "Border color should revert to label color after deselecting")
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 1.0)
    }
}
