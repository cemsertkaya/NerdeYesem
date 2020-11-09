//
//  SignUpViewController.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 5.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordAgainField: UITextField!
    @IBOutlet weak var signUpButtonClicked: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Keybord Settings
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        emailField.delegate = self;passwordField.delegate = self;passwordAgainField.delegate = self
        passwordField.isSecureTextEntry = true;passwordAgainField.isSecureTextEntry = true
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any)//SignUp Operations
    {
        if emailField.text != "" && passwordField.text != "" && passwordAgainField.text != ""
        {
                    if passwordField.text == passwordAgainField.text
                    {
                        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!)//Authantication
                        { (authData, error) in
                           if error != nil{self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")}//for alertMessages of Firebase}
                          else
                          {
                             let user = Auth.auth().currentUser
                             self.performSegue(withIdentifier: "toMain", sender: self)
                          }
                        }
                      }
                    else{self.makeAlert(titleInput: "Error!", messageInput: "Passwords don't match.")}
                
        }
        else{self.makeAlert(titleInput: "Error!", messageInput: "Everyspace must be filled")}
        
            
   }
  
    @objc func didTapView(gesture: UITapGestureRecognizer){view.endEditing(true)}
    // Start Editing The Text Field
    func textFieldDidBeginEditing(_ textField: UITextField) {moveTextField(textField, moveDistance: -80, up: true)}
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {moveTextField(textField, moveDistance: -80, up: false)}
    // Move the text field in a pretty animation
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool)
    {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {textField.resignFirstResponder();return true}
    func makeAlert(titleInput:String, messageInput:String)//Alert method with parameters
    {
         let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
         let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
         alert.addAction(okButton)
         self.present(alert, animated:true, completion: nil)
    }
}

