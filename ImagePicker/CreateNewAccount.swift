//
//  CreateNewAccount.swift
//  ImagePicker
//
//  Created by Hugo Zhang on 11/2/17.
//  Copyright © 2017 Hugo Zhang. All rights reserved.
//

import UIKit
import Firebase

class CreateNewAccount : UIViewController, UITextFieldDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword1: UITextField!
    @IBOutlet weak var textFieldPassword2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        textFieldEmail.delegate = self
        textFieldPassword1.delegate = self
        textFieldPassword2.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    func goBackToLogIn (action : UIAlertAction) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if textFieldPassword1.text == textFieldPassword2.text {
            
            let email = textFieldEmail.text
            let password = textFieldPassword1.text
            
            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                if error != nil{
                    let alert = UIAlertController(title: "User exists.", message: "Please use another email or sign in.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    print("Email has been used, try a different one")
                }else{
                    
                    Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
                        
                    })
                    
                    let alert = UIAlertController(title: "Account Created", message: "Please verify your email by confirming the sent link.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: self.goBackToLogIn))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                    
                    
                    
                    
                    
                    print("This is a college email and user is created")
                    

                    
                    
                    
                    
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Passwords Must Match", message: "Please verify that passwords are the same.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
