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

class ViewController: UIViewController, MotionDnaLocationManagerDelegate {
    var first = true
    func locationManager(_ manager: MotionDnaLocationManagerDataSource!, didUpdate locations: [CLLocation]!) {
        DispatchQueue.main.async{
            if (self.first){
                // Animate camera to first position
                self.mapView?.animate(toLocation: locations[0].coordinate)
                self.first = false
            }
            // Set icon to received SDK location
            self.user_location.position=locations[0].coordinate
        }
    }
    
    func locationManager(_ manager: MotionDnaLocationManagerDataSource!, didFailWithError error: Error!) {
        // Check for SDK failure in initialization.
    }
    
    func locationManager(_ manager: MotionDnaLocationManagerDataSource!, didUpdate newHeading: CLHeading!) {
        DispatchQueue.main.async{
            // Update user_location rotation to heading received from SDK.
            self.user_location.rotation=newHeading.trueHeading
        }
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: MotionDnaLocationManagerDataSource!) -> Bool {
        return false
    }
    
    // SDK Instance
    let sdk = MotionDnaSDK()

    // User location marker instance
    let user_location = GMSMarker()

    // Google Maps map instance
    var mapView : GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate camera
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        // Instantiate map
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        // Load custom location icon
        user_location.icon=UIImage(named: "Red_Location_Dot")
        // Set location icon rotation anchor point
        user_location.groundAnchor=CGPoint(x: 0.5, y: 0.5)
        
        // Set icon flat on the maps plain.
        user_location.isFlat=true
        
        // Add location icon to map
        user_location.map=mapView
        
        // Start the motionDna SDK with the key you received from www.navisens.com
        sdk.runMotionDna("YOUR_NAVISENS_KEY")
        // Enable GPS in high accuracy (mainly needed for setLocationNavisens()), please read docs.
        sdk.setExternalPositioningState(HIGH_ACCURACY)
        // sdk.setLocationLatitude(-33.86, longitude: 151.20, andHeadingInDegrees: 10) // Set initial position and heading.

        // Start SDK in auto initialization mode, read docs for more information.
        sdk.setLocationNavisens() // Let us figure out the start location

        // Add current class as motionDnaDelegate to receive location outputs.
        sdk.motionDnaDelegate=self
        
        // Setting current view to Google Maps/
        view = mapView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

