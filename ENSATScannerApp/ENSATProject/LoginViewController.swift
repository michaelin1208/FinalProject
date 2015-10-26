//
//  LoginViewController.swift
//  ENSATProject
//
//  Created by Michaelin on 15/8/1.
//  Copyright (c) 2015年 Michaelin. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var data:NSMutableData? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let password = "666666"
//        println("sha1:"+password.sha1())
//        println("sha2:"+password.sha2())
//        let sha1password = "[B@2b2b900f666666"
//        println("sha1+2:"+sha1password.sha2())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // loginOperation method, it is used to login
    @IBAction func loginOperation(sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        checkValidationThrough(username: username!, password: password!)
    }
    // forgetPasswordButtonTouched function, when user forget his password.
    @IBAction func forgetPasswordButtonTouched(sender: AnyObject) {
        AlertView.showNotice(message: "If you forget your password, Please contact to Administrator", inView: self)
    }
    
    // check the validation of username and password who should not be empty or nil
    func checkValidationThrough(username username:String, password:String){
        if (!username.isEmpty && !password.isEmpty){
            let urlPath: String = "http://"+ADDRESS+":8080/ENSAT/jsp/ios_login.jsp"
            let dataString = "username="+username+"&password="+password
            HttpRequest.postHttpRequest(urlPath: urlPath, dataString: dataString, delegate: self)
            
        }else{
            AlertView.showNotice(message: "Please input username and password", inView:self)
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
        
        if(json.valueForKey("type") as! String=="ios_login"){
            //ios_login check: if result is 
            //0 = user present, account active, membership up-to-date (OK login)
            //1 = user not present (i.e. credentials are wrong)
            //2 = user present, account not active
            //3 = user present, account active, membership out-of-date
            //-1 = username or password is empty
            if(json.valueForKey("result") as! String == "0"){
                //If the account is OK, the centerID should retrun, and the ID will be used in update freezer data.
                let temp = json.valueForKey("centerID") as? String
                if(temp == "" || temp == nil){
                    // If the centerID is not returned, the server maybe have some error so show an alert, and do not jump to next page.
                    AlertView.showAlert(title: "Incorrect", message: "Cannot get center ID, Please contact to Administrator", inView:self)
                }else{
                    CENTER_ID = temp!
                    performSegueWithIdentifier("loginSegue", sender: nil)
                }
            }else if(json.valueForKey("result") as! String == "1"){
                AlertView.showAlert(title: "Incorrect", message: "Please check username and the password", inView:self)
            }else if(json.valueForKey("result") as! String == "2"){
                AlertView.showAlert(title: "Inactive", message: "Please active your account before using.", inView:self)
            }else if(json.valueForKey("result") as! String == "3"){
                AlertView.showAlert(title: "Permission Denied", message: "You are not allowed to login.", inView:self)
            }else if(json.valueForKey("result") as! String == "-1"){
                AlertView.showNotice(message: "Please input username and password", inView:self)
            }else{
                AlertView.showNotice(message: "Unknown response. Please contact to Administrator", inView:self)
            }
        }
    }
}
//add sha1 and sha2 encryption functions into String class
extension String {
    func sha1() -> String{
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joinWithSeparator("")
    }
    func sha2() -> String{
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA256(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joinWithSeparator("")
    }
}