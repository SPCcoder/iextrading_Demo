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
    var stock : Stock?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
