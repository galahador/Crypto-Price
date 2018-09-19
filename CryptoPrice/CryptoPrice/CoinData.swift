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

        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(listOfSymbols)&tsyms=USD").responseJSON { (response) in
            if let json = response.result.value as? [String:Any] {
                for coin in self.coins {
                    if let coinJSON = json[coin.symbol] as? [String:Double] {
                        if let price = coinJSON["USD"] {
                            coin.price = price
                        }
                    }
                }
                self.delegate?.newPrices?() 
            }
        }
    }
}

@objc protocol CoinDataDelegate: class {
   @objc optional func newPrices()
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
    
    func priceAsString() -> String {
        if price == 0.0 {
            return "Loading . . ."
        }
        
        let formater = NumberFormatter()
        formater.locale = Locale(identifier: "en_US")
        formater.numberStyle = .currency
        if let fancyPrice = formater.string(from: NSNumber(floatLiteral: price)) {
            return fancyPrice
        } else {
            return "ERROR"
        }
    }
}
