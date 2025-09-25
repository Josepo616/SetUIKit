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
    private var selectedCards: [Card] = []
    private var mappedCardIDs: [UUID] = []
    private var scoreUpdated: Bool = false
    weak var delegate: GameViewControllerDelegate?
    var visibleCards: [Card]
    var gameState: GameState
    var shouldHiddeButton: Bool = true

    init(
        startedAmount: Int,
        allCards: [Card],
        targetScrollView: UIScrollView,
        gameState: GameState
    ) {
        self.visibleCards = Array(allCards.prefix(startedAmount))
        self.cardsRemaining = Array(allCards.dropFirst(startedAmount))
        self.targetScrollView = targetScrollView
        self.gameState = gameState
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
        else {
            return
        }
        selectedCards = visibleCards.filter { $0.isSelected }
        if visibleCards[index].isSelected && selectedCards.count < 3 {
            visibleCards[index].isSelected = false
        } else if selectedCards.count < 4 {
            visibleCards[index].isSelected = true
        }
        selectedCards = visibleCards.filter { $0.isSelected }
        if selectedCards.count == 3 {
            if !isValidSet(selectedCards) {
                validSet = false
            } else {
                validSet = true
            }
            showAlertEvaluationCard()
            if !scoreUpdated{
                updateScore()
                scoreUpdated = true
            }
        }
        if selectedCards.count == 4 {
            let tappedCard = visibleCards[index]
            if let selectedIndex = selectedCards.firstIndex(where: {
                $0.id == tappedCard.id
            }) {
                selectedCards.remove(at: selectedIndex)
            }
            if !validSet {
                deselectAll(selectedCards)
            } else {
                addMoreCards(selectedCards)
            }
            scoreUpdated = false
            self.setupCardsGrid()
            return
        }
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
        if layout.hiddeButton {
            //self.delegate?.shouldAddCardsButtonHidde(to: self.shouldHiddeButton)
        }
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

    func deselectAll(_ selectedCards: [Card]? = nil) {
        if let selectedCards = selectedCards {
            for card in selectedCards {
                guard let index = visibleCards.firstIndex(of: card) else {
                    continue
                }
                visibleCards[index].isSelected = false
            }
            return
        }
    }

    func addMoreCards(count: Int = 3, _ selectedCards: [Card]? = nil) {
        let selectedCards =
            selectedCards ?? visibleCards.filter { $0.isSelected }
        guard selectedCards.count == 3 else {
            addCards(count: count)
            setupCardsGrid()
            return
        }
        self.validSet = isValidSet(selectedCards)
        let selectedIDs = Set(selectedCards.map { $0.id })
        if self.validSet {
            let indicesToReplace = self.visibleCards.enumerated()
                .filter { selectedIDs.contains($0.element.id) }
                .map { $0.offset }
            self.visibleCards.removeAll { selectedIDs.contains($0.id) }
            let cardsToAdd = self.cardsRemaining.prefix(indicesToReplace.count)
            self.cardsRemaining.removeFirst(
                min(indicesToReplace.count, self.cardsRemaining.count)
            )
            replaceCards(at: indicesToReplace, with: Array(cardsToAdd))
        } else {
            self.deselectAll(selectedCards)
            self.addCards(count: count)
        }
        setupCardsGrid()
        delegateRemaingCardsCount()
    }

    func shuffleVisibleCards() {
        visibleCards.shuffle()
    }

    // MARK: - Private Helper Methods
    private func replaceCards(at indices: [Int], with newCards: [Card]) {
        for (i, newCard) in newCards.enumerated() {
            let index = indices[i]
            self.visibleCards.insert(
                newCard,
                at: min(index, self.visibleCards.count)
            )
        }
    }

    private func addCards(count: Int) {
        cardsRemaining.removeAll { card in
            visibleCards.contains(where: { $0.id == card.id })
        }
        let cardsToAdd = cardsRemaining.prefix(count).filter { newCard in
            !visibleCards.contains(where: { $0.id == newCard.id })
        }
        visibleCards.append(contentsOf: cardsToAdd)
        cardsRemaining.removeFirst(min(count, cardsRemaining.count))
        delegateRemaingCardsCount()
    }

    private func delegateRemaingCardsCount() {
        if cardsRemaining.isEmpty {
            self.delegate?.shouldAddCardsButtonHidde(to: self.shouldHiddeButton)
        }
    }

    private func updateScore() {
        score += validSet ? 3 : -1
        delegate?.didUpdateScore(to: score)
    }

    func showAlertEvaluationCard() {
        for card in self.visibleCards {
            guard self.cardViewsByID[card.id] != nil else {
                continue
            }
            if card.isSelected {
                let message =
                    self.validSet
                    ? "Set valid, keep going!" : "Invalid Set, try again!"
                delegate?.showSnackbarMessage(message: message)
            }
        }
    }

    // MARK: - Utility Method for Set Validation
    private func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
        let unique = Set(values)
        return unique.count == 1 || unique.count == 3
    }
}
