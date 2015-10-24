//
//  LoginViewController.swift
//  ENSATProject
//
//  Created by Michaelin on 15/8/1.
//  Copyright (c) 2015年 Michaelin. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    var data:NSMutableData? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func forgotPasswordOperation(sender: AnyObject) {
        if(!usernameTextField.text!.isEmpty){
            //test connectt swift and jsp
            let urlPath: String = "http://localhost:8080/ENSAT/jsp/ios_test_set.jsp"
            HttpRequest.getHttpRequest(urlPath: urlPath, delegate: self)
        }else{
            AlertView.showAlert(title: "Alert", message: "Please input username", inView: self)
        }
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        //The connection fail, so print out the error content in order to debug.
        print("Failed with error:\(error.localizedDescription)")
        AlertView.showError(message: error.localizedDescription, inView: self)
    }
    
    //NSURLConnection delegate method
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        //New request so we need to clear the data object
        self.data = NSMutableData()
    }
    
    //NSURLConnection delegate method
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        //Append incoming data
        self.data!.appendData(data)
    }
    
    //NSURLConnection delegate method
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        //Receive all data, and start to process data.
        let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments)
        print(json)
        
        
    }
}

