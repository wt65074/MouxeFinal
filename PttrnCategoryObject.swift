//
//  PttrnCategoryObject.swift
//  Mouxe
//
//  Created by Will on 8/1/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import Foundation

class PttrnCategoryObject: NSObject {
    
    var id: Int?
    var name: String?
    
    init(dataDictionary: NSDictionary)  {
        
        println(dataDictionary)
        
        id = (dataDictionary.objectForKey("id") as? String)?.toInt();
        name = dataDictionary.objectForKey("title") as? String;
        
        super.init()
    }
    
    func describe () -> () {
        println("id: \(id), name: \(name)")
    }
    
}
