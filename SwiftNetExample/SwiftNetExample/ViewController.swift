//
//  ViewController.swift
//  SwiftNetExample
//
//  Created by Игорь Савельев on 21/12/14.
//  Copyright (c) 2014 Leonspok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var imageInfo: NSDictionary?
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadImages()
    }
    
    func loadImages() {
        if let imageInfo = imageInfo {
            
            var fieldSize = CGSizeZero
            fieldSize.width = CGFloat((imageInfo["rows_count"] as NSNumber).floatValue)
            fieldSize.height = CGFloat((imageInfo["columns_count"] as NSNumber).floatValue)
            
            var elemSize = CGSizeZero
            elemSize.width = CGFloat((imageInfo["elem_width"] as NSNumber).floatValue)
            elemSize.height = CGFloat((imageInfo["elem_height"] as NSNumber).floatValue)
            
            var size: CGSize = CGSizeMake(fieldSize.width * elemSize.width, fieldSize.height * elemSize.height)
            self.scrollView.contentSize = size
            
            for (var i = 0; i < Int(fieldSize.width); i++) {
                for (var j = 0; j < Int(fieldSize.height); j++) {
                    var imageView = UIImageView(frame: CGRectMake(CGFloat(i)*elemSize.width, CGFloat(j)*elemSize.height, elemSize.width, elemSize.height))
                    imageView.backgroundColor = UIColor.lightGrayColor()
                    
                    DropboxImagesClient.sharedInstance.getImageFor(imageInfo["folder_name"] as String, row: i, column: j, success: { (image: UIImage?) -> () in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if image != nil {
                                imageView.image = image
                            }
                        })
                    })
                    
                    self.scrollView.addSubview(imageView)
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

