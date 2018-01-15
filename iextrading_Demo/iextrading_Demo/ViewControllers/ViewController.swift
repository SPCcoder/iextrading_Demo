//
//  ViewController.swift
//  iextrading_Demo
//
//  Created by Apple on 15/01/2018.
//  Copyright © 2018 com.spcarlin. All rights reserved.
//


import UIKit
//keys - with a bigger project I might put these in their own 'constants' file, or use an 'constants' enum
let ENDPOINT_BASE = "https://api.iextrading.com/1.0"
let ENDPOINT_TOP_GAINERS = "https://api.iextrading.com/1.0/stock/market/list/gainers"
let KEY_STOCK_DETAIL_VIEW_CONTROLLER = "StockDetailViewController"
let KEY_STOCK_CELL_IDENTIFIER = "StockCell"
let KEY_TOP_GAINERS = "Top Gainers"

class ViewController: UIViewController {
    
    @IBOutlet weak var stockTableView: UITableView!
    var stockArray : [Stock] = [] //store what we get back from call for top gainers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = KEY_TOP_GAINERS
    }
    
    
    @IBAction func updateGainers(_ sender: Any) {
        //TODO: add activity indicator so user knows the app is trying to perform task
        let webHelper = WebHelper()
        
        webHelper.getTopGainers(at: ENDPOINT_TOP_GAINERS, completion: { (result) in
            switch result {
            case let .success(stocks):
                self.stockArray = stocks
                DispatchQueue.main.async {
                    self.stockTableView.reloadData()
                }
            case let .error(error):
                print(error)
                
                //TODO: show alert to tell user we can not get data
            }
        })
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stockCell : StockTableViewCell = tableView.dequeueReusableCell(withIdentifier: KEY_STOCK_CELL_IDENTIFIER) as? StockTableViewCell else {
            return UITableViewCell()
        }
        let stock = self.stockArray[indexPath.row]
        populate(stockCell: stockCell, withStock: stock)
        return stockCell
    }
    
    func populate(stockCell : StockTableViewCell, withStock stock : Stock){  //TODO: put somewhere better later
        stockCell.companyNameLabel.text = stock.companyName
        stockCell.companySymbolLabel.text = stock.symbol
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = "."
        stockCell.currentPriceLabel.text = "$" + String(format: "%.2f", stock.latestPrice)
        stockCell.percentChangeLabel.text = String(format: "%.2f", stock.changePercent)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: KEY_STOCK_DETAIL_VIEW_CONTROLLER) as? StockDetailViewController {
            if let navigator = navigationController {
                let backItem = UIBarButtonItem()
                backItem.title = "Back"
                navigationItem.backBarButtonItem = backItem
                detailVC.stock = self.stockArray[indexPath.row]
                detailVC.title = self.stockArray[indexPath.row].symbol
                
                navigator.pushViewController(detailVC, animated: true)
            }
        }
    }
    
}




