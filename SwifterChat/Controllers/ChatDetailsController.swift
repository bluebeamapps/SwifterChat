//
//  ChatDetailsController.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 12/29/15.
//  Copyright © 2015 Bluebeam Apps. All rights reserved.
//

import Foundation
import UIKit

class ChatDetailsController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarConstraintDefaultValue: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        
        //Set up the toolbar.
        toolbarConstraintDefaultValue = toolbarBottomConstraint.constant
        
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        textField.backgroundColor = UIColor.blackColor()
        
        let item = UIBarButtonItem(customView: textField)
        
        toolbar.items = [item]
        
        //Register for keyboard events.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        //Add gesture recognizer that will listen for taps on the TableView. Keyboard will then be dismissed when a tap is detected.
        let tgc = UITapGestureRecognizer(target: self, action: "onTableViewTapped")
        tableView.addGestureRecognizer(tgc)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.toolbarHidden = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("ChatMessageCellLeft")
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("ChatMessageCellRight")
        }
        
        let container = cell.viewWithTag(100)!
        container.layer.cornerRadius = 15
        container.layer.shadowOffset = CGSize(width: indexPath.row % 2 == 0 ? 1 : -1, height: 1)
        container.layer.shadowOpacity = 0.15
        container.layer.shadowRadius = 1.0
        container.layer.masksToBounds = false
        
//        let messageLabel = container.viewWithTag(101) as! UILabel
        
        return cell
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration) { () -> Void in
            self.toolbarBottomConstraint.constant = keyboardFrame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo!
        
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animateWithDuration(duration) { () -> Void in
            self.toolbarBottomConstraint.constant = self.toolbarConstraintDefaultValue
            self.view.layoutIfNeeded()
        }
    }
    
    func onTableViewTapped() {
        self.view.endEditing(true)
    }
}