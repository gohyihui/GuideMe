//
//  SmsViewController.swift
//  GuideMe
//
//  Created by student on 7/5/16.
//  Copyright © 2016 ISS. All rights reserved.
//

import Foundation
import UIKit

class SmsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var scrollPage: UIScrollView!
    
    var contactList = NSMutableArray()
    var phoneList = NSMutableArray()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    
    @IBOutlet weak var addOutlet: UIButton!
    
    var contactDB : COpaquePointer = nil;
    
    var insertStatement : COpaquePointer = nil;
    var selectStatement : COpaquePointer = nil;
    var updateStatement : COpaquePointer = nil;
    var deleteStatement : COpaquePointer = nil;
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    
    
    
    
    
    override func viewDidLoad() {
 
        scrollPage.contentSize.height = 700
//        contactList = NSMutableArray()
//        phoneList = NSMutableArray()
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        name.delegate = self
        phone.delegate = self
        
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
//        
//        print(paths)
//        
//        let docsDir = paths + "/contacts.sqlite"
//        
//        if(sqlite3_open(docsDir, &contactDB) == SQLITE_OK)
//        {
//            let sql = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT,PHONE TEXT)"
//            
//            
//            if(sqlite3_exec(contactDB,sql,nil,nil,nil)  !=  SQLITE_OK){
//                print("Failed to create table")
//                print(sqlite3_errmsg(contactDB));
//                
//            }
//        }
//        else {
//            
//            print("Failed to open database")
//            print(sqlite3_errmsg(contactDB));
//            
//        }
//        
//        prepareStartment();
//        
        tableView.delegate = self
        tableView.dataSource = self
        viewContact()
      
    }
    
    
    @IBAction func createContact(sender: AnyObject) {
        
        let nameStr = name.text as NSString?
        
        let phoneStr = phone.text as NSString?
        var contact : Contact = Contact()
        
        contact =  ContactsDataBaseTable.getInstance().createContact(nameStr!,phone: phoneStr!)
        contactList.addObject(contact.name!)
        phoneList.addObject(contact.phoneNumber!)
        status.text = contact.status
        
        
        addOutlet.enabled = false

        tableView.reloadData()

    }
    
    @IBAction func updateContact(sender: AnyObject) {
        let nameStr = name.text as NSString?
        
        let phoneStr = phone.text as NSString?
        var contact : Contact = Contact()
        
        contact = ContactsDataBaseTable.getInstance().updateContact(nameStr!, phone: phoneStr!)
      
            status.text = contact.status
            contactList.removeLastObject()
            contactList.addObject(contact.name!)
            phoneList.removeLastObject()
            phoneList.addObject(contact.phoneNumber!)

        tableView.reloadData()
        
    }
    
    @IBAction func deleteContact(sender: AnyObject) {
        let nameStr = name.text as NSString?
        let phoneStr = phone.text as NSString?
        var contact : Contact = Contact()
        contact = ContactsDataBaseTable.getInstance().deleteContact(nameStr!, phone: phoneStr!)

            status.text = contact.status
            contactList.removeAllObjects()
            phoneList.removeAllObjects()
//            print(contactList)
//            print(phoneList)
     
     
        
        addOutlet.enabled = true
      
        tableView.reloadData()
        
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let contact = contactList[indexPath.row] as! String
        let phone = phoneList[indexPath.row] as! String
        cell.textLabel?.text = contact
        cell.detailTextLabel?.text = phone
        return cell
    }
    
    func viewContact() -> String{

        var contact : Contact = Contact()
        contact = ContactsDataBaseTable.getInstance().loadContact()

        if let name = contact.name {
            if let phone = contact.phoneNumber {
                print ("Inside")
                contactList.addObject(name)
                phoneList.addObject(phone)
            }
        }
 
        if (phoneList.count > 0) {
            
            addOutlet?.enabled = false
            return phoneList[0] as! String
            
        }
        return "Nil"
    }
    
    func retrivePhoneNumber() -> String{
        let phoneNumber = viewContact()
        return phoneNumber
    }
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        name.resignFirstResponder()
        phone.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        name.resignFirstResponder()
        phone.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                self.performSegueWithIdentifier("mainScreen", sender: self)
            default:
                break
            }
        }
    }
    
//    @IBAction func returnToMainScreen(sender: AnyObject) {
//        
//        self.performSegueWithIdentifier("unwindToMainScreen", sender: self)
//    }
}


