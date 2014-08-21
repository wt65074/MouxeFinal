//
//  DataManager.swift
//  Mauxe
//
//  Created by Will on 7/10/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    var categoriesArray: [PttrnCategoryObject] = [PttrnCategoryObject]()
    
    var currentImageCache: [UIImage]? = nil

    class var manager: DataManager {
        
        struct Singleton {
            static let instance = DataManager()
            }
            return Singleton.instance
    }
    
    func fetchDataWithCompletionHandler(completionHandler:(categories: NSArray, error: NSError?) -> Void) {
        
        println("Fetch Called")
        
        //make the api call for the categories json
        var allData = NSData(contentsOfURL: NSURL(string: "http://mouxe.co/categories"))
        var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
        println(error)
        if allData == nil {
            completionHandler(categories: NSArray(), error: NSError())
            return
        }
        let dictionary: NSArray! = NSJSONSerialization.JSONObjectWithData(allData,
            options:NSJSONReadingOptions.MutableContainers,
            error: error) as? NSArray
        
        println(error)
        
        println(dictionary)
        //get the results as an array of dictionaries
        var arrayOfDicts: NSArray = dictionary
        
        var arrayOfCategories = NSMutableArray();
        
        //enumerate the dictionaries
        for dict: AnyObject in arrayOfDicts {
            arrayOfCategories.addObject(PttrnCategoryObject(dataDictionary: dict as NSDictionary))
            categoriesArray.append(PttrnCategoryObject(dataDictionary: dict as NSDictionary))
            println("New Dictionary added")
        }
        
        completionHandler(categories: arrayOfCategories, error: nil)
    }
   
}
