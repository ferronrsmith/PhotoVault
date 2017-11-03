//
//  LogInViewController.swift
//  ImagePicker
//
//  Created by Hugo Zhang on 10/31/17.
//  Copyright © 2017 Hugo Zhang. All rights reserved.
//

import UIKit
import Firebase

class LogIn : UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        textFieldLoginEmail.delegate = self
        textFieldLoginPassword.delegate = self
        
    }
    
    @IBAction func logIn(_ sender: Any) {
        let email = textFieldLoginEmail.text
        let password = textFieldLoginPassword.text
        print(email! + " cucksy " + password!)
        
        if(email != "")
        {
            if (password != "") {
                Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                    // ...
                    if let user = Auth.auth().currentUser {
                        if !user.isEmailVerified{
                            let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to " + email! + "?", preferredStyle: .alert)
                            let alertActionOkay = UIAlertAction(title: "Ok", style: .default) {
                                (_) in
                                user.sendEmailVerification(completion: { (error) in
                                    
                                })
                                
                            }
                            
                            alertVC.addAction(alertActionOkay)
                            self.present(alertVC, animated: true, completion: nil)
                        } else if error == nil {
                            print ("Email verified. Signing in...")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "MainGallery")
                            self.present(controller, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Log In Failed", message: "Please enter your email or password correctly.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "Missing Password", message: "Please enter your password.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Missing Email", message: "Please enter your email.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
