//
//  StockDetailViewController.swift
//  iextrading_Demo
//
//  Created by Apple on 15/01/2018.
//  Copyright © 2018 com.spcarlin. All rights reserved.
//

import UIKit

class StockDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var latestPriceLabel: UILabel!
    @IBOutlet var percentChangeLabel: UILabel!
    @IBOutlet var currencyChangeLabel: UILabel!
    @IBOutlet var previousCloseLabel: UILabel!
    @IBOutlet weak var loadingImageLabel: UILabel!
    
    var stock : Stock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if stock != nil {
            stockNameLabel.text = stock!.companyName
            latestPriceLabel.text = "$" + String(format: "%.2f", stock!.latestPrice)
            percentChangeLabel.text = String(format: "%.2f", stock!.changePercent)
            currencyChangeLabel.text = String(format: "%.2f", stock!.change)
            previousCloseLabel.text = "$" + String(format: "%.2f", stock!.previousClose)
            
            getLogoURLFor(stockSymbol: stock!.symbol)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLogoURLFor(stockSymbol : String){
        
        let webHelper = WebHelper()
        webHelper.getCompanyLogoImage(forSymbol: stockSymbol, completion: { (result) in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {

                self.loadingImageLabel.isHidden = true
                self.imageView.image = image
                }
            case let .error(error):
                print(error)
                DispatchQueue.main.async {
                    self.loadingImageLabel.text = "Could not load company logo"
                    
                }
            }
        })
        
    }
    
    
}
