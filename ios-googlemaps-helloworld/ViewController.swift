//
//  ViewController.swift
//  ios-googlemaps-helloworld
//
//  Created by Lucas Mckenna on 9/21/18.
//  Copyright © 2018 Lucas Mckenna. All rights reserved.
//

import UIKit
import GoogleMaps
import MotionDnaSDK

class ViewController: UIViewController, MotionDnaSDKDelegate {
    var first = true

    // SDK Instance
    var motionDnaSDK : MotionDnaSDK!

    // User location marker instance
    let userLocationMarker = GMSMarker()

    // Google Maps map instance
    var mapView : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionDnaSDK = MotionDnaSDK(delegate: self)
        // Instantiate camera
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        // Instantiate map
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Load custom location icon
        userLocationMarker.icon=UIImage(named: "Red_Location_Dot")
        // Set location icon rotation anchor point
        userLocationMarker.groundAnchor=CGPoint(x: 0.5, y: 0.5)
        
        // Set icon flat on the maps plain.
        userLocationMarker.isFlat=true
        
        // Add location icon to map
        userLocationMarker.map=mapView
        
        // Start the motionDna SDK with the key you received from www.navisens.com
        motionDnaSDK.start(withDeveloperKey: "YOUR_NAVISENS_KEY")
        
        // Setting current view to Google Maps/
        view = mapView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receive(motionDna: MotionDna) {
        guard let global = motionDna.location.global , global.latitude != 0.0, global.longitude != 0.0 else {
            return
        }

        DispatchQueue.main.async{
            var location = CLLocationCoordinate2D()
            location.latitude = global.latitude
            location.longitude = global.longitude
        
            if (self.first){
                // Animate camera to first position
                let cameraPosition = GMSCameraPosition(target: location, zoom: 18.0)
                let cameraUpdate = GMSCameraUpdate.setCamera(cameraPosition)
                self.mapView.animate(with: cameraUpdate)
                self.first = false
            }
            // Set icon to received SDK location
            self.userLocationMarker.position = location
            self.userLocationMarker.rotation = motionDna.location.global.heading

        }
    }
    
    func report(status: MotionDnaSDK.Status, message: String) {
        print(message)
    }


}

