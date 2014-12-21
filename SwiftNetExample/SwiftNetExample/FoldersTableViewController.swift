//
//  FoldersTableViewController.swift
//  SwiftNetExample
//
//  Created by Игорь Савельев on 21/12/14.
//  Copyright (c) 2014 Leonspok. All rights reserved.
//

import UIKit

class FoldersTableViewController: UITableViewController {
    
    private var items = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        DropboxImagesClient.sharedInstance.getPagesList({ (pages: NSArray!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.items.removeAllObjects()
                self.items.addObjectsFromArray(pages)
                var indexPaths = NSMutableArray()
                for (var i = 0; i < self.items.count; i++) {
                    indexPaths.addObject(NSIndexPath(forRow: i, inSection: 0))
                }
                self.tableView.reloadData()
            })
        }, { (error: NSError!) -> Void in
            println("Can not get pages")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = ((items.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("folder_name")) as? String
        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc: ViewController = segue.destinationViewController as ViewController
        var indexPath: NSIndexPath? = self.tableView.indexPathForSelectedRow()?
        
        if let indexPath = indexPath {
            vc.imageInfo = self.items.objectAtIndex(indexPath.row) as? NSDictionary
        }
    }

}
