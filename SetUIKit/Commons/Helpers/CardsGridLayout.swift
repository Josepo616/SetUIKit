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
    let hiddeButton: Bool

    var contentSize: CGSize? {
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
        let maxAspectRatio: CGFloat = 2.0
        let minCardWidth: CGFloat = 50
        var bestLayout: CardsGridLayout?
        var maxCardArea: CGFloat = 0

        for columns in 1...cardCount {
            let rows = (cardCount + columns - 1) / columns
            let totalHorizontalPadding = CGFloat(columns + 1) * padding
            let totalVerticalPadding = CGFloat(rows + 1) * padding
            let availableWidth = size.width - totalHorizontalPadding
            let availableHeight = size.height - totalVerticalPadding
            let cardWidth = availableWidth / CGFloat(columns)
            var cardHeight = availableHeight / CGFloat(rows)

            if cardWidth < minCardWidth { continue }

            if cardHeight / cardWidth > maxAspectRatio {
                cardHeight = cardWidth * maxAspectRatio
            }

            let cardSize = CGSize(width: cardWidth, height: cardHeight)
            let cardArea = cardSize.width * cardSize.height

            if cardArea > maxCardArea {
                maxCardArea = cardArea
                bestLayout = CardsGridLayout(
                    cardSize: cardSize,
                    columns: columns,
                    rows: rows,
                    padding: padding,
                    totalCards: cardCount,
                    hiddeButton: cardCount >= 24
                )
            }
        }
        return bestLayout!
    }

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
}
