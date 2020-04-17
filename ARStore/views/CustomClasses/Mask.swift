//
//  Mask.swift
//  ARStore
//
//  Created by Hamed Pouramiri on 4/13/20.
//  Copyright © 2020 Hamed Pouramiri. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Mask: SCNNode {
    
    enum MaskType: Int { case basic ,painted , zombie }
    
    
    init(geometry:ARSCNFaceGeometry,maskType: MaskType) {
        super.init()
        
        let material = geometry.firstMaterial!
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor(red: 0.0,green: 0.68, blue: 0.37, alpha: 1)
        
        
        self.geometry = geometry
        swapMaterials(maskType: maskType)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        guard let faceGeometry = geometry as? ARSCNFaceGeometry else {return}
        faceGeometry.update(from: anchor.geometry)
    }
    
    func swapMaterials(maskType: MaskType) {
        
        guard let material = geometry?.firstMaterial! else { return }
        material.lightingModel = .physicallyBased
        material.diffuse.contents = nil
        material.normal.contents = nil
        material.transparent.contents = nil
        
        switch maskType {
        case .basic:
            material.lightingModel = .physicallyBased
            material.diffuse.contents = UIColor(red: 0.0, green: 0.68, blue: 0.37, alpha: 1)
            
        case .painted:
            material.diffuse.contents = "Models.scnassets/Masks/Painted/Diffuse.png"
            material.normal.contents = "Models.scnassets/Masks/Painted/Normal_v1.png"
            material.transparent.contents = "Models.scnassets/Masks/Painted/Transparency.png"
            
        case .zombie:
            
            material.diffuse.contents = "Models.scnassets/Masks/Zombie/Diffuse.png"
            material.normal.contents = "Models.scnassets/Masks/Zombie/Normal_v1.png"
            
        }
        
    }
    
    
}
