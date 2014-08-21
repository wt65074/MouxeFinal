//
//  PttrnAppObject.swift
//  Mouxe
//
//  Created by Will on 8/11/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class PttrnAppObject: NSObject {
   
    var id: Int?
    var name: String?
    var link: String?
    
    init(dataDictionary: NSDictionary)  {
        
        id = dataDictionary.objectForKey("id") as? Int
        name = dataDictionary.objectForKey("name") as? String
        link = dataDictionary.objectForKey("link") as? String
        
        super.init()
    }
    
}
