//
//  ListViewController.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 14/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController {

    var students: [student] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).students
    }
    let uc = udacityClient.sharedInstance()
    let pc = parseClient.sharedInstance()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func logoutTapped(sender: AnyObject) {
        uc.deleteSession(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func refreshTapped(sender: AnyObject) {
        pc.getStudents("?order=-updatedAt&limit=100", completion: {error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Network Error!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction.init(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                print("Students received.")
                self.tableView.reloadData()
            }
        })
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell")!
        cell.textLabel?.text = students[indexPath.row].firstName! + " " + students[indexPath.row].lastName!
//        cell.imageView?.image = UIImage(named: "pin")
        return cell
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        if let toOpen = students[indexPath.row].mediaUrl {
            app.openURL(NSURL(string: toOpen)!)
        }

    }
    
}
