//
//  ViewController.swift
//  iextrading_Demo
//
//  Created by Apple on 15/01/2018.
//  Copyright © 2018 com.spcarlin. All rights reserved.
//
/*
 • Top Gainers screen
 ○ List the stocks that are the current top gainers - tableview, I won't update changes live for simplicity, I'll probably have an 'update' button to fetch new data
 ○ Navigation bar title: "Top Gainers" - fine
 ○ Fields to be displayed on the table - custom cell with UILabels - I'll use the prototype cell in the tableview instead of an XIB for this small project
 § Stock Symbol
 § Company Name
 § Latest Price (formatted) - QUESTION - I'm assuming we want US dollars?
 § Change Percentage (formatted) (prefixed with a + for positive and - for negative)
 ○ Tapping the cell should take the user to the "Stock info screen" - part of the navigation control

 */
import UIKit
let endPoint = "https://api.iextrading.com/1.0" // this is needed for all api calls
class ViewController: UIViewController {

    @IBOutlet weak var stockTableView: UITableView!
    var stockArray : [Stock] = [] //store what we get back from call for top gainers
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func updateGainers(_ sender: Any) {//TODO: refactor, just checking func works
        let urlString =  endPoint + "/stock/market/list/gainers" // gives us top ten gainers
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing - swift 4
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let myStocks = try JSONDecoder().decode([Stock].self, from: data)
                print(myStocks)
                
                self.stockArray = myStocks
                DispatchQueue.main.async {
                    self.stockTableView.reloadData()
                }
                print(self.stockArray)
            } catch let jsonError {
                print("FAILED, Catch:")
                print(jsonError)
            }
            
            }.resume()
    }

}
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stockCell : StockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StockCell") as? StockTableViewCell else {
            return UITableViewCell()
        }
        let stock = self.stockArray[indexPath.row]
        stockCell.companyNameLabel.text = stock.companyName
        stockCell.companySymbolLabel.text = stock.symbol
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = "."
        stockCell.currentPriceLabel.text = "$" + String(format: "%.2f", stock.latestPrice)
        stockCell.percentChangeLabel.text = String(format: "%.2f", stock.changePercent)
        return stockCell
    }
    
        
    }




