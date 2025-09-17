//
//  ShapesViewController.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

class ShapesViewController: UIViewController {

    private var allCards = CardsFactory.makeCards()
    private(set) var cardsRemaining: [Card]
    private(set) var visibleCards: [Card] = []
    private var selectedCount = 0
    private let padding: CGFloat = 16
    private let startedAmount: Int
    private let targetScrollView: UIScrollView

    init(startedAmount: Int, targetScrollView: UIScrollView) {
        self.startedAmount = startedAmount
        self.targetScrollView = targetScrollView
        visibleCards = Array(allCards.prefix(startedAmount))
        cardsRemaining = Array(allCards)
        cardsRemaining.removeFirst(min(startedAmount, allCards.count))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardsGrid()
    }

    private func setupCardsGrid() {
        let scrollView = targetScrollView
        let layout = CardsGridLayout.calculateLayout(
            for: visibleCards.count,
            in: scrollView.bounds.size,
            padding: padding
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

        scrollView.contentSize = layout.contentSize
    }

    private func handleCardTap(_ tappedCardID: UUID, in scrollView: UIScrollView) {
        guard let index = visibleCards.firstIndex(where: { $0.id == tappedCardID }) else { return }

        var selectedCards = visibleCards.filter { $0.isSelected }

        if selectedCards.count == 3 && !visibleCards[index].isSelected {
            if !isValidSet(selectedCards) {
                deselectAll()
                visibleCards[index].isSelected = true
            } else {
                let tappedID = tappedCardID
                let selectedIDs = Set(selectedCards.map { $0.id })
                visibleCards.removeAll { selectedIDs.contains($0.id) }
                addMoreCards()

                if let newIndex = visibleCards.firstIndex(where: { $0.id == tappedID }) {
                    visibleCards[newIndex].isSelected = true
                }
            }

            setupCardsGrid()
            updateSelectedCountLabel()
            return
        }

        if visibleCards[index].isSelected {
            visibleCards[index].isSelected = false
        } else if selectedCards.count < 3 {
            visibleCards[index].isSelected = true
        }

        updateSelectedCountLabel()
        selectedCards = visibleCards.filter { $0.isSelected }

        if selectedCards.count == 3 {
            print(isValidSet(selectedCards) ? "✅ ¡Es un Set!" : "❌ No es un Set.")
        }

        if let tappedView = scrollView.subviews
            .compactMap({ $0 as? CardView })
            .first(where: { $0.card.id == tappedCardID }) {
            tappedView.updateSelection(isSelected: visibleCards[index].isSelected)
        }
    }

    private func deselectAll() {
        for i in visibleCards.indices {
            visibleCards[i].isSelected = false
        }
    }

    private func countSelectedCards() -> Int {
        visibleCards.filter { $0.isSelected }.count
    }

    func updateSelectedCountLabel() {
        selectedCount = countSelectedCards()
        print("Selected cards: \(selectedCount)")
    }

    func addMoreCards(_ count: Int = 3) {
        let selectedCards = visibleCards.filter { $0.isSelected }

        if selectedCards.count == 3 {
            if isValidSet(selectedCards) {
                let selectedIDs = Set(selectedCards.map { $0.id })
                visibleCards.removeAll { selectedIDs.contains($0.id) }
            } else {
                deselectAll()
            }
        }

        let cardsToAdd = cardsRemaining.prefix(count)
        visibleCards.append(contentsOf: cardsToAdd)
        cardsRemaining.removeFirst(min(count, cardsRemaining.count))
        setupCardsGrid()
        updateSelectedCountLabel()
    }

    func shuffleCards() {
        visibleCards.shuffle()
        setupCardsGrid()
    }

    private func isValidSet(_ cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }
        return Self.allSameOrAllDifferent(cards.map { $0.type })
            && Self.allSameOrAllDifferent(cards.map { $0.shading })
            && Self.allSameOrAllDifferent(cards.map { $0.color })
            && Self.allSameOrAllDifferent(cards.map { $0.count })
    }

    private static func allSameOrAllDifferent<T: Hashable>(_ values: [T]) -> Bool {
        let unique = Set(values)
        return unique.count == 1 || unique.count == 3
    }
}
