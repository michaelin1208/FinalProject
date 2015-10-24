//
//  DetailofBoxViewController.swift
//  ENSATProject
//
//  Created by Michaelin on 15/8/28.
//  Copyright (c) 2015年 Michaelin. All rights reserved.
//

import UIKit
class DetailofBoxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    let DEFAULT_NOTICE = "No Warning"
    let POSITION_NOTICE = "Position is Occupied"
    let RECEIVED_NOTICE = "Not Received"
    var fileID:String = "1445602269076" // default value of used to text,
    var data:NSMutableData? = nil
    var details:NSArray = NSArray()
    var usedPositions:NSArray = NSArray()
    var freezerStructures:NSArray = NSArray()
    var temporaryUsed:NSMutableDictionary = NSMutableDictionary()
    var allFreezersCapacity = 0
    let cellIdentifier = "DetailTableViewCell"
    let rowHeight = 181
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Customise UITableViewCell to DetailTableViewCell
        detailsTableView!.registerNib(UINib(nibName: cellIdentifier, bundle:nil), forCellReuseIdentifier: cellIdentifier)
        self.navigationTitle.title = fileID
        achieveDetails()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func doneButtonTouched(sender: AnyObject) {
        print("done button touched, something should save!")
        if let submitBiomaterials = getSubmitBiomaterials(self.details ){
            let urlPath: String = "http://"+ADDRESS+":8080/ENSAT/jsp/ios_update_biomaterial.jsp"
            let jsonData = try? NSJSONSerialization.dataWithJSONObject(submitBiomaterials, options: NSJSONWritingOptions())
            let str = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)!
            let dataString = "data=\(str)"
            HttpRequest.postHttpRequest(urlPath: urlPath, dataString: dataString, delegate: self)
        }else{
            AlertView.showNotice(message: "Please select a valid postion for each bio-material", inView: self)
        }

    }
    
    
    //set the height of tableview according to whether the keyboard view is show
    func keyboardWillShow(note:NSNotification){
        let userInfo:NSDictionary = note.userInfo!
        let aValue:NSValue = userInfo.objectForKey("UIKeyboardFrameEndUserInfoKey") as! NSValue
        var keyboardRect:CGRect = aValue.CGRectValue()
        keyboardRect = self.view.convertRect(keyboardRect, fromView: nil)
        let keyboardTop:CGFloat = keyboardRect.origin.y
        var newTextViewFrame:CGRect = self.detailsTableView.frame
        newTextViewFrame.size.height = keyboardTop - self.detailsTableView.frame.origin.y
        let animationDurationValue:NSValue = userInfo.objectForKey("UIKeyboardAnimationDurationUserInfoKey") as! NSValue
        var  animationDuration:NSTimeInterval? = 0.5
        animationDurationValue.getValue(&animationDuration)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration!)
        self.detailsTableView.frame = newTextViewFrame
        UIView.commitAnimations()
    }
    
    func keyboardWillHide(note:NSNotification){
        let userInfo:NSDictionary = note.userInfo!
        var newTextViewFrame:CGRect = self.detailsTableView.frame
        newTextViewFrame.size.height = self.view.bounds.height - self.detailsTableView.frame.origin.y
        let animationDurationValue:NSValue = userInfo.objectForKey("UIKeyboardAnimationDurationUserInfoKey") as! NSValue
        var  animationDuration:NSTimeInterval? = 0.5
        animationDurationValue.getValue(&animationDuration)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration!)
        self.detailsTableView.frame = newTextViewFrame;
        UIView.commitAnimations()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }


    // Check whether all biomaterial has a valid position, and
    func getSubmitBiomaterials(array:NSArray)->NSMutableArray?{
        let submitBiomaterials = NSMutableArray()
        if details.count > 0 {
            for i in 0...details.count-1 {
                let detail = details[i] as! NSMutableDictionary
                /* If the detail do not include the next usable position, get one by getNextUsablePosition() */
                if (detail["temparyPosition"] == nil || detail["temparyPosition"] as! String == "-1"){
                    return nil
                }else{
    //                if(detail["received"] as! String == "true"){
//                    print("detail \(detail)")
                    let biomaterial = NSMutableDictionary()
                    if(detail["received"] as! String == "true"){
                        biomaterial.setValue(CENTER_ID, forKey: "current_center_id")
                    }else{
                        biomaterial.setValue(CENTER_ID+" - missed", forKey: "current_center_id")
                    }
                    biomaterial.setValue(detail["biomaterial_location_id"] as! String, forKey: "biomaterial_location_id")
                    biomaterial.setValue(detail["ensat_id"] as! String, forKey: "ensat_id")
                    biomaterial.setValue(detail["center_id"] as! String, forKey: "center_id")
                    let positionAttributes = getPositionBy(positionIDStr: detail["temparyPosition"] as! String).componentsSeparatedByString("-")
                    
                    biomaterial.setValue(positionAttributes[0], forKey: "freezer_number")
                    biomaterial.setValue(positionAttributes[1], forKey: "freezershelf_number")
                    biomaterial.setValue(positionAttributes[2], forKey: "rack_number")
                    biomaterial.setValue(positionAttributes[3], forKey: "shelf_number")
                    biomaterial.setValue(positionAttributes[4], forKey: "box_number")
                    biomaterial.setValue(positionAttributes[5], forKey: "position_number")
                    if(detail["section"] != nil){
                        biomaterial.setValue(detail["section"] as! String, forKey: "section")
                    }else{
    //                    biomaterial.setValue("", forKey: "section")
                    }
                    submitBiomaterials.addObject(biomaterial)
    //                }
                }
            }
        }
        return submitBiomaterials
    }
    
    func achieveDetails(){
        /* Web request to achieve transmit biomaterial data and freezer
            details like freezer structure and used positions. */
        if (!fileID.isEmpty){
            let urlPath: String = "http://"+ADDRESS+":8080/ENSAT/jsp/ios_get_details.jsp"
            let data:String = "spreadsheet_id="+fileID+"&center_id="+CENTER_ID
            HttpRequest.postHttpRequest(urlPath: urlPath, dataString: data, delegate: self)
        }else{
            AlertView.showNotice(message: "Please input username and password", inView: self)
        }
    }
    
    func getAllFreezersCapacity()->Int {
        var total = 0
        if freezerStructures.count > 0 {
            for i in 0...freezerStructures.count-1 {
                let freezerStructure:NSDictionary = freezerStructures[i] as! NSDictionary
//                let freezerNumber:Int = (freezerStructure["freezer_number"] as! String).toInt()!
                let freezerCapacity:Int = Int((freezerStructure["freezer_capacity"] as! String))!
                let freezerShelfCapacity:Int = Int((freezerStructure["freezer_shelf_capacity"] as! String))!
                let rackCapacity:Int = Int((freezerStructure["rack_capacity"] as! String))!
                let rackShelfCapacity:Int = Int((freezerStructure["rack_shelf_capacity"] as! String))!
                let boxCapacity:Int = Int((freezerStructure["box_capacity"] as! String))!
                total += freezerCapacity * freezerShelfCapacity * rackCapacity * rackShelfCapacity * boxCapacity
                
//                print("freezerCapacity \(freezerCapacity) freezerShelfCapacity \(freezerShelfCapacity) rackCapacity \(rackCapacity) rackShelfCapacity \(rackShelfCapacity) boxCapacity \(boxCapacity) ")
            }
        }
//        print(getPositionBy(positionIDStr: "1"))
        return total
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
        let json : AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
        if(json == nil){
            AlertView.showAlert(title: "Incorrect", message: "Cannot connect to Sever, Please contact to Administrator", inView: self)
        }else{
            if(json!.valueForKey("type") as! String=="ios_get_details"){
                if let array = json!.objectForKey("data") as? NSArray{
                    //if it is an array, set it as tableview's data source
                    details = array
//                    print("json \(json)")
                    
                    // ensuer the company has freezer capacity to store biomaterial
                    if let _ = json!.objectForKey("freezerCapacity")! as? String {
                        AlertView.showNotice(message: "There is no freezer structure for your center, Please contact to Administrator", inView: self, handler: {(actionSheetController) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }else{
                        // store freezer structure and used position which will be used to recommond position
                        if let tempArray = json!.objectForKey("freezerCapacity") as? NSArray{
                            freezerStructures = tempArray
                            allFreezersCapacity = getAllFreezersCapacity()
                        }
                        if let tempArray = json!.objectForKey("usedPositions") as? NSArray{
                            if let _ = json!.objectForKey("usedPositions")! as? String {
                                usedPositions = NSArray()
                            }else{
                                usedPositions = tempArray
                            }
                        }
                        
                        // Add received and temparyPosition into the detail
                        if details.count > 0 {
                            for i in 0...details.count-1 {
                                let detail = details[i] as! NSMutableDictionary
                                /* Add receive information into detail, default is true which means received */
                                if (detail["received"] == nil){
                                    detail["received"] = "true"
                                }
                                /* If the detail do not include the next usable position, get one by getNextUsablePosition() */
                                if (detail["temparyPosition"] == nil){
                                    detail["temparyPosition"] = getNextUsablePositionID()
//                                    print("temparyPosition ", terminator: "")
//                                    print(detail["temparyPosition"])
                                }
                            }
                        }
                        
                        // recieve new data, so refresh the table
                        detailsTableView.reloadData()
                    }
                }
            }else if(json!.valueForKey("type") as! String=="ios_update_biomaterial"){
                let result = json!.objectForKey("result") as! String
                if result == "1" {
                    
                    AlertView.showAlert(title: "Success", message: "Your operation is successful! ", inView: self, handler: {(actionSheetController) -> Void in self.dismissViewControllerAnimated(true, completion: nil)})
                }else{
                    AlertView.showError(message: "Some problems happened, Please contact to Administratorsel", inView: self)
                }
                
            }
            
        }
        
        /* test get position recommand */
//        getNextUsablePosition()
        
    }
    
    //tableview delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("details size\(details.count)")
        return details.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let detailCell : DetailTableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DetailTableViewCell
        
        detailCell.freezerTextField.delegate = self
        detailCell.freezerShelfTextField.delegate = self
        detailCell.rackTextField.delegate = self
        detailCell.rackShelfTextField.delegate = self
        detailCell.boxTextField.delegate = self
        detailCell.positionTextField.delegate = self
        
        
        let detail = details[indexPath.row] as! NSMutableDictionary
//        println("detail \(detail)")
        detailCell.ensatIDLabel.text = (detail["center_id"] as! String)+"-"+(detail["ensat_id"] as! String)
        detailCell.bioIDLable.text = (detail["bio_id"] as! String)
        detailCell.materialLable.text = (detail["material"] as! String)
        detailCell.aliquotIDLabel.text = (detail["aliquot_sequence_id"] as! String)
        
        /* Add receive information into detail, default is true which means received */
        if (detail["received"] == nil){
            detail["received"] = "true"
        }
        /* Set the condition of received switcher in cell, according to received value */
        if (detail["received"] as! String == "true"){
            detailCell.receivedSwitch.setOn(true, animated: false)
        }else{
            detailCell.receivedSwitch.setOn(false, animated: false)
        }
        
        /* If the detail do not include the next usable position, get one by getNextUsablePosition() */
        if (detail["temparyPosition"] == nil){
            detail["temparyPosition"] = getNextUsablePositionID()
//            print("temparyPosition ", terminator: "")
//            print(detail["temparyPosition"])
        }
        /* Whether the tempary position is valid or not */
        if (detail["temparyPosition"] as! String == "-1"){
            detailCell.freezerTextField.text = ""
            detailCell.freezerShelfTextField.text = ""
            detailCell.rackTextField.text = ""
            detailCell.rackShelfTextField.text = ""
            detailCell.boxTextField.text = ""
            detailCell.positionTextField.text = ""
        }else{
            let positionAttributes = getPositionBy(positionIDStr: (detail["temparyPosition"] as! String)).componentsSeparatedByString("-")
            detailCell.freezerTextField.text = positionAttributes[0]
            detailCell.freezerShelfTextField.text = positionAttributes[1]
            detailCell.rackTextField.text = positionAttributes[2]
            detailCell.rackShelfTextField.text = positionAttributes[3]
            detailCell.boxTextField.text = positionAttributes[4]
            detailCell.positionTextField.text = positionAttributes[5]
        }
        
        if detail["received"] as! String == "false" {
            detailCell.noticeLabel.textColor = UIColor.redColor()
            detailCell.noticeLabel.text = RECEIVED_NOTICE
        }else if detail["temparyPosition"] as! String == "-1" {
            detailCell.noticeLabel.textColor = UIColor.redColor()
            detailCell.noticeLabel.text = POSITION_NOTICE
        }else{
            detailCell.noticeLabel.textColor = UIColor.blackColor()
            detailCell.noticeLabel.text = DEFAULT_NOTICE
        }
        
        /* set action listen to textFields and Switchs */
        detailCell.freezerTextField.tag = indexPath.row
        detailCell.freezerTextField.addTarget(self, action: "textFieldModified:", forControlEvents: UIControlEvents.EditingChanged)
        detailCell.freezerShelfTextField.tag = indexPath.row
        detailCell.freezerShelfTextField.addTarget(self, action: "textFieldModified:", forControlEvents: UIControlEvents.EditingChanged)
        detailCell.rackTextField.tag = indexPath.row
        detailCell.rackTextField.addTarget(self, action: "textFieldModified:", forControlEvents: UIControlEvents.EditingChanged)
        detailCell.rackShelfTextField.tag = indexPath.row
        detailCell.rackShelfTextField.addTarget(self, action: "textFieldModified:", forControlEvents: UIControlEvents.EditingChanged)
        detailCell.boxTextField.tag = indexPath.row
        detailCell.boxTextField.addTarget(self, action: "textFieldModified:", forControlEvents: UIControlEvents.EditingChanged)
        detailCell.positionTextField.tag = indexPath.row
        detailCell.positionTextField.addTarget(self, action: "textFieldModified:", forControlEvents: UIControlEvents.EditingChanged)
        detailCell.receivedSwitch.tag = indexPath.row
        detailCell.receivedSwitch.addTarget(self, action: "switchModified:", forControlEvents: UIControlEvents.ValueChanged)
        
        return detailCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    /* Switch modifying process */
    func switchModified(sender:UISwitch){
        let currentDetail = details[sender.tag] as! NSMutableDictionary
        let currentTableViewCell = sender.superview?.superview as! DetailTableViewCell
        if (sender.on){
            print("on on on on on on")
            currentDetail["received"] = "true"
            if currentDetail["temparyPosition"] as! String == "-1" {
                currentTableViewCell.noticeLabel.textColor = UIColor.redColor()
                currentTableViewCell.noticeLabel.text = POSITION_NOTICE
            }else{
                currentTableViewCell.noticeLabel.textColor = UIColor.blackColor()
                currentTableViewCell.noticeLabel.text = DEFAULT_NOTICE
            }
        }else{
            print("off off off off of ")
            currentDetail["received"] = "false"
            currentTableViewCell.noticeLabel.textColor = UIColor.redColor()
            currentTableViewCell.noticeLabel.text = RECEIVED_NOTICE
        }
    }
    
    /* textField modifying process */
    func textFieldModified(sender:UITextField){
        let currentDetail = details[sender.tag] as! NSMutableDictionary
        let currentTableViewCell = sender.superview?.superview as! DetailTableViewCell
        let freezerNoStr = currentTableViewCell.freezerTextField.text
        let freezerShelfNoStr = currentTableViewCell.freezerShelfTextField.text
        let rackNoStr = currentTableViewCell.rackTextField.text
        let rackShelfNoStr = currentTableViewCell.rackShelfTextField.text
        let boxNoStr = currentTableViewCell.boxTextField.text
        let positionNoStr = currentTableViewCell.positionTextField.text
        let positionIDStr = getPositionIDBy(freezerNoStr: freezerNoStr!, freezerShelfNoStr: freezerShelfNoStr!, rackNoStr: rackNoStr!, rackShelfNoStr: rackShelfNoStr!, boxNoStr: boxNoStr!, positionNoStr: positionNoStr!)
        
        temporaryUsed.removeObjectForKey(currentDetail["temparyPosition"] as! String)
        if checkPosition(positionIDStr: positionIDStr) {
            print("empty empty")
            currentDetail["temparyPosition"] = positionIDStr
            if(currentTableViewCell.noticeLabel.text == POSITION_NOTICE){
                currentTableViewCell.noticeLabel.textColor = UIColor.blackColor()
                currentTableViewCell.noticeLabel.text = DEFAULT_NOTICE
            }
        }else{
            print("occupied occupied")
            currentDetail["temparyPosition"] = "-1"
            if(currentTableViewCell.noticeLabel.text == DEFAULT_NOTICE){
                currentTableViewCell.noticeLabel.textColor = UIColor.redColor()
                currentTableViewCell.noticeLabel.text = POSITION_NOTICE
            }
        }
//        print("sender.tag \(sender.tag)")
    }
    
    /* Check whether the prosition is empty or occupied. 
        true means this postion is empty, false means occupied. */
    func checkPosition(positionIDStr positionIDStr:String)->Bool {
        if temporaryUsed.valueForKey(positionIDStr) == nil {
            let position = getPositionBy(positionIDStr: positionIDStr)
             // check the position is valid and not larger than the total capacity.
            if position == "-1"{
                return false
            }else if let positionID = Int(positionIDStr){
                if usedPositions.count > 0 {
                    for i in 0...usedPositions.count-1 {
                        let usedPosition:NSDictionary = usedPositions[i] as! NSDictionary
                        let currentPositionID = Int(getPositionIDBy(freezerNoStr: usedPosition["freezer_number"] as! String, freezerShelfNoStr: usedPosition["freezershelf_number"] as! String, rackNoStr: usedPosition["rack_number"] as! String, rackShelfNoStr: usedPosition["shelf_number"] as! String, boxNoStr: usedPosition["box_number"] as! String, positionNoStr: usedPosition["position_number"] as! String))
                        
                        /* if input position is as same as used position, return false.
                            Because usedPositions is in order, if the current position ID is larger than position ID, the continuous postion are also larger, so return true */
                        if currentPositionID == positionID {
                            return false
                        }else if currentPositionID > positionID {
                            temporaryUsed.setValue(positionIDStr, forKey: positionIDStr)
                            return true
                        }
                    }
                }
                return true
            }else{
                return false
            }
        }else{
            // If the position is temporary Used, return false.
            return false
        }
    }
    
    /* Find the next usable position to recomand user.
        Return the empty postion,
        or Return "-1" that means there is no more postions. */
    func getNextUsablePositionID() -> String{
        // test convert between position and position id
        var lastPositionID = "0"
        
        if usedPositions.count > 0 {
            for i in 0...usedPositions.count-1 {
                let usedPosition:NSDictionary = usedPositions[i] as! NSDictionary
                let currentPositionID = getPositionIDBy(freezerNoStr: usedPosition["freezer_number"] as! String, freezerShelfNoStr: usedPosition["freezershelf_number"] as! String, rackNoStr: usedPosition["rack_number"] as! String, rackShelfNoStr: usedPosition["shelf_number"] as! String, boxNoStr: usedPosition["box_number"] as! String, positionNoStr: usedPosition["position_number"] as! String)
                if(Int(currentPositionID)! - Int(lastPositionID)! > 1){
    //                println("lastPositionID \(lastPositionID) currentPositionID \(currentPositionID)")
    //                println("in if")
                    for i in Int(lastPositionID)!+1...Int(currentPositionID)!-1 {
                        if (temporaryUsed.valueForKey("\(i)") == nil){
                            temporaryUsed.setValue("\(i)", forKey: "\(i)")
                            return "\(i)"
                        }
                    }
                }
                lastPositionID = currentPositionID
            }
        }else{
            if allFreezersCapacity > Int(lastPositionID) {
                for i in Int(lastPositionID)!+1...allFreezersCapacity {
                    if (temporaryUsed.valueForKey("\(i)") == nil){
                        temporaryUsed.setValue("\(i)", forKey: "\(i)")
                        return "\(i)"
                    }
                }
            }
        }
        return "-1"
    }

    /* Get the unique position id throng freezerNo, freezerShelfNo, rackNo, rackShelfNo, boxNo, positionNo values.
        All positions change to uniform postion ID, which is easy to findout empty position.
        Return "-1" means the postion is invalid. */
    func getPositionIDBy(freezerNoStr freezerNoStr:String, freezerShelfNoStr:String, rackNoStr:String, rackShelfNoStr:String, boxNoStr:String, positionNoStr:String)->String{
        if let freezerNo:Int = Int(freezerNoStr), freezerShelfNo:Int = Int(freezerShelfNoStr), rackNo:Int = Int(rackNoStr), rackShelfNo:Int = Int(rackShelfNoStr), boxNo:Int = Int(boxNoStr), positionNo:Int = Int(positionNoStr) {
            var startNumber:Int = 0
            
            if freezerStructures.count > 0 {
                for i in 0...freezerStructures.count-1 {
                    let freezerStructure:NSDictionary = freezerStructures[i] as! NSDictionary
                    let freezerNumber:Int = Int((freezerStructure["freezer_number"] as! String))!
                    let freezerCapacity:Int = Int((freezerStructure["freezer_capacity"] as! String))!
                    let freezerShelfCapacity:Int = Int((freezerStructure["freezer_shelf_capacity"] as! String))!
                    let rackCapacity:Int = Int((freezerStructure["rack_capacity"] as! String))!
                    let rackShelfCapacity:Int = Int((freezerStructure["rack_shelf_capacity"] as! String))!
                    let boxCapacity:Int = Int((freezerStructure["box_capacity"] as! String))!
                    if (freezerNumber == freezerNo){
                        if freezerCapacity < freezerShelfNo || freezerShelfCapacity < rackNo || rackCapacity < rackShelfNo || rackShelfCapacity < boxNo || boxCapacity < positionNo {
                            //if the position is larger than the capacity, the position is invalid return "-1".
                            return "-1"
                        }else{
                            startNumber += (freezerShelfNo - 1) * freezerShelfCapacity * rackCapacity * rackShelfCapacity * boxCapacity
                            startNumber += (rackNo - 1) * rackCapacity * rackShelfCapacity * boxCapacity
                            startNumber += (rackShelfNo-1) * rackShelfCapacity * boxCapacity
                            startNumber += (boxNo - 1) * boxCapacity + positionNo
                            return String(startNumber)
                        }
                    }else{
                        let totalCapacity = freezerCapacity * freezerShelfCapacity * rackCapacity * rackShelfCapacity * boxCapacity;
//                        println("totalCapacity \(totalCapacity)")
                        startNumber+=Int(totalCapacity)
                    }
                }
            }
            return "-1"
        }else{
            // input position cannot convert to int so return "-1"
            return "-1"
        }
    }
    
    /* convert position back to "freezerNo-freezerShelfNo-rackNo-rackShelfNo-boxNo-positionNo" */
    func getPositionBy(positionIDStr positionIDStr:String)->String{
        if let positionID:Int = Int(positionIDStr) {
            if positionID <= 0 {
                return "-1"
            }
            var startNumber:Int = 0
            if freezerStructures.count > 0 {
                for i in 0...freezerStructures.count-1 {
                    let freezerStructure:NSDictionary = freezerStructures[i] as! NSDictionary
                    let freezerNumber:Int = Int((freezerStructure["freezer_number"] as! String))!
                    let freezerCapacity:Int = Int((freezerStructure["freezer_capacity"] as! String))!
                    let freezerShelfCapacity:Int = Int((freezerStructure["freezer_shelf_capacity"] as! String))!
                    let rackCapacity:Int = Int((freezerStructure["rack_capacity"] as! String))!
                    let rackShelfCapacity:Int = Int((freezerStructure["rack_shelf_capacity"] as! String))!
                    let boxCapacity:Int = Int((freezerStructure["box_capacity"] as! String))!
                    let totalCapacity = freezerCapacity * freezerShelfCapacity * rackCapacity * rackShelfCapacity * boxCapacity;
//                    println("totalCapacity \(totalCapacity)")
                    if (startNumber + totalCapacity < positionID){
                        startNumber+=Int(totalCapacity)
                    }else{
                        let freezerNo:Int = freezerNumber
                        var relatedNumber:Int = positionID - startNumber
                        let freezerShelfNo:Int = (relatedNumber-1)/(freezerShelfCapacity * rackCapacity * rackShelfCapacity * boxCapacity)+1
                        relatedNumber = relatedNumber - (freezerShelfNo - 1) * freezerShelfCapacity * rackCapacity * rackShelfCapacity * boxCapacity
                        let rackNo:Int = (relatedNumber-1)/(rackCapacity * rackShelfCapacity * boxCapacity)+1
                        relatedNumber = relatedNumber - (rackNo - 1) * rackCapacity * rackShelfCapacity * boxCapacity
                        let rackShelfNo:Int = (relatedNumber-1)/(rackShelfCapacity * boxCapacity)+1
                        relatedNumber = relatedNumber - (rackShelfNo - 1) * rackShelfCapacity * boxCapacity
                        let boxNo:Int = (relatedNumber-1)/(boxCapacity)+1
                        let positionNo:Int = relatedNumber - (boxNo - 1) * boxCapacity
                        return "\(freezerNo)-\(freezerShelfNo)-\(rackNo)-\(rackShelfNo)-\(boxNo)-\(positionNo)"
                    }
                }
            }
            return "-1"
        }else{
            // input position cannot convert to int so return "-1"
            return "-1"
        }
    }
    
//    /* UITextField Delegate */
//    func textFieldDidBeginEditing(textField: UITextField) {
////        self.detailsTableView.set
//        self.detailsTableView.setContentOffset(CGPoint(x: 0, y: 70), animated: true)
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        self.detailsTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        textField.resignFirstResponder()
//        return true
//    }
}

