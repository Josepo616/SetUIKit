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
    let isScrollable: Bool

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
        let minCardWidth: CGFloat = 50
        let maxColumns = Int(size.width / (minCardWidth + padding))
        let columns = max(1, min(maxColumns, cardCount))
        let rows = (cardCount + columns - 1) / columns
        let totalHorizontalPadding = CGFloat(columns + 1) * padding
        let availableWidth = size.width - totalHorizontalPadding
        let cardWidth = availableWidth / CGFloat(columns)
        let isScrollable = cardCount >= 30
        var cardHeight: CGFloat
        if isScrollable {
            cardHeight = cardWidth * 2
        } else {
            let totalVerticalPadding = CGFloat(rows + 1) * padding
            let availableHeight = size.height - totalVerticalPadding
            cardHeight = availableHeight / CGFloat(rows)
            let maxAspectRatio: CGFloat = 2.0
            if cardHeight / cardWidth > maxAspectRatio {
                cardHeight = cardWidth * maxAspectRatio
            }
        }
        let cardSize = CGSize(width: cardWidth, height: cardHeight)
        return CardsGridLayout(
            cardSize: cardSize,
            columns: columns,
            rows: rows,
            padding: padding,
            totalCards: cardCount,
            isScrollable: isScrollable
        )
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
