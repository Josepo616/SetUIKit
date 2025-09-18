//
//  CardsGridLayout.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

struct CardsGridLayout {
    let cardSize: CGSize
    let columns: Int
    let rows: Int
    let padding: CGFloat
    let totalCards: Int

    func frameForCard(at index: Int) -> CGRect {
        let row = index / columns
        let col = index % columns

        let x = CGFloat(col) * (cardSize.width + padding) + padding
        let y = CGFloat(row) * (cardSize.height + padding) + padding

        return CGRect(
            x: x,
            y: y,
            width: cardSize.width,
            height: cardSize.height
        )
    }

    var contentSize: CGSize {
        let height = CGFloat(rows) * (cardSize.height + padding) + padding
        return CGSize(
            width: CGFloat(columns) * (cardSize.width + padding) + padding,
            height: height
        )
    }

    static func calculateLayout(
        for cardCount: Int,
        in size: CGSize,
        padding: CGFloat
    ) -> CardsGridLayout {
        let minCardWidth: CGFloat = 50

        let maxColumns = Int(size.width / (minCardWidth + padding))
        let columns = max(1, min(maxColumns, cardCount))

        let rows = (cardCount + columns - 1) / columns

        let totalHorizontalPadding = CGFloat(columns + 1) * padding
        let availableWidth = size.width - totalHorizontalPadding
        let cardWidth = availableWidth / CGFloat(columns)

        let totalVerticalPadding = CGFloat(rows + 1) * padding
        let availableHeight = size.height - totalVerticalPadding
        var cardHeight = availableHeight / CGFloat(rows)

        let maxAspectRatio: CGFloat = 2.0
        if cardHeight / cardWidth > maxAspectRatio {
            cardHeight = cardWidth * maxAspectRatio
        }

        let cardSize = CGSize(width: cardWidth, height: cardHeight)

        return CardsGridLayout(
            cardSize: cardSize,
            columns: columns,
            rows: rows,
            padding: padding,
            totalCards: cardCount
        )
    }
}

class CardsGridViewController: UIViewController {
    var cardCount = 30
    var gridLayout: CardsGridLayout?
    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let size = view.bounds.size
        gridLayout = CardsGridLayout.calculateLayout(for: cardCount, in: size, padding: 10)

        let gridView = UIView()
        scrollView.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            gridView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            gridView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            gridView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Mantener el ancho fijo
        ])

        if let contentSize = gridLayout?.contentSize {
            scrollView.contentSize = contentSize
        }

        for i in 0..<cardCount {
            let cardFrame = gridLayout?.frameForCard(at: i) ?? CGRect.zero
            let cardView = UIView(frame: cardFrame)
            cardView.frame = cardFrame
            cardView.backgroundColor = .blue 
            cardView.layer.cornerRadius = 8
            gridView.addSubview(cardView)
        }
    }
}
