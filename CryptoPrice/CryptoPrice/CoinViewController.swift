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

class CoinViewController: UIViewController, CoinDataDelegate {

    var chart = Chart()
    var coin: Coin?

    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.delegate = self
        setupView()
        setupChar()

    }

    fileprivate func setupView() {
        edgesForExtendedLayout = []
        view.backgroundColor = .white
    }

    fileprivate func setupChar() {
        chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHight)
        chart.yLabelsFormatter = { CoinData.shared.doubleToMoneyString(double: $1) }
        chart.xLabels = [0, 5, 10, 15, 20, 25, 30]
        chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
        let series = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
        chart.add(series)
        view.addSubview(chart)
        coin?.getHistoricalData()
    }

    func newHistory() {
        if let coin = coin {
            let series = ChartSeries(coin.historicalData)
            series.area = true
            chart.add(series)
        }
    }
}
