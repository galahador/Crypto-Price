//
//  CoinData.swift
//  CryptoPrice
//
//  Created by Petar Lemajic on 9/19/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//
import UIKit
import Alamofire

class CoinData {
    static let shared = CoinData()
    var coins = [Coin]()
    weak var delegate: CoinDataDelegate?

    private init() {
        let symbols = ["BTC", "ETH", "LTC"]

        for symbol in symbols {
            let coin = Coin(symbol: symbol)
            coins.append(coin)
        }
    }

    func getPrices() {
        var listOfSymbols = ""
        for coin in coins {
            listOfSymbols += coin.symbol
            if coin.symbol != coins.last?.symbol {
                listOfSymbols += ","
            }
        }

        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(listOfSymbols)&tsyms=USD").responseJSON { (response)
            in
            if let json = response.result.value as? [String: Any] {
                for coin in self.coins {
                    if let coinJSON = json[coin.symbol] as? [String: Double] {
                        if let price = coinJSON["USD"] {
                            coin.price = price
                        }
                    }
                }
                self.delegate?.newPrices?()
            }
        }
    }

    func doubleToMoneyString(double: Double) -> String {
        let formater = NumberFormatter()
        formater.locale = Locale(identifier: "en_US")
        formater.numberStyle = .currency
        if let fancyPrice = formater.string(from: NSNumber(floatLiteral: double)) {
            return fancyPrice
        } else {
            return "ERROR"
        }
    }
    
    func networthAsString() -> String {
        var networth = 0.0
        for coin in coins {
            networth += coin.amount * coin.price
        }
        return doubleToMoneyString(double: networth)
    }

}

@objc protocol CoinDataDelegate: class {
    @objc optional func newPrices()
    @objc optional func newHistory()
}

class Coin {
    var symbol = ""
    var image = UIImage()
    var price = 0.0
    var amount = 0.0
    var historicalData = [Double]()

    init(symbol: String) {
        self.symbol = symbol
        if let image = UIImage(named: symbol) {
            self.image = image
        }
    }

    func getHistoricalData() {
        Alamofire.request("https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=30").responseJSON { (response)
            in
            if let json = response.result.value as? [String: Any] {
                if let pricesJSON = json["Data"] as? [[String: Double]] {
                    self.historicalData = []
                    for priceJSON in pricesJSON {
                        if let closePrices = priceJSON["close"] {
                            self.historicalData.append(closePrices)
                        }
                    }
                    CoinData.shared.delegate?.newHistory?()
                }
            }
        }
    }

    func priceAsString() -> String {
        if price == 0.0 {
            return "Loading . . ."
        }
        return CoinData.shared.doubleToMoneyString(double: price)
    }

    func amountAsString() -> String {
        return CoinData.shared.doubleToMoneyString(double: amount * price)
    }
}
