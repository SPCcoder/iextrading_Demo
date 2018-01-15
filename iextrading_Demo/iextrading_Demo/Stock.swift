//
//  Stock.swift
//  iextrading_Demo
//
//  Created by Apple on 15/01/2018.
//  Copyright © 2018 com.spcarlin. All rights reserved.
//

import Foundation

struct Stock : Decodable {
    let symbol : String
    let companyName : String
    let open : Float
    let close : Float
    var latestPrice : Float
    var previousClose : Float
    var changePercent : Float // needs + or -
    var change : Float
 // logo here?
    
    
}
