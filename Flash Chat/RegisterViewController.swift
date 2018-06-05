//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//  Created by David Huang on 04/09/18.
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in //Completion Handler
            SVProgressHUD.dismiss()
            if error != nil{ //If there was an error
                print("------")
                print(error.debugDescription)
                
                if error.debugDescription.contains("ERROR_WEAK_PASSWORD"){
                    let alert = UIAlertController(title: "Error", message: "Password is too weak. Minimum of 6 characters.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                else if error.debugDescription.contains("ERROR_INVALID_EMAIL"){
                    let alert = UIAlertController(title: "Error", message: "The email you entered is invalid.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
             
                
                
            }
            else{ //If there were no errors
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "Registration successful!")
                SVProgressHUD.dismiss(withDelay: 1)
                
                print("Registration successful!")
                self.performSegue(withIdentifier: "goToChat", sender: self) //Go to chat after successful registration, have to use self.preform because control is within (user,error) in scope
            }
        }
        

        
        
    } 
    
    
}
