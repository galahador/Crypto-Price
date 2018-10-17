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
    let prices = Prices()

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
            prices.getPrices(symbols: listOfSymbols, coins: coins)
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

    func html() -> String {
        var html = "<h1> Crypto Report </h1>"
        html += "<h2>Net Worth: \(networthAsString()) </h2>"
        for coin in coins {
            if coin.amount != 0 {
                html += "<li>\(coin.symbol) - I won: \(coin.amount) - Valued at: \(doubleToMoneyString(double: coin.amount * coin.price))  </li>"
            }
        }
        return html
    }
}
