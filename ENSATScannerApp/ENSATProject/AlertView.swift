//
//  AlertView.swift
//  ENSATProject
//
//  Created by Michaelin on 15/8/1.
//  Copyright (c) 2015年 Michaelin. All rights reserved.
//

import UIKit

class AlertView {
    // Alert View with title "Notice" and input message.
    class func showNotice(message message:String, inView view:AnyObject){
        showAlert(title: "Notice", message: message, buttonTitle: "Cancel", inView: view)
    }
    
    // Alert View with title "Error" and input message.
    class func showError(message message:String, inView view:AnyObject){
        showAlert(title: "Error", message: message, buttonTitle: "Cancel", inView: view)
    }
    
    // Alert View with customized title and message.
    class func showAlert(title title:String, message:String, inView view:AnyObject){
        showAlert(title: title, message: message, buttonTitle: "Cancel", inView: view)
    }
    
    // Alert View with customized title, message and button.
    class func showAlert(title title:String, message:String, buttonTitle:String, inView view:AnyObject){
        showAlert(title:title, message:message, buttonTitle:buttonTitle,  inView:view, handler: nil)
    }
    
    // Alert View with title "Notice" and input message.
    class func showNotice(message message:String, inView view:AnyObject, handler:  ((UIAlertAction!) -> Void)!){
        showAlert(title: "Notice", message: message, buttonTitle: "Cancel", inView: view, handler: handler)
    }
    
    // Alert View with title "Error" and input message.
    class func showError(message message:String, inView view:AnyObject, handler:  ((UIAlertAction!) -> Void)!){
        showAlert(title: "Error", message: message, buttonTitle: "Cancel", inView: view, handler: handler)
    }
    
    // Alert View with customized title and message.
    class func showAlert(title title:String, message:String, inView view:AnyObject, handler:  ((UIAlertAction!) -> Void)!){
        showAlert(title: title, message: message, buttonTitle: "Cancel", inView: view, handler: handler)
    }
    
    class func showAlert(title title:String, message:String, buttonTitle:String, inView view:AnyObject, handler:  ((UIAlertAction!) -> Void)!){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.Default, handler: handler))
        view.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}