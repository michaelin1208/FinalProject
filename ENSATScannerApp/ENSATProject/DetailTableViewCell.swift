//
//  DetailTableViewCell.swift
//  ENSATProject
//
//  Created by Michaelin on 15/8/29.
//  Copyright (c) 2015年 Michaelin. All rights reserved.
//

import UIKit
class DetailTableViewCell: UITableViewCell{
    @IBOutlet weak var ensatIDLabel: UILabel!
    @IBOutlet weak var bioIDLable: UILabel!
    @IBOutlet weak var materialLable: UILabel!
    @IBOutlet weak var aliquotIDLabel: UILabel!
    @IBOutlet weak var freezerTextField: UITextField!
    @IBOutlet weak var freezerShelfTextField: UITextField!
    @IBOutlet weak var rackTextField: UITextField!
    @IBOutlet weak var rackShelfTextField: UITextField!
    @IBOutlet weak var boxTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var receivedSwitch: UISwitch!
}
