//
//  Candy.swift
//  CandySearch
//
//  Created by Amit Chaudhary on 7/24/21.
//

import Foundation
import UIKit

struct Candy: Decodable {
    let name: String
    let category: Category
}

enum Category: String, Decodable, CaseIterable {
    case all = "All"
    case chocolate = "Chocolate"
    case hard = "Hard"
    case other = "Other"
}

typealias candyArray = [Candy]

extension Candy {
    static func getTotalCandies() -> [Candy] {
       guard let url = Bundle.main.url(forResource: "candies", withExtension: "json")
       else { return [] }
        
             do {
                let data = try Data(contentsOf: url)
                let jsonDecoder = JSONDecoder()
               let candies = try jsonDecoder.decode(candyArray.self, from: data)
               
                return candies
             } catch  {
                print(error)
                return []
             }
        
    }
}


extension UIColor {
  static let candyGreen = UIColor(red: 67.0/255.0, green: 205.0/255.0, blue: 135.0/255.0, alpha: 1.0)
}








