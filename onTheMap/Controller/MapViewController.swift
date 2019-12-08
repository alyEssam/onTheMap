//
//  MapViewController.swift
//  onTheMap
//
//  Created by Aly Essam on 8/22/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        UdacityClient.getStudentsLocation(completion: handleResponse(students:error:))
        getStudentsAnnotations()
    }
   
    func handleResponse(students: [student], error: Error?) {
        if error != nil{
            raiseAlertView(withTitle: "Failure", withMessage: error! .localizedDescription)
        } else {
            StudentModel.students = students
            self.mapView.reloadInputViews()
        }
    }
    @IBAction func refreshPressed(_ sender: Any) {
        UdacityClient.getStudentsLocation(completion: handleResponse(students:error:))
        getStudentsAnnotations()
    }

    @IBAction func logOutPressed(_ sender: Any) {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }

    }

    func getStudentsAnnotations () {
        
        let students = StudentModel.students
        
        var annotations = [MKPointAnnotation]()
        
        for student in students {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(student.latitude ?? 0.0)
            let long = CLLocationDegrees(student.longitude ?? 0.0)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName ?? ""
            let last = student.lastName ?? ""
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
             guard let toOpen = view.annotation?.subtitle! else {return}
            guard  app.canOpenURL(URL(string: toOpen)!) == true else {
                raiseAlertView(withTitle: "Invalid URL", withMessage: "It is invalid URL")
                return
            }
            app.open(URL(string: toOpen)!)

        }
    }
   
}







