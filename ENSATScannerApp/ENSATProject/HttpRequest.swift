//
//  HttpRequest.swift
//  ENSATProject
//
//  Created by Michaelin on 15/8/1.
//  Copyright (c) 2015年 Michaelin. All rights reserved.
//

import Foundation

class HttpRequest{
    
    class func postHttpRequest(urlPath urlPath:String, dataString:String, delegate:AnyObject){
        /* POST Http Request, in order to protect some sensitive attributes.
        Meanwhile, the POST request can contain more data than GET request*/
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = requestBodyData
        
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: delegate, startImmediately: true)!
        connection.start()
    }
    
    class func getHttpRequest(urlPath urlPath:String, delegate:AnyObject){
        /* GET Http Request, unsafe request */
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(URL: url)
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: delegate, startImmediately: true)!
        connection.start()
    }
}