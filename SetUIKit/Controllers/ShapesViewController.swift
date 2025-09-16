//
//  ShapesViewController.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

class ShapesViewController: UIViewController {

    private var allCards = CardsFactory.makeCards()
    private var visibleCards: [Card] = []
    
    private let padding: CGFloat = 16
    private let startedAmount: Int
    private weak var targetScrollView: UIScrollView?

    init(startedAmount: Int, targetScrollView: UIScrollView) {
        self.startedAmount = startedAmount
        self.targetScrollView = targetScrollView
        super.init(nibName: nil, bundle: nil)

        visibleCards = Array(allCards.prefix(startedAmount))
        allCards.removeFirst(min(startedAmount, allCards.count))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardsGrid()
    }

    private func setupCardsGrid() {
        guard let scrollView = targetScrollView else { return }

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
            
            cardView.onCardSelected = { [weak self] in
                self?.updateSelectedCountLabel()
            }
            
            scrollView.addSubview(cardView)
        }
        scrollView.contentSize = layout.contentSize
    }
    
    func countSelectedCards() -> Int {
        let selectedCards = visibleCards.filter { $0.isSelected }
        print("Cartas seleccionadas:", selectedCards.map { $0.id }) // si Card tiene id
        print("Total cards: \(visibleCards.count)")
        return selectedCards.count
    }

    
    // Actualiza la UI con el número de tarjetas seleccionadas
    func updateSelectedCountLabel() {
        let selectedCount = countSelectedCards()
        print ("Seleccionadas: \(selectedCount)")
    }

    func addMoreCards(_ count: Int = 3) {
        let cardsToAdd = allCards.prefix(count)
        visibleCards.append(contentsOf: cardsToAdd)
        allCards.removeFirst(min(count, allCards.count))
        setupCardsGrid()
    }
}
