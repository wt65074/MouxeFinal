//
//  MainNavViewController.swift
//  Mouxe
//
//  Created by Will on 7/11/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class MainNavViewController: UINavigationController {
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nil , bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(categories: NSArray) {
        
        super.init(rootViewController: CategoriesViewViewController(categories: categories))
        
        
        self.navigationBar.hidden = true;
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
