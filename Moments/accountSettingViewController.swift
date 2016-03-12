//
//  accountSettingViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-11.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Firebase

class accountSettingViewController: UIViewController,UITextFieldDelegate {
    let ref = Firebase(url: "https://momentsxmen.firebaseio.com/")
    var useremail = ""
    var password = ""
    @IBOutlet weak var resetemail: UITextField!
    
    
    
    @IBAction func resetbutton(sender: AnyObject) {
        
        //pop up an alert for asking password
        
        let alert = UIAlertController(title: "Required password", message: "Please type your password in order to complete process",preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
       // alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
           // println("Handle Ok logic here")
            
            let textfield = alert.textFields![0] as UITextField
           self.password = textfield.text!
            print(self.password)
            self.changeEmail()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter password"
            textField.secureTextEntry = true
           // print(textField.text)
        })
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    // close keyboard when touches began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    // close keyboard when press return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }

    func changeEmail(){
    
        if resetemail.text != nil {
            
            ref.changeEmailForUser(useremail, password: self.password,
                toNewEmail: self.resetemail.text, withCompletionBlock: { error in
                    if error != nil {
                        // There was an error processing the request
                        print("error")
                        
                        if let errorCode = FAuthenticationError(rawValue: error.code) {
                            switch (errorCode) {
                            case .InvalidEmail:
                                self.displayAlert("Failed", message: "Invalid new email address, please try again")
                            case .InvalidPassword:
                                self.displayAlert("Failed Login", message: "Invalid password, please try again")
                            case .UserDoesNotExist:
                                self.displayAlert("Failed Login", message: "User does not exists, please try again")
                            default:
                                self.displayAlert("Failed Login", message: "An error has occured")
                            }
                        }

                        
                        
                        
                        
                    } else {
                        // Email changed succ
                        
                        
                        self.displayAlert("Succeed!", message: "You have successfully changed your user email")
                        
                        
                    }
            })
            
        }
        
       

    
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(0.2), green: CGFloat(0.211765), blue: CGFloat(0.286275), alpha: 1.0)
        self.resetemail.delegate = self
        if ref.authData != nil{
            
          //  print(ref.authData)
           // print(ref.authData.providerData["email"]!)
            useremail = ref.authData.providerData["email"] as! String
            //print(ref.authData.providerData["password"]!)
            print(ref.authData.provider)
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //Nothing:
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
