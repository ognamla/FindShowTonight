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
    
    var theWallDateArray = [String]() ; var legacyDateArray = [String]()
    var theWallTodayArray = [String]() ; var legacyTodayArray = [String]()
    var theWallTitleArray = [String]() ; var legcyTitleArray = [String]()
    var theWallInfoArray = [String]() ;
    var theWallPriceArray = [String]() ; var legcyPriceArray = [String]()
    var theWallShowTimeArray = [String]() ; var legcyShowTimeArray = [String]()
    
    var theWallPerformerArray = [String]() ; var legcyPerformArray = [String]()
    
    var totalTitleArray = [String]() ; var totalSiteArray = [String]()
    
    var today : String! = ""
    var today2 : String! = ""
    var today3 : String! = ""
    
    var theWallNumber : Int = 0 ; var legcyNumber : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        today = dateFormatter.string(from: date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "YYYY/MM/dd"
        today2 = dateFormatter2.string(from: date)
        
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "YYYY-MM-dd"
        today3 = dateFormatter3.string(from: date)
        
        scrapeTheWall() ; scrapeLegcy() ;
        
        
    }
    
    
    func scrapeTheWall() -> Void {
        Alamofire.request("https://thewall.tw/shows").responseString { response in
            // print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseTheWallHTML(html: html)
            }
        }
    }
    
    func scrapeLegcy() -> Void {
        Alamofire.request("http://www.legacy.com.tw/page/topic/taipei/").responseString { response in
            // print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseLegacyHTML(html: html)
            }
        }
    }
    // theWall
    func parseTheWallHTML(html: String) -> Void {
        
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                theWallDataMO = TheWallDataMO(context: appDelegate.persistentContainer.viewContext)
                
                for date in doc.css("div[class^='date']") {
                    
                    var theWallDate = date.text!
                    theWallDate = String(theWallDate.characters.dropLast(3))
                    theWallDataMO.date = theWallDate
                    appDelegate.saveContext()
                    
                    theWallDateArray.append(theWallDate)
                }
                
                for title in doc.css("div[class^='title']") {
                    
                    let theWallTitle = title.text!
                    theWallDataMO.title = theWallTitle
                    appDelegate.saveContext()
                    
                    theWallTitleArray.append(theWallTitle)
                }
                
                
                for info in doc.css("tr td") {
                    
                    let theWallInfo = info.text!
                    
                    theWallInfoArray.append(theWallInfo)
                    
                }
                
                theWallPerformerArray = stride(from: 1, to: theWallInfoArray.count, by: 5).map {theWallInfoArray[$0]}
                theWallPriceArray = stride(from: 2, to: theWallInfoArray.count, by: 5).map {theWallInfoArray[$0]}
                theWallShowTimeArray = stride(from: 4, to: theWallInfoArray.count, by: 5).map {theWallInfoArray[$0]}
                
                
            }
            dismiss(animated: true, completion: nil)
            
            
        }
        
        
        self.tableView.reloadData()
        tonightList()

        
    }
    // Legcy
    func parseLegacyHTML(html: String) -> Void {
        
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for date in doc.css("td[class='program_list_date']") {
                
                var legcyDate = date.text!
                legcyDate = String(legcyDate.characters.dropLast(3))
                
                legacyDateArray.append(legcyDate)
            }
            
            for title in doc.css("td[class='program_list_text']") {
                
                let legcyTitle = title.text!
                legcyTitleArray.append(legcyTitle)
            }
            
        }
        self.tableView.reloadData()

        
    }
    
    func tonightList() {
        if theWallDateArray.contains(today!) || theWallDateArray.contains(today2!) {
            
            if (theWallDateArray[0] == today! || theWallDateArray[0] == today2!) {
                theWallNumber = 1
                totalTitleArray.append(theWallTitleArray[0])
                totalSiteArray.append("The Wall")
                
                if legacyDateArray.contains(today3!) {
                    
                    if legacyDateArray[0] == today3! {
                        legcyNumber = 1
                        totalTitleArray.append(legcyTitleArray[0])
                        totalSiteArray.append("Legacy Taipei")
                        
                    } else {
                        legcyNumber = 0
                    }
                }

                if theWallDateArray[1] == today! {
                    theWallNumber = 2
                    totalTitleArray.append(theWallTitleArray[1])
                    totalSiteArray.append("The Wall")
                }
            }
            
            if (theWallDateArray[0] != today! || theWallDateArray[0] != today2!) && theWallDateArray[1] == today! {
                theWallNumber = 1
                totalTitleArray.append(theWallTitleArray[1])
                totalSiteArray.append("The Wall")
                
                if legacyDateArray[0] == today3! {
                    legcyNumber = 1
                    totalTitleArray.append(legcyTitleArray[0])
                    totalSiteArray.append("Legacy Taipei")
                    
                } else {
                    legcyNumber = 0
                }

                
            }
        } else {
            theWallNumber = 0
        }
        
                self.tableView.reloadData()
        
        print("legacyNumber is \(legcyNumber)")
        print("theWallNumber is \(theWallNumber)")
        // print("theWallTitleArray is \(theWallTitleArray)")
        // print("legcyTitleArray is \(legcyTitleArray)")
        print("totalTitleArray is \(totalTitleArray)")
        print("site today is \(totalSiteArray)")
        
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return theWallNumber + legcyNumber
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FindShowTonightTableViewCell
        
//        let theWallPerformer = theWallPerformerArray[indexPath.row]
//        let theWallTitle = theWallTitleArray[indexPath.row]
//        let theWallPrice = theWallPriceArray[indexPath.row]
//        let theWallShowTime = theWallShowTimeArray[indexPath.row]
//        
//        cell.siteLabel.text = "The Wall"
//        cell.titleLabel.text = theWallTitle
//        cell.performerLabel.text = theWallPerformer
//        cell.priceLabel.text = theWallPrice
//        cell.showTimeLabel.text = theWallShowTime
        let totalTitle = totalTitleArray[indexPath.row]
        let totalSite = totalSiteArray[indexPath.row]
        cell.siteLabel.text = totalSite
        cell.titleLabel.text = totalTitle
        
        
        return cell
    }
    
}
