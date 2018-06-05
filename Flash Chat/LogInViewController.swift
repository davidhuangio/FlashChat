//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login
//  Created by David Huang on 04/09/18.
//


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            
            if error != nil{
                print(error!)
            }
            else{
                SVProgressHUD.dismiss()
                print("Login complete!")
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
        
        
    }
    


    
}  
