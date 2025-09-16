//
//  SetGame.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/15/25.
//

import Foundation

struct SetGame {
    private(set) var cardsOnScreen: [Card] = []
    private(set) var cardsMatched: [Card] = []
    private(set) var cardsRemaining: [Card] = []
    private(set) var selectedCards: [Card] = []

    private(set) var isSetValid: Bool? = nil

    init() {
        startNewGame()
    }

    mutating func startNewGame() {
        cardsRemaining = CardsFactory.makeCards().shuffled()
        cardsOnScreen = []
        cardsMatched = []
        selectedCards = []
        isSetValid = nil
        //dealInitialCards()
    }

    mutating func choose(_ card: Card) {
        guard let index = cardsOnScreen.firstIndex(where: { $0.id == card.id })
        else { return }

        if selectedCards.contains(where: { $0.id == card.id }) {
            selectedCards.removeAll { $0.id == card.id }
            cardsOnScreen[index].isSelected = false
        } else {
            selectedCards.append(card)
            cardsOnScreen[index].isSelected = true
        }

        if selectedCards.count == 3 {
            if isValidSet(selectedCards) {
                isSetValid = true
                addMatchedCards()
            } else {
                isSetValid = false
                deselecCardsWithDelay()
            }
        }
    }

    private mutating func deselecCardsWithDelay() {
        let ids = selectedCards.map { $0.id }
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ids.forEach { id in
                if let index = self.cardsOnScreen.firstIndex(where: {
                    $0.id == id
                }) {
                    self.cardsOnScreen[index].isSelected = false

                }
            }
            self.selectedCards.removeAll()
            self.isSetValid = nil
        }*/
    }

    private mutating func addMatchedCards() {
        cardsMatched.append(contentsOf: selectedCards)

        for card in selectedCards {
            if let onScreenIndex = cardsOnScreen.firstIndex(where: {
                $0.id == card.id
            }) {
                if let newCard = cardsRemaining.first {
                    cardsOnScreen[onScreenIndex] = newCard
                    cardsRemaining.removeFirst()
                } else {
                    cardsOnScreen.remove(at: onScreenIndex)
                }
            }
        }

        selectedCards.removeAll()
        isSetValid = nil
    }

    mutating func addMoreCards(_ count: Int = 3) {
        let numToDeal = min(count, cardsRemaining.count)
        for _ in 0..<numToDeal {
            let card = cardsRemaining.removeFirst()
            cardsOnScreen.append(card)
        }
    }

    mutating func shuffledVisitCards() {
        cardsOnScreen.shuffle()
    }

    private func isValidSet(_ cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }
        return SetGame.allSameOrAllDiifferent(cards.map { $0.type })
            && SetGame.allSameOrAllDiifferent(cards.map { $0.shading })
            && SetGame.allSameOrAllDiifferent(cards.map { $0.color })
            && SetGame.allSameOrAllDiifferent(cards.map { $0.count })
    }

    private static func allSameOrAllDiifferent<T: Hashable>(_ values: [T])
        -> Bool
    {
        let unique = Set(values)
        return unique.count == 1 || unique.count == 3

    }
}
