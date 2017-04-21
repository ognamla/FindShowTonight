//
//  ViewController.swift
//  webParse
//
//  Created by Gates on 2017/4/17.
//  Copyright © 2017年 Gates. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
import CoreData

//extension Dictionary {
//    mutating func update(other:Dictionary) {
//        for (key,value) in other {
//            self.updateValue(value, forKey:key)
//        }
//    }
//}

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var theWallDataMO : TheWallDataMO!
    var theWallDateArray = [String]()
    var theWallShowArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrapeNYCMetalScene()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Grabs the HTML from nycmetalscene.com for parsing.
    func scrapeNYCMetalScene() -> Void {
        Alamofire.request("https://thewall.tw/shows").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    func parseHTML(html: String) -> Void {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
           
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                theWallDataMO = TheWallDataMO(context: appDelegate.persistentContainer.viewContext)
                
                for date in doc.css("div[class^='date']") {
                    
                    var theWallDate = date.text!
                    
                    theWallDataMO.date = String(theWallDate.characters.dropLast(3))

                    appDelegate.saveContext()
                    
                    theWallDateArray.append(theWallDataMO.date!)

                }
                
                
                print("save data to context...")
                print(theWallDateArray)
                
                for showName in doc.css("div[class^='title']") {
                    
                    theWallDataMO.showName = showName.text!
                    
                    appDelegate.saveContext()
                    
                    theWallShowArray.append(theWallDataMO.showName!)
                    
                }
                
                print("save data to context...")
                print(theWallShowArray)

                
            }
            
            dismiss(animated: true, completion: nil)
        }
        
        
    }
}
