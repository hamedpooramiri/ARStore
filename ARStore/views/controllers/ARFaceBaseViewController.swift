//
//  ARFaceBaseViewController.swift
//  ARStore
//
//  Created by Hamed Pouramiri on 4/13/20.
//  Copyright © 2020 Hamed Pouramiri. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARFaceBaseViewController: UIViewController,UIDropInteractionDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    
    //MARK: - propertys
    
    var ancherNode:SCNNode!
    var mask: Mask?
    
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        createFaceGeometry()
        UILabel().font = UIFont.preferredFont(forTextStyle: .headline)
        traitCollection.horizontalSizeClass
        let drog = UIDropInteraction(delegate: self)
        view.addInteraction(drog)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initARSession()
    }
    
    
    
    func initARSession()  {
        
        let config = ARFaceTrackingConfiguration()
        sceneView.session.run(config, options: [.removeExistingAnchors,.resetTracking])
        
    }


    func createFaceGeometry()  {
        let geo = ARSCNFaceGeometry(device: sceneView.device!)!
        mask = Mask(geometry: geo)
    }
    
    func setupFaceNodeContent() {
        guard let node = ancherNode else { return }
        node.childNodes.forEach { $0.removeFromParentNode() }
        if let content = mask { node.addChildNode(content) }
        
    }
    
    
}


extension ARFaceBaseViewController: ARSCNViewDelegate {
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        self.ancherNode = node
        setupFaceNodeContent()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        mask?.update(withFaceAnchor: faceAnchor)
        
    }
    
}
