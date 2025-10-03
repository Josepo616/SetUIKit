//
//  MainViewControllerMock.swift
//  SetUIKit
//
//  Created by JoseAlvarez on 10/2/25.
//

import UIKit

@testable import SetUIKit

final class MainViewControllerMock: MainViewController {

    var scrollViewStrong: UIScrollView!
    var scoreLabelStrong: UILabel!
    var moreCardsButtonStrong: UIButton!
    var newGameButtonStrong: UIButton!
    var shuffleButtonStrong: UIButton!

    func setupOutletsForTesting() {
        self.view = UIView()
        scrollViewStrong = UIScrollView()
        scoreLabelStrong = UILabel()
        moreCardsButtonStrong = UIButton()
        newGameButtonStrong = UIButton()
        shuffleButtonStrong = UIButton()
        self.scrollView = scrollViewStrong
        self.scoreLabel = scoreLabelStrong
        self.moreCardsButton = moreCardsButtonStrong
        self.newGameButton = newGameButtonStrong
        self.shuffleButton = shuffleButtonStrong
        self.moreCardsButton.isHidden = true
    }
}
