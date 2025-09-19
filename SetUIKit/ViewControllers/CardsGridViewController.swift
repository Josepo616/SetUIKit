//
//  CardsGridViewController.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 9/19/25.
//

import UIKit

class CardsGridViewController: UIViewController {
    var cardCount = 30
    var gridLayout: CardsGridLayout?
    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let size = view.bounds.size

        gridLayout = CardsGridLayout.calculateLayout(
            for: cardCount,
            in: size,
            padding: 10
        )

        if let layout = gridLayout {
            if layout.isScrollable {
                scrollView.isScrollEnabled = true
                if let contentSize = layout.contentSize {
                    scrollView.contentSize = contentSize
                }
            } else {
                scrollView.isScrollEnabled = false
            }
        }

        let gridView = UIView()
        scrollView.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            gridView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            gridView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            gridView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        for i in 0..<cardCount {
            let cardFrame = gridLayout?.frameForCard(at: i) ?? CGRect.zero
            let cardView = UIView(frame: cardFrame)
            cardView.backgroundColor = .blue
            cardView.layer.cornerRadius = 8
            gridView.addSubview(cardView)
        }
    }
}
