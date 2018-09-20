//
//  CoinViewController.swift
//  CryptoPrice
//
//  Created by Petar Lemajic on 9/19/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//

import UIKit
import SwiftChart

private let chartHight: CGFloat = 300.0
private let imageSize: CGFloat = 100.0
private let priceLabelHight: CGFloat = 25.0
private let userOwnLabelHight: CGFloat = 25.0

class CoinViewController: UIViewController, CoinDataDelegate {

    var chart = Chart()
    var coin: Coin?
    var priceLabel = UILabel()
    var userOwnLabel = UILabel()
    var worthLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.delegate = self
        setupView()
        setupChar()
        navigationEditButtonSetup()
    }

    fileprivate func setupView() {
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        title = coin?.symbol
    }

    fileprivate func setupChar() {
        if let coin = coin {
            chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHight)
            chart.yLabelsFormatter = { CoinData.shared.doubleToMoneyString(double: $1) }
            chart.xLabels = [0, 5, 10, 15, 20, 25, 30]
            chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
            let series = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
            chart.add(series)
            view.addSubview(chart)
            imageViewSetup(with: coin)
            priceLabelSetup()
            userOwnLabelSetup(coin: coin)
            worthLabelSetup(with: coin)
        }
    }
    //MARK: - Image and label setup logic
    fileprivate func imageViewSetup(with coin: Coin) {
        let imageView = UIImageView(frame: CGRect(x: view.frame.size.width / 2 - imageSize / 2, y: chartHight, width: imageSize, height: imageSize))
        view.addSubview(imageView)
        imageView.image = coin.image
        coin.getHistoricalData()
        newPrices()
    }

    fileprivate func priceLabelSetup() {
        priceLabel.frame = CGRect(x: 0, y: chartHight + imageSize, width: view.frame.size.width, height: priceLabelHight)
        priceLabel.textAlignment = .center
        view.addSubview(priceLabel)
    }

    fileprivate func userOwnLabelSetup(coin: Coin) {
        userOwnLabel.frame = CGRect(x: 0, y: chartHight + imageSize + priceLabelHight * 2, width: view.frame.size.width, height: userOwnLabelHight)
        userOwnLabel.textAlignment = .center
        userOwnLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        userOwnLabel.textAlignment = .center
        view.addSubview(userOwnLabel)
    }

    fileprivate func worthLabelSetup(with coin: Coin) {
        worthLabel.frame = CGRect(x: 0, y: chartHight + imageSize + priceLabelHight * 3, width: view.frame.size.width, height: userOwnLabelHight)
        worthLabel.textAlignment = .center
        worthLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        worthLabel.textAlignment = .center
        view.addSubview(worthLabel)
    }
    //MARK: - History and price logic
    func newHistory() {
        if let coin = coin {
            let series = ChartSeries(coin.historicalData)
            series.area = true
            chart.add(series)
        }
    }

    func newPrices() {
        if let coin = coin {
            priceLabel.text = coin.priceAsString()
            worthLabel.text = coin.amountAsString()
            userOwnLabel.text = "You own: \(coin.amount) \(coin.symbol)"
        }
    }

    //MARK: - Navigation item setup
    fileprivate func navigationEditButtonSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
    }

    @objc fileprivate func editButtonTapped() {
        alertViewSetup()
    }

    //MARK: - Alert View
    fileprivate func alertViewSetup() {
        if let coin = coin {
            let alertController = UIAlertController(title: "How much \(coin.symbol) do you own?", message: nil, preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "0.5"
                textField.keyboardType = .decimalPad
                if self.coin?.amount == 0.0 {
                    textField.text = String(coin.amount)
                }
            }
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if let text = alertController.textFields?[0].text {
                    if let amount = Double(text) {
                        self.coin?.amount = amount
                        self.newPrices()
                    }
                }
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
