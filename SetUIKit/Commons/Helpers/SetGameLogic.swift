//
//  GameLogic.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/18/25.
//

import Foundation
import UIKit

class SetGameLogic {

    private(set) var cardsRemaining: [Card]
    private(set) var validSet: Bool = false
    private(set) var score: Int = 0
    private let targetScrollView: UIScrollView
    weak var delegate: ShapesViewControllerDelegate?
    var visibleCards: [Card]

    init(startedAmount: Int, allCards: [Card], targetScrollView: UIScrollView) {
        self.visibleCards = Array(allCards.prefix(startedAmount))
        self.cardsRemaining = Array(allCards.dropFirst(startedAmount))
        self.targetScrollView = targetScrollView
    }

    func isValidSet(_ cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }
        return allSameOrAllDifferent(cards.map { $0.type })
            && allSameOrAllDifferent(cards.map { $0.shading })
            && allSameOrAllDifferent(cards.map { $0.color })
            && allSameOrAllDifferent(cards.map { $0.count })
    }

    func handleCardTap(
        _ tappedCardID: UUID,
        in scrollView: UIScrollView
    ) {
        guard
            let index = visibleCards.firstIndex(where: { $0.id == tappedCardID }
            )
        else { return }

        var selectedCards = visibleCards.filter { $0.isSelected }
        if selectedCards.count == 3 && !visibleCards[index].isSelected {
            if !isValidSet(selectedCards) {
                deselectAll()
                visibleCards[index].isSelected = true
                validSet = false
                updateScore()
            } else {
                let tappedID = tappedCardID
                let selectedIDs = Set(selectedCards.map { $0.id })
                visibleCards.removeAll { selectedIDs.contains($0.id) }
                addMoreCards()
                if let newIndex = visibleCards.firstIndex(where: {
                    $0.id == tappedID
                }) {
                    visibleCards[newIndex].isSelected = true
                }
                validSet = true
                updateScore()
            }
            setupCardsGrid()
            return
        }
        if visibleCards[index].isSelected {
            visibleCards[index].isSelected = false
        } else if selectedCards.count < 3 {
            visibleCards[index].isSelected = true
        }
        selectedCards = visibleCards.filter { $0.isSelected }
        if let tappedView = scrollView.subviews
            .compactMap({ $0 as? CardView })
            .first(where: { $0.card.id == tappedCardID })
        {
            tappedView.updateSelection(
                isSelected: visibleCards[index].isSelected
            )
        }
    }

    func setupCardsGrid() {
        let scrollView = targetScrollView
        let layout = CardsGridLayout.calculateLayout(
            for: visibleCards.count,
            in: scrollView.bounds.size,
            padding: 16
        )
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        for (index, card) in visibleCards.enumerated() {
            let frame = layout.frameForCard(at: index)
            let cardView = CardView(card: card, size: frame.size)
            cardView.frame = frame
            cardView.onCardTapped = { tappedCardID in
                self.handleCardTap(tappedCardID, in: scrollView)
            }
            cardView.updateSelection(isSelected: card.isSelected)
            scrollView.addSubview(cardView)
        }
        if let contentSize = layout.contentSize {
            scrollView.contentSize = contentSize
        } else {
            scrollView.contentSize = .zero
        }
    }

    func deselectAll() {
        for i in visibleCards.indices {
            visibleCards[i].isSelected = false
        }
    }

    func addMoreCards(count: Int = 3) {
        let selectedCards = visibleCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            if isValidSet(selectedCards) {
                let selectedIDs = Set(selectedCards.map { $0.id })
                visibleCards.removeAll { selectedIDs.contains($0.id) }
            } else {
                deselectAll()
            }
        }
        cardsRemaining.removeAll { card in
            visibleCards.contains(where: { $0.id == card.id })
        }
        let cardsToAdd = cardsRemaining.prefix(count).filter { newCard in
            !visibleCards.contains(where: { $0.id == newCard.id })
        }
        visibleCards.append(contentsOf: cardsToAdd)
        cardsRemaining.removeFirst(min(count, cardsRemaining.count))
    }

    func shuffleVisibleCards() {
        visibleCards.shuffle()
    }

    private func updateScore() {
        score += validSet ? 3 : -1
        delegate?.didUpdateScore(to: score)
    }

    private func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
        let unique = Set(values)
        return unique.count == 1 || unique.count == 3
    }
}
