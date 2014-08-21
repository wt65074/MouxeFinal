//
//  PttrnDataObject.swift
//  Mauxe
//
//  Created by Will on 7/10/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class PttrnDataObject: NSObject {
   
    var imageLink: NSString?
    var app_id: Int?
    var category_id: Int?
    var app_name: String?
    
    init(jsonDictionary: NSDictionary) {
        
        imageLink = jsonDictionary.objectForKey("link") as? String
        category_id = (jsonDictionary.objectForKey("category_id") as? String)?.toInt()
        app_id = (jsonDictionary.objectForKey("app_id") as? String)?.toInt()
        app_name = jsonDictionary.objectForKey("app_name") as? String
    }

    func printObject() {
        print("\(imageLink!)")
        print(", ")
        print("\(category_id!)")
        print(", ")
        print("\(app_id!)")
        print(", ")
        print("\(app_name!)")
        print(", ")
    }
    
}
