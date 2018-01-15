//
//  StockDetailViewController.swift
//  iextrading_Demo
//
//  Created by Apple on 15/01/2018.
//  Copyright © 2018 com.spcarlin. All rights reserved.
//

import UIKit
/*
 • Stock info screen
 ○ Navigation bar title: Stock Symbol - with back button
 ○ Info displayed:
 § Company name
 § Company Logo - UIImageView - will need to fetch image from somewhere, not sure I saw this in the api
 § Latest Price
 § Change Percentage (formatted) (prefixed with a + for positive and - for negative)
 § Change in currency (formatted) (prefixed with a + for positive and - for negative)
 Previous close price
 */
class StockDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var latestPriceLabel: UILabel!
    @IBOutlet var percentChangeLabel: UILabel!
    @IBOutlet var currencyChangeLabel: UILabel!
    @IBOutlet var previousCloseLabel: UILabel!
    
    var stock : Stock?
    
    @IBOutlet weak var loadingImageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if stock != nil {
            stockNameLabel.text = stock!.companyName
            latestPriceLabel.text = String(format: "%.2f", stock!.latestPrice)
            percentChangeLabel.text = String(format: "%.2f", stock!.changePercent)
            currencyChangeLabel.text = String(format: "%.2f", stock!.change)
            previousCloseLabel.text = String(format: "%.2f", stock!.previousClose)
            
            getLogoFor(stockSymbol: stock!.symbol)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLogoFor(stockSymbol : String){
        // var firehose = AWSFirehose.default()
        let urlString =  endPoint + "/stock/" + stockSymbol + "/logo"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("FAILED, data task error:")
                
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let logoURLString = try JSONDecoder().decode([String : String].self, from: data)
                let logoURL = logoURLString["url"]
                
                guard let url = URL(string: logoURL!) else { return }
                
                self.getImage(url: url)
                
                
            } catch let jsonError {
                print("FAILED, Catch:")
                print(jsonError)
            }
            
            }.resume()
    }
    
    
    func getImage(url : URL){
        let session = URLSession(configuration: .default)
        
        //creating a dataTask
        let getImageFromUrl = session.dataTask(with: url) { (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        DispatchQueue.main.async {
                            //getting the image
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                //displaying the image
                                if image != nil {
                                    self.imageView.image = image
                                    self.loadingImageLabel.isHidden = true
                                } else {
                                    self.loadingImageLabel.text = "Cannot load company logo."
                                    
                                }
                            }
                            
                        }
                        
                        
                    } else {
                        print("Image file is currupted")
                        self.loadingImageLabel.text = "Cannot load company logo."
                    }
                } else {
                    print("No response from server")
                    self.loadingImageLabel.text = "Cannot load company logo."
                    
                }
            }
        }
        
        //starting the download task
        getImageFromUrl.resume()
    }
    
}
