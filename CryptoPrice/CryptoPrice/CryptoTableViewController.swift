//
//  CryptoTableViewController.swift
//  CryptoPrice
//
//  Created by Petar Lemajic on 9/19/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//

import UIKit
import LocalAuthentication

private let headerHight: CGFloat = 100.0
private let networthHeight: CGFloat = 45.0
private let amountLabelFontSize: CGFloat = 60.0

class CryptoTableViewController: UITableViewController, CoinDataDelegate {

    var amountLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.getPrices()
        tableView.rowHeight = 70.0
        checkEvaluatePolicy()
    }

    override func viewWillAppear(_ animated: Bool) {
        CoinData.shared.delegate = self
        tableView.reloadData()
        displeyNetworth()
    }

    func newPrices() {
        displeyNetworth()
        tableView.reloadData()
    }

    fileprivate func checkEvaluatePolicy () {
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            updateSeureButton()
        }
    }

    fileprivate func headerView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerHight))
        headerView.backgroundColor = .white

        networthLabelSetup(with: headerView)
        amountLabelSetup(with: headerView)
        displeyNetworth()

        return headerView
    }

    //MARK: - Label setup and logic
    fileprivate func networthLabelSetup(with headerView: UIView) {
        let networthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: networthHeight))
        networthLabel.text = "My Cryto net worth"
        networthLabel.textAlignment = .center
        headerView.addSubview(networthLabel)
    }

    fileprivate func amountLabelSetup(with headerView: UIView) {
        amountLabel.frame = CGRect(x: 0, y: networthHeight, width: view.frame.size.width, height: headerHight - networthHeight)
        amountLabel.textAlignment = .center
        amountLabel.font = UIFont.boldSystemFont(ofSize: amountLabelFontSize)
        headerView.addSubview(amountLabel)
    }

    fileprivate func displeyNetworth() {
        amountLabel.text = CoinData.shared.networthAsString()
    }

    //MARK: - Security logic
    fileprivate func updateSeureButton() {
        if UserDefaults.standard.bool(forKey: "secure") {
            navigationItemSetup(title: "Unsecure App")
        } else {
            navigationItemSetup(title: "Secure App")
        }
    }

    @objc fileprivate func sucureButtonTapped() {
        if UserDefaults.standard.bool(forKey: "secure") {
            UserDefaults.standard.set(false, forKey: "secure")
        } else {
            UserDefaults.standard.set(true, forKey: "secure")
        }
        updateSeureButton()
    }

    //MARK: Navigation item setup
    fileprivate func navigationItemSetup(title: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(sucureButtonTapped))
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHight
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoinData.shared.coins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let coin = CoinData.shared.coins[indexPath.row]

        if coin.amount == 0.0 {
            cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString()) - \(coin.amount)"
            cell.imageView?.image = coin.image
        } else {
            cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString())"
            cell.imageView?.image = coin.image
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinVC = CoinViewController()
        coinVC.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinVC, animated: true)
    }
}
