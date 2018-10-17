//
//  CoinDataProtocol.swift
//  CryptoPrice
//
//  Created by Petar Lemajic on 10/17/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//

import Foundation

@objc protocol CoinDataDelegate {
    @objc optional func newPrices()
    @objc optional func newHistory()
}
