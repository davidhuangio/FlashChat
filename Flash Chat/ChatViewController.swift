//
//  ViewController.swift
//  Flash Chat
//
//  Created by David Huang on 04/09/18.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        //Register xib(nib) by using .register method and creating a UINib object, CellReuseIdentifier is the name of the cell design i.e. customMessageCell
        
        configureTableView()
        retrieveMessage()
        messageTableView.separatorStyle = .none
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named:"egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String?{
            //Messages we sent
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }else{
            cell.avatarImageView.backgroundColor = UIColor.flatRed()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
        
    }
    
    
    //TODO: Declare numberOfRowsInSection here: (How many cells do you want displayed in the TableView)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 12.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 310
            self.view.layoutIfNeeded() //If something in the view has changed reload the layout
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here: (Not automatically done, have to be called when tapping anywhere else)
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody":messageTextfield.text!]
        
        
        //TODO: Send the message to Firebase and save it in our database
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error,reference) in
            
            if error != nil{
                print(error!)
            }else{
                print("Messaged saved successfully.")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessage(){
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(DataEventType.childAdded){
           (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let newMessage = Message()
            newMessage.messageBody = snapshotValue["MessageBody"]!
            newMessage.sender = snapshotValue["Sender"]!
            
            self.messageArray.append(newMessage)
            self.configureTableView() //Configure view for new message
            self.messageTableView.reloadData() //Reload the data
            
        }
    }
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do{
          try Auth.auth().signOut() //.signOut() can throw error so you must do try catch
            
          navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("Error signing out.")
        }
        
    }
    


}
