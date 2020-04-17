//
//  ProductCell.swift
//  ARStore
//
//  Created by Hamed Pouramiri on 4/8/20.
//  Copyright © 2020 Hamed Pouramiri. All rights reserved.
//

import Foundation
import UIKit

class ProductCell: UICollectionViewCell {
    
    private var product:Product!
    
    @IBOutlet weak var tittle_lbl: UILabel!
    
    func setProduct(product:Product)  {
        self.product = product
        self.tittle_lbl.text = product.tittle
        
        
    }
    
}
