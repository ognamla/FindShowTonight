//
//  FindShowTonightTableViewController.swift
//  FindShowTonight
//
//  Created by Ognam.Chen on 2017/4/21.
//  Copyright © 2017年 Gates. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
import CoreData

class FindShowTonightTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var theWallDataMO : TheWallDataMO!
    
    var theWallDateArray : [[String:String]] = []
    
    var theWallShowArray = [String]()
    
    var today : String! = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrapeTheWall()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd"
        
        let date = Date()
        
        today = dateFormatter.string(from: date)
        
    }
    
    func scrapeTheWall() -> Void {
        Alamofire.request("https://thewall.tw/shows").responseString { response in
            // print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    func parseHTML(html: String) -> Void {
        
        var theWallDateDict = [String:String]()
        
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                theWallDataMO = TheWallDataMO(context: appDelegate.persistentContainer.viewContext)
                
                for date in doc.css("div[class^='date']") {
                    
                    var theWallDate = date.text!
                    
                    theWallDate = String(theWallDate.characters.dropLast(3))
                    
                    theWallDataMO.date = theWallDate
                    
                    appDelegate.saveContext()
                    
                    theWallDateDict["Date"] = theWallDate
                    
                    theWallDateArray.append(theWallDateDict)
                    
                    self.tableView.reloadData()

                    
                }
                
            }
            dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FindShowTonightTableViewCell
        
        print(theWallDateArray)
        
        //        if theWallDateArray[0] == today {
        //            cell.siteLabel.text = "The Wall"
        //            cell.showNameLabel.text = theWallDateArray[1]
        //        }
        
        return cell
    }
    
}
