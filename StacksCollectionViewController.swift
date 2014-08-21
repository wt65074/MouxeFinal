//
//  StacksCollectionViewController.swift
//  Mauxe
//
//  Created by Will on 7/11/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class StacksCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    var dataDictionary: NSDictionary
    
    var arrayOfKeys: NSArray //for order preservation
    
    var caching = false
    
    var toCache = 0
    
    var concept: NSString?
    
    var spinner: UIActivityIndicatorView?
    
    var imageCache: NSMutableArray? = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.registerClass(StackCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
        self.collectionView.registerClass(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool)  {
        
        super.viewDidAppear(animated)
        
        for i in 0..<5 {
            if dataDictionary.count == imageCache!.count {
                continue;
            }
            toCache++
            self.imageCache!.addObject(NSObject())
        }
        
        self.collectionView.reloadData()
        
        self.caching = true
        
        for index in (self.imageCache!.count - toCache)..<(self.imageCache!.count - toCache)+5 {
        
            if index >= self.dataDictionary.count {
                continue
            }
            
            var imageForStack: UIImage?
            
            var stack = self.dataDictionary.objectForKey(self.arrayOfKeys.objectAtIndex(index)) as? NSArray
            
            if stack == nil {
                continue;
            }
            
            var data: PttrnDataObject = stack!.objectAtIndex(0) as PttrnDataObject
            
            var imageLink = NSURL(string: data.imageLink)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
                var previousIndexValue = index
                
                imageForStack = UIImage(data: NSData(contentsOfURL: imageLink))
                
                dispatch_sync(dispatch_get_main_queue(), {
                    
                    self.toCache--
                    
                    self.imageCache!.replaceObjectAtIndex(previousIndexValue, withObject: imageForStack)
            
                    if self.toCache == 0 {
                        
                        self.caching = false
                    }
                    
                    self.collectionView.reloadData()                })
            })
            
            
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init(coder aDecoder: NSCoder!) {
        dataDictionary = NSDictionary()
        self.arrayOfKeys = NSArray()
         super.init(coder: aDecoder)
    }
    
    init(data: NSDictionary, andConcept: Int) {
        
        dataDictionary = data
        
        arrayOfKeys = data.allKeys
        
        for categoryObject in DataManager.manager.categoriesArray {
            if (categoryObject as PttrnCategoryObject).id! == andConcept {
                concept = (categoryObject as PttrnCategoryObject).name!

            }
        }
        
        var flowLayout = CustomFlowLayout()
        
        flowLayout.headerReferenceSize = CGSizeMake(320, 128/2);
    
        super.init(collectionViewLayout: flowLayout)
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
    
    }
    
    override func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        
        var stackCell: StackCollectionViewCell? = collectionView.cellForItemAtIndexPath(indexPath) as? StackCollectionViewCell
        
        if stackCell == nil {
            return;
        }
        
        self.view.userInteractionEnabled = false;
        
        var layoutAttributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        var rect = layoutAttributes.frame
        
        rect = CGRectMake(rect.origin.x, rect.origin.y - self.collectionView.contentOffset.y, rect.size.width, rect.size.height)
        
        var superController: ConceptContainerViewController = self.parentViewController as ConceptContainerViewController
        
        superController.presentDetailViewControllerWith(stackCell!.imageStack!, topImage: stackCell!.selfTopImage!, topImageStartingRect: rect, initialIndexPath: indexPath.row)
        
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView!, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if self.toCache == 0 {
            
            self.caching = false
        }
        
        if caching == true {
            println("CACHING CONFIRM COUNT= \(self.toCache)")
            return
        }
        
        if UnsafePointer<CGPoint>(targetContentOffset).memory.y >= (self.collectionView.contentSize.height - self.collectionView.frame.height - 560/2) {
            
            println("BEGIN CACHING NEW IMAGES")
            
            for i in 0..<10 {
                if dataDictionary.count == imageCache!.count {
                    continue;
                }
                toCache++
                self.imageCache!.addObject(NSObject())
            }
            
            self.collectionView.reloadData()
            
            
            self.caching = true
           
            for index in (self.imageCache!.count - toCache)..<(self.imageCache!.count - toCache)+10 {
                
                if index >= self.dataDictionary.count {
                    continue
                }
                
                var imageForStack: UIImage?
                
                var stack = self.dataDictionary.objectForKey(self.arrayOfKeys.objectAtIndex(index)) as? NSArray
                
                if stack == nil {
                    continue;
                }
                
                
                var data: PttrnDataObject = stack!.objectAtIndex(0) as PttrnDataObject
                
                var imageLink = NSURL(string: data.imageLink)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    
                    var previousIndex = index
                    
                    imageForStack = UIImage(data: NSData(contentsOfURL: imageLink))
                    
                    dispatch_sync(dispatch_get_main_queue(), {
                        
                        self.toCache--
                        
                        self.imageCache!.replaceObjectAtIndex(previousIndex, withObject:imageForStack)
                        
                        if self.toCache == 0 {
                            
                            self.caching = false
                        }
                        self.collectionView.reloadData()
                    })
                })
            }
            
        }
        
        
        
    }
    
    override func collectionView(collectionView: UICollectionView!, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> UICollectionReusableView! {
        
        var reusableView: UICollectionReusableView?
        
        if (kind == UICollectionElementKindSectionHeader) {
            
            var headerView: HeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as HeaderCollectionReusableView
            headerView.button.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
            headerView.configureWithName(self.concept!)
            reusableView = headerView;
        }
        
        if reusableView != nil {
            return reusableView
        }
        
        else {
            return nil
        }
    }
    
    func dismiss(){
        
        var superCont: ConceptContainerViewController = self.parentViewController as ConceptContainerViewController
        
        superCont.navigationController.popToRootViewControllerAnimated(true)
        
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        return CGSizeMake(320/2, 560/2)
        
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // #pragma mark UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        println("RELOADED")
        return 1
    }


    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return imageCache!.count
    }

    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        var imageForStack: UIImage?
        
        if (indexPath.row < imageCache!.count) {
            imageForStack = imageCache!.objectAtIndex(indexPath.row) as? UIImage
        }
    
        if imageForStack == nil {
            return collectionView.dequeueReusableCellWithReuseIdentifier("EmptyCell", forIndexPath: indexPath) as UICollectionViewCell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as StackCollectionViewCell
        
        cell.configureWithImageStack(dataDictionary.objectForKey(arrayOfKeys.objectAtIndex(indexPath.row)) as NSArray, topImage: imageForStack, andApp: arrayOfKeys.objectAtIndex(indexPath.row) as NSString)
    
        return cell
    }

    // pragma mark <UICollectionViewDelegate>

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView!, shouldHighlightItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView!, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, canPerformAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, performAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) {
    
    }
    */

}
