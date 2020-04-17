//
//  ViewController.swift
//  ARStore
//
//  Created by Hamed Pouramiri on 4/8/20.
//  Copyright © 2020 Hamed Pouramiri. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController  {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel:MainViewModel = MainViewModel()
    var selectedIndexpath:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        collectionView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.getProducts()
        collectionView.reloadData()
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        addTapGestureRecognizer()
        addPinchGestureRecgnizer()
        addLongPressGestureRecognizer()
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.debugOptions = [.showFeaturePoints]
        
        
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initARSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    
    
    
    func initARSession(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    
    
    
    //MARK: - actions
    
    
    func addTapGestureRecognizer()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(taped(sender:)))
        sceneView.addGestureRecognizer(tap)
    }
    
    func addPinchGestureRecgnizer()  {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinched(sender:)))
        sceneView.addGestureRecognizer(pinch)
    }
    
    func addLongPressGestureRecognizer()  {
        let longPress  = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        longPress.minimumPressDuration = 0.1
        sceneView.addGestureRecognizer(longPress)
    }
    
    
    
    @objc func taped(sender:UITapGestureRecognizer) {
        let targetView = sender.view as! ARSCNView
        let location = sender.location(in: targetView)
        
        let result = targetView.hitTest(location, types: .existingPlaneUsingExtent)
        
        if(!result.isEmpty){
          guard  let selectedIndexpath = selectedIndexpath else {return}
             let nodeTitle = viewModel.products[selectedIndexpath.row].tittle
            guard let node = loadNode(from: "custom.scnassets/\(nodeTitle).scn", nodeName: nodeTitle )
                else {
                    debugPrint("cant load node")
                    return}
            
            let column3 = result[0].worldTransform.columns.3
            print(column3.x ,column3.y,column3.z)
            node.position = SCNVector3(column3.x, column3.y, column3.z)
            sceneView.scene.rootNode.addChildNode(node)
            
            
        }
    }
    
    
    @objc func pinched(sender:UIPinchGestureRecognizer)  {
        
        let targerView = sender.view as!  ARSCNView
        let location = sender.location(in: targerView)
        let scaleAction = SCNAction.scale(by: sender.scale, duration: 2)
        
        let result = targerView.hitTest(location)

        if(!result.isEmpty){ // we have pointing to the some node
           guard let node = result.first?.node else {return}
            node.runAction(scaleAction)
            
        }
 
        sender.scale = 1.0
        
    }
    
    
   @objc func longPressed(sender:UILongPressGestureRecognizer) {
    
    let targetView = sender.view as! ARSCNView
    let location = sender.location(in: targetView)
    let result = targetView.hitTest(location)
    if(!result.isEmpty) {
        
        let RotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(90 * Double.pi / 180), z: 0, duration: 2)
        let forEverAction = SCNAction.repeatForever(RotateAction)
        
        switch sender.state {
        case .began:
            result.first?.node.runAction(forEverAction)
        case .ended,.failed,.cancelled:
            result.first?.node.removeAllActions()
            
        default:
            break
        }
        
        
    }
    
    
    
    }
    
    
    //MARK: - helper functions
    
    
    func loadNode(from scnName:String,nodeName:String) -> SCNNode? {
        guard let scn = SCNScene(named: scnName) else {return nil}
        return scn.rootNode.childNode(withName: nodeName, recursively: false) ?? nil
        
    }
    
    
}


extension ViewController:UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell
        cell.layer.cornerRadius = 5
        cell.setProduct(product: viewModel.products[indexPath.row])
        
        checkForSelectedCell(indexPath, cell)
        
        return cell
        
    }
    
    
    fileprivate func checkForSelectedCell(_ indexPath: IndexPath, _ cell: ProductCell) {
        if((selectedIndexpath) != nil){
            if selectedIndexpath == indexPath {
                cell.tittle_lbl.textColor = UIColor.yellow
            }else{
                cell.tittle_lbl.textColor = UIColor.groupTableViewBackground
            }
        }
    }
    
    
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductCell
        cell.tittle_lbl.textColor = UIColor.yellow
        selectedIndexpath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard  let cell = collectionView.cellForItem(at: indexPath) as? ProductCell else {return}
        cell.tittle_lbl.textColor = UIColor.groupTableViewBackground
    }
    
    
}




//MARK: - ARSCNViewDelegate


extension ViewController : ARSCNViewDelegate {
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
    }
    
}


//MARK: - session

extension ViewController {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    
    
}
