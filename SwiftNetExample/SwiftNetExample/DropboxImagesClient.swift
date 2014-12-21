//
//  DropboxImagesClient.swift
//  SwiftNetExample
//
//  Created by Игорь Савельев on 21/12/14.
//  Copyright (c) 2014 Leonspok. All rights reserved.
//

import UIKit

class DropboxImagesClient: NSObject {
    class var sharedInstance: DropboxImagesClient {
        struct Static {
            static var instance: DropboxImagesClient?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DropboxImagesClient()
        }
        
        return Static.instance!
    }
    
    private var session: NSURLSession
    
    
    override init() {
        self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    func getPagesList(success: ((pages: NSArray) -> ())?, failure: ((error: NSError) -> ())?) {
        let url = "https://dl.dropboxusercontent.com/u/55523423/NetExample/ListImages.json"
        session.dataTaskWithRequest(NSURLRequest(URL: NSURL(string: url)!), completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let error = error {
                if let failure = failure {
                    failure(error: error)
                }
            } else if let data = data {
                var responseObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
                if let success = success {
                    success(pages: responseObj as NSArray)
                }
            }
        }).resume()
    }
    
    func getImageFor(folder: String, row: Int, column: Int, success: ((image: UIImage?) -> ())?) {
        let url = "https://dl.dropboxusercontent.com/u/55523423/NetExample/"+folder+"/\(column)_\(row).png"
        session.dataTaskWithRequest(NSURLRequest(URL: NSURL(string: url)!), completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if let error = error {
                println("Can not load image")
            } else if (data != nil) {
                var image: UIImage? = UIImage(data: data!)
                if (success != nil && image != nil) {
                    success!(image: image!)
                }
            }
        }).resume()
    }
}
