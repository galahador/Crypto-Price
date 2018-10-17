//
//  Prices.swift
//  CryptoPrice
//
//  Created by Petar Lemajic on 10/17/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//

import UIKit
import Alamofire

class Prices {
    weak var delegate: CoinDataDelegate?

    func getPrices(symbols: String, coins: [Coin]) {

        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(symbols)&tsyms=USD").responseJSON { (response)
            in
            print(response)
            if let json = response.result.value as? [String: Any] {
                for coin in coins {
                    if let coinJSON = json[coin.symbol] as? [String: Double] {
                        if let price = coinJSON["USD"] {
                            coin.price = price
                            UserDefaults.standard.set(price, forKey: coin.symbol)
                        }
                    }
                }
                self.delegate?.newPrices?()
            }
        }
    }
}
