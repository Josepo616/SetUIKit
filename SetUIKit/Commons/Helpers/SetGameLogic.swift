//
//  GameLogic.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/18/25.
//

import UIKit

class SetGameLogic {

    private let targetScrollView: UIScrollView
    private(set) var cardsRemaining: [Card]
    private(set) var validSet: Bool = false
    private(set) var score: Int = 0
    private var cardViewsByID: [UUID: CardView] = [:]
    weak var delegate: GameViewControllerDelegate?
    var visibleCards: [Card]
    var shouldHiddeButton: Bool = true

    init(startedAmount: Int, allCards: [Card], targetScrollView: UIScrollView) {
        self.visibleCards = Array(allCards.prefix(startedAmount))
        self.cardsRemaining = Array(allCards.dropFirst(startedAmount))
        self.targetScrollView = targetScrollView
    }

    // MARK: - Game rules
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
                validSet = false
                showAlertEvaluationCard()
                updateScore()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.deselectAll()
                    self.visibleCards[index].isSelected = true
                    self.setupCardsGrid()
                }
            } else {
                validSet = true
                showAlertEvaluationCard()
                addMoreCards()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let newIndex = self.visibleCards.firstIndex(where: { $0.id == tappedCardID }) {
                        self.visibleCards[newIndex].isSelected = true
                    }
                    self.setupCardsGrid()
                }
            }
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

    func evaluateSelectedCards(onValid: () -> Void, onInvalid: () -> Void) {
        let selectedCards = visibleCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            if isValidSet(selectedCards) {
                let selectedIDs = Set(selectedCards.map { $0.id })
                visibleCards.removeAll { selectedIDs.contains($0.id) }
                onValid()
            } else {
                deselectAll()
                onInvalid()
            }
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
        cardViewsByID.removeAll()
        for (index, card) in visibleCards.enumerated() {
            let frame = layout.frameForCard(at: index)
            let cardView = CardView(card: card, size: frame.size)
            cardView.frame = frame
            cardView.onCardTapped = { [weak self] tappedCardID in
                guard let self else { return }
                self.handleCardTap(tappedCardID, in: scrollView)
            }
            cardView.updateSelection(isSelected: card.isSelected)
            scrollView.addSubview(cardView)
            cardViewsByID[card.id] = cardView
        }
        scrollView.contentSize = layout.contentSize ?? .zero
    }

    func deselectAll() {
        for i in visibleCards.indices {
            visibleCards[i].isSelected = false
        }
    }

    func addMoreCards(count: Int = 3) {
        let selectedCards = visibleCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            self.validSet = isValidSet(selectedCards)
            showAlertEvaluationCard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let selectedIDs = Set(selectedCards.map { $0.id })
                if self.validSet {
                    let indicesToReplace = self.visibleCards.enumerated()
                        .filter { selectedIDs.contains($0.element.id) }
                        .map { $0.offset }
                    self.visibleCards.removeAll { selectedIDs.contains($0.id) }
                    let cardsToAdd = self.cardsRemaining.prefix(indicesToReplace.count)
                    self.cardsRemaining.removeFirst(min(indicesToReplace.count, self.cardsRemaining.count))
                    for (i, newCard) in cardsToAdd.enumerated() {
                        let index = indicesToReplace[i]
                        self.visibleCards.insert(newCard, at: min(index, self.visibleCards.count))
                    }
                } else {
                    self.deselectAll()
                    self.addCards(count: count)
                }
                self.setupCardsGrid()
                self.updateScore()
            }
        } else {
            addCards(count: count)
            self.setupCardsGrid()
        }
    }

    func shuffleVisibleCards() {
        visibleCards.shuffle()
    }

    // MARK: - Private Helper Methods
    private func addCards(count: Int) {
        cardsRemaining.removeAll { card in
            visibleCards.contains(where: { $0.id == card.id })
        }
        let cardsToAdd = cardsRemaining.prefix(count).filter { newCard in
            !visibleCards.contains(where: { $0.id == newCard.id })
        }
        visibleCards.append(contentsOf: cardsToAdd)
        cardsRemaining.removeFirst(min(count, cardsRemaining.count))
        if cardsRemaining.isEmpty {
            self.delegate?.didCardsRemainingOver(to: self.shouldHiddeButton)
        }
    }

    private func updateScore() {
        score += validSet ? 3 : -1
        delegate?.didUpdateScore(to: score)
    }

    private func showAlertEvaluationCard() {
        DispatchQueue.main.async {
            for card in self.visibleCards {
                guard let cardView = self.cardViewsByID[card.id] else {
                    continue
                }
                if card.isSelected {
                    let color = self.validSet ? UIColor.green : UIColor.red
                    cardView.layer.borderColor = color.cgColor
                    cardView.layer.borderWidth = 3
                    UIView.animate(withDuration: 0.3) {
                        cardView.alpha = 0.9
                        cardView.alpha = 1.0
                    }
                }
            }
        }
    }

    // MARK: - Utility Method for Set Validation
    private func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
        let unique = Set(values)
        return unique.count == 1 || unique.count == 3
    }
}
