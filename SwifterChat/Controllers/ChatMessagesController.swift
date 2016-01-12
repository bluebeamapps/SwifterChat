//
//  ChatDetailsController.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 12/29/15.
//  Copyright © 2015 Bluebeam Apps. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChatMessagesController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toolbar: UIToolbar!
    
    var userUID: String!
    var chatEntry: ChatEntry!
    var messagesFrc: NSFetchedResultsController!
    
    var messageField: UITextField!
    var btnSend: UIButton!
    
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    
    //Keep a reference to the toolbar's bottom constraint so we can move it up or down when the keyboard hides or closes.
    @IBOutlet var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarConstraintDefaultValue: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "HH:mm"
        
        userUID = AppDefaults.getUserUID()
        
        title = chatEntry.name
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        
        //Set up the TableView background.
        let color = UIColor(patternImage: UIImage(named: "ChatBackground")!)
        tableView.backgroundView = nil
        tableView.backgroundColor = color
        
        //Register for keyboard events.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        //Add gesture recognizer that will listen for taps on the TableView. Keyboard will then be dismissed when a tap is detected.
        let tgc = UITapGestureRecognizer(target: self, action: "onTableViewTapped")
        tableView.addGestureRecognizer(tgc)
        
        //Configure the messages FRC.
        messagesFrc = ChatMessageStore.sharedInstance.frcForChatMessagesWithChatEntryID(chatEntry.uID!)
        messagesFrc.delegate = self
        
        setUpToolbar()
        scrollTableViewToBottom(false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.toolbarHidden = true
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Row and section count
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = messagesFrc.sections {
            return sections.count
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = messagesFrc.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    //MARK: Cell population
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        let message = messagesFrc.objectAtIndexPath(indexPath) as! ChatMessage
        
        let belongsToUser = message.uIDOwner == userUID
        
        if  belongsToUser {
            cell = tableView.dequeueReusableCellWithIdentifier("ChatMessageCellRight")

        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("ChatMessageCellLeft")
        }
        
        let container = cell.viewWithTag(100)!
        
        //Configure the cell's shadow.
        container.layer.cornerRadius = 15
        container.layer.shadowOffset = CGSize(width: belongsToUser ? 1 : -1, height: 1)
        container.layer.shadowOpacity = 0.15
        container.layer.shadowRadius = 1.0
        container.layer.masksToBounds = false
        
        let messageLabel = container.viewWithTag(101) as! UILabel
        messageLabel.text = message.message
        
        let dateLabel = container.viewWithTag(102) as! UILabel
        dateLabel.text = dateFormatter.stringFromDate(message.timestamp!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatMessageSectionHeaderCell")!
        
        let container = cell.viewWithTag(100)!
        
        //Configure the cell's shadow.
        container.layer.cornerRadius = 10
        container.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        container.layer.shadowOpacity = 0.15
        container.layer.shadowRadius = 1.0
        container.layer.masksToBounds = false
        
        //Calculate the year, month and day from the sectionInfo string.
        let sectionInfo = Int(messagesFrc.sections![section].name)!
        let year = sectionInfo / 10000
        let month = (sectionInfo - year * 10000) / 100
        let day = (sectionInfo - year * 10000 - month * 100)
        
        //Build a NSDate.
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        
        components.year = year
        components.month = month
        components.day = day
        
        let date = calendar.dateFromComponents(components)!
        
        //Display relative date on the label.
        let label = cell.viewWithTag(110) as! UILabel
        label.text = date.elapsedTimeString()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    //MARK:
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        var text: String?
    
        if let textFieldText = textField.text {
            text = (textFieldText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        }

        if text?.isEmpty == true {
            //Disable send button if there is no text in the message field.
            btnSend.enabled = false
        } else {
            //Enable send button if there is text in the message field.
            btnSend.enabled = true
        }
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //Offset the TableView just so the keyboard doesn't cover the messages.
        var offset = tableView.contentOffset
        offset.y += keyboardFrame.size.height
        
        UIView.animateWithDuration(duration) { () -> Void in
            //Update the bottom constraint of the toolbar just so it can move up with the keyboard.
            self.toolbarBottomConstraint.constant = keyboardFrame.size.height
            self.tableView.contentOffset = offset
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo!
        
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //Restore the TableView's offset.
        var offset = tableView.contentOffset
        offset.y -= keyboardFrame.size.height
        
        UIView.animateWithDuration(duration) { () -> Void in
            //Restore the toolbar's bottom constraint.
            self.toolbarBottomConstraint.constant = self.toolbarConstraintDefaultValue
            self.tableView.contentOffset = offset
            self.view.layoutIfNeeded()
        }
    }
    
    func onTableViewTapped() {
        self.view.endEditing(true)
    }
    
    func onSendTapped() {
        let messageText = messageField.text
        
        if messageText?.isEmpty == false {
            ChatMessageStore.sharedInstance.insertMessageWithChatEntryID(chatEntry.uID!, message: messageText!)
            messageField.text = ""
        }
    }
    
    //MARK: FRC Delegate methods.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        scrollTableViewToBottom(true)
        tableView.reloadData()
    }
    
    //MARK:
    private func setUpToolbar() {
        //Set up toolbar and its custom view.
        toolbarConstraintDefaultValue = toolbarBottomConstraint.constant
        
        let customView = UINib(nibName: "ToolbarView", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil)[0] as! UIView
        customView.frame.size.width = toolbar.frame.size.width
        
        messageField = customView.viewWithTag(1) as! UITextField
        messageField.delegate = self
        
        btnSend = customView.viewWithTag(2) as! UIButton
        btnSend.enabled = false
        btnSend.addTarget(self, action: "onSendTapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        let item = UIBarButtonItem(customView: customView)
        
        //Get rid of toolbar's left padding.
        let paddingFix = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        paddingFix.width = -16
        
        toolbar.items = [paddingFix, item]
    }
    
    private func scrollTableViewToBottom(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let sectionCount = self.tableView.numberOfSections
            
            if sectionCount > 0 {
                let rowCount = self.tableView.numberOfRowsInSection(sectionCount - 1)
                
                if rowCount > 0 {
                    let indexPath = NSIndexPath(forRow: rowCount - 1, inSection: sectionCount - 1)
                    self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: animated)
                }
            }
            //End of dispatch block.
        }
    }
    
}