//
//  MainViewModel.swift
//  ARStore
//
//  Created by Hamed Pouramiri on 4/8/20.
//  Copyright © 2020 Hamed Pouramiri. All rights reserved.
//

import Foundation

class MainViewModel {
    
    var products:[Product] = []
    
    
    
    
    
    
    
    
    //MARK: - network calls
    
    func getProducts()  {
        products.append(contentsOf: [
        Product(tittle: "Chocolate"),
        Product(tittle: "milk")
        ])
    }
    
    
}
