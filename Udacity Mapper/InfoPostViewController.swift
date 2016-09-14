//
//  InfoPostViewController.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 14/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit

class InfoPostViewController: UIViewController {

    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findButton.layer.cornerRadius = 5
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
    
    }
}
