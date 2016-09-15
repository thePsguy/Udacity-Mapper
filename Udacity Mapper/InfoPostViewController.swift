//
//  InfoPostViewController.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 14/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit
import MapKit

class InfoPostViewController: UIViewController {

    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topLabelStack: UIStackView!
    @IBOutlet weak var userURL: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let uc = udacityClient.sharedInstance()
    let pc = parseClient.sharedInstance()
    
    var mapString: String!
    var locationData: CLLocationCoordinate2D!
    var formattedAddress: String = ""
    
    var userObject: user {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).userObject
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findButton.layer.cornerRadius = 6
        submitButton.layer.cornerRadius = 6
        userURL.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findTapped(sender: AnyObject) {
        toggleActivityIndicator()
        self.activityIndicator.startAnimating()
        let locationString = locationField.text!
        CLGeocoder.init().geocodeAddressString(locationString, completionHandler:{(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if(error == nil){
                let place = MKPointAnnotation()
                let address = placemarks![0].addressDictionary!["FormattedAddressLines"] as! NSArray
                
                for line in address {
                    if line as! String != address[0] as! String {
                        self.formattedAddress += ", "
                    }
                    self.formattedAddress += line as! String
                }
                
                place.coordinate = placemarks![0].location!.coordinate
                
                self.locationData = place.coordinate
            
                self.topLabelStack.hidden = true
                self.locationField.hidden = true
                self.findButton.hidden = true
                
                self.userURL.hidden = false
                self.submitButton.hidden = false
                
                let region = MKCoordinateRegion(center: place.coordinate, span: MKCoordinateSpan(latitudeDelta: 6.0, longitudeDelta: 6.0))
                self.toggleActivityIndicator()
                self.mapView.addAnnotation(place)
                self.mapView.setRegion(region, animated: true)
            }else{
                self.toggleActivityIndicator()
                let alert = UIAlertController(title: "ERROR!", message: "Geocoding Error.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction.init(title: "Dismiss", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction) in
                }))
                self.presentViewController(alert, animated: true, completion: nil)

            }
        })
    }
    
    @IBAction func submitTapped(sender: AnyObject) {
        
        toggleActivityIndicator()
        if userURL.text?.characters.count > 10 && userURL.text! != "http://yourLink.here"{
            pc.postPin(userObject, lat: String(locationData.latitude), long: String(locationData.longitude), mapString: formattedAddress, mediaUrl: userURL.text!, completion: {error in
                if(error != nil){
                    print(error)
                }else{
                    print("Post Complete!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }else{
            self.toggleActivityIndicator()
            let alert = UIAlertController(title: "Incorrect URL", message: "Please Enter Correct URL", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction.init(title: "Dismiss", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction) in
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func toggleActivityIndicator(){
        self.overlayView.hidden = !self.overlayView.hidden
        self.activityIndicator.isAnimating() ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
    }
}

extension InfoPostViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text="http://"
    }
    
    
    @IBAction func locationFieldTriggered(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
}
