//
//  CardView.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/16/25.
//

import UIKit

class CardView: UIView {
    var card: Card
    private var shapeViews: [UIView] = []

    var onCardTapped: ((UUID) -> Void)?

    init(card: Card, size: CGSize) {
        self.card = card
        super.init(frame: .zero)

        self.frame.size = size
        self.setupCardView()
        self.setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCardView() {
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor

        let shapeSpacingRatio: CGFloat = 0.1
        let totalCount = CGFloat(card.count)
        let baseUnit = totalCount + (totalCount - 1) * shapeSpacingRatio

        let shapeHeight = self.frame.height / baseUnit
        let shapeSpacing = shapeHeight * shapeSpacingRatio
        let shapeWidth = min(self.frame.width * 0.8, self.frame.width - 8)

        let totalHeight =
            totalCount * shapeHeight + (totalCount - 1) * shapeSpacing
        let startY = max((self.frame.height - totalHeight) / 2, 0)

        for i in 0..<card.count {
            let shapeY = startY + CGFloat(i) * (shapeHeight + shapeSpacing)
            let shapeFrame = CGRect(
                x: (self.frame.width - shapeWidth) / 2,
                y: shapeY,
                width: shapeWidth,
                height: shapeHeight
            )

            let shapeView = ShapeViewFactory.createShapeView(
                with: Shape(
                    type: card.type,
                    color: card.color,
                    shading: card.shading,
                    frame: shapeFrame
                ),
            )
            self.addSubview(shapeView)
            shapeViews.append(shapeView)
        }
    }

    func updateSelection(isSelected: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor =
                isSelected ? UIColor.cyan.cgColor : UIColor.label.cgColor
        }
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(cardTapped)
        )
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func cardTapped() {
        onCardTapped?(card.id)
    }

}
