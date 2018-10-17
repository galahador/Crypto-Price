//
//  GetHistoricalData.swift
//  CryptoPrice
//
//  Created by Petar Lemajic on 10/17/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//

import UIKit
import Alamofire

class HistoricalData {

    func getHistoricalData(symbol: String, coin: Coin) {
        Alamofire.request("https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=30").responseJSON { (response)
            in
            if let json = response.result.value as? [String: Any] {
                if let pricesJSON = json["Data"] as? [[String: Double]] {
                    coin.historicalData = []
                    for priceJSON in pricesJSON {
                        if let closePrices = priceJSON["close"] {
                            coin.historicalData.append(closePrices)
                        }
                    }
                    CoinData.shared.delegate?.newHistory?()
                    UserDefaults.standard.set(coin.historicalData, forKey: symbol + "history")
                }
            }
        }
    }
}
