//
//  WebHelper.swift
//  iextrading_Demo
//
//  Created by Apple on 15/01/2018.
//  Copyright © 2018 com.spcarlin. All rights reserved.
//

import Foundation
import UIKit
enum Result<T> {
    case success(T)
    case error(Error)
}
enum LogoError: Error {
    // Invalid url string used
    case invalidURL(String)
    // Invalid data used
    case invalidData
}
class WebHelper {

    func getCompanyLogoImage(forSymbol symbol: String, completion: @escaping ((Result<UIImage>) -> ())) {
        
        //use api to get image location by asking based on company symbol
        
        self.getLogoLocation(forSymbol: symbol) { (result) in
            
            switch result {
                
            case let .error(error):
                completion(.error(error))//lets caller know we failed to get image at some point
                
            case let .success(urlString):
                //now we have a good url we can make call to get image from it
                print(urlString)
                guard let url = URL(string: urlString) else {
                    completion(.error(LogoError.invalidURL(urlString)))
                    return
                }
                
                let backgroundQueue = DispatchQueue.global(qos: .background)
                
                // Dispatch to background queue - for images
                backgroundQueue.async {
                    do {
                        let data = try Data(contentsOf: url)
                        
                        // Check if `UIImage` object can be constructed with data
                        guard let image = UIImage(data: data) else {
                            completion(.error(LogoError.invalidData))
                            return
                        }
                            
                            // Return successful result
                            completion(.success(image))
                        
                    } catch {
                     
                       completion(.error(error))
                    }
                }
            
            }
        }

    }

    func getLogoLocation(forSymbol symbol: String, completion: @escaping((Result<String>) -> ())) {
        
        let urlString =  ENDPOINT_BASE + "/stock/" + symbol + "/logo" //TODO: could make a function for this
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(.error(error!))
            }
            
            guard let data = data else { return }
            
            do {
                let dict = try JSONDecoder().decode([String : String].self, from: data)
                guard let logoURLString = dict["url"] else {return}
                
                completion(.success(logoURLString))

                
            } catch let jsonError {
                completion(.error(jsonError))
            }
            
            }.resume()
    }
    
    func getTopGainers(at urlString: String, completion: @escaping ((Result<[Stock]>) -> ())) {
        OperationQueue().addOperation {
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    completion(.error(error!))
                }
                
                guard let data = data else { return }
                
                do {
                    let stocks = try JSONDecoder().decode([Stock].self, from: data)
                    print(stocks)
                    completion(.success(stocks))
                    
                } catch let jsonError {
                    
                        completion(.error(jsonError)) }

                
                }.resume()
        }
    }

    
    
}
