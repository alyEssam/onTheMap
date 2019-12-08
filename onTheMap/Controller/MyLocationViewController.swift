//
//  MyLocationViewController.swift
//  onTheMap
//
//  Created by Aly Essam on 9/11/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit
import MapKit

class MyLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var studentAddress = ""
    var initalLocation : CLLocation!
    let regionRadius: CLLocationDistance = 1000
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        mapView.delegate = self
    getLatAndLon(address: studentAddress)

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finshButtonPressed(_ sender: Any) {
        
         UdacityClient.addStudentLocation(firstName: newStudentInfo.firstName, lastName: newStudentInfo.lastName, latitude: newStudentInfo.latitude, longitude: newStudentInfo.longitude, mapString: newStudentInfo.mediaURL , mediaURL: newStudentInfo.mediaURL, completion: handleAddLocationResponse)
    }
    func handleAddLocationResponse (success: Bool, error: Error?) {
        if success {
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarViewController") as! TabBarController
            self.present(tabBarVC, animated: true, completion: nil)
        }
        else {
            raiseAlertView(withTitle: "Adding Faliure", withMessage: "Posting Failed!!")
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarViewController") as! TabBarController
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }
    
    public func getLatAndLon (address : String)  {
        
        self.initalLocation = CLLocation(latitude: newStudentInfo.latitude, longitude: newStudentInfo.longitude)
        self.centerMapOnLocation(location: self.initalLocation)
        let coordinate = CLLocationCoordinate2D(latitude: newStudentInfo.latitude, longitude: newStudentInfo.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        annotation.title = address
        self.mapView.addAnnotation(annotation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    

    
    // MARK: - MKMapViewDelegate
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    
}







 
