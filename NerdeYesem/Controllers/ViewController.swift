//
//  ViewController.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 5.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Keybord Settings
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        emailField.delegate = self;passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        
    }
    
    @IBAction func loginButtonClicked(_ sender: Any)
    {
        if emailField.text != "" && passwordField.text != ""
        {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!)//Firebase signIn methods
            { (authData, error) in
                if error != nil{self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")}
                else
                {
                    let user = Auth.auth().currentUser
                    self.performSegue(withIdentifier: "toMain", sender: self)
                }
            }
        }
        else
        {
            self.makeAlert(titleInput: "Error!", messageInput: "Everyspace must be filled")
        }
    }
    
    
    ///Starts Editing The Text Field
    @objc func didTapView(gesture: UITapGestureRecognizer){view.endEditing(true)}
    func textFieldDidBeginEditing(_ textField: UITextField) {moveTextField(textField, moveDistance: -80, up: true)}
    /// Finishes Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {moveTextField(textField, moveDistance: -80, up: false)}
    /// Moves the text field in a pretty animation
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
    /// Hides the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {textField.resignFirstResponder();return true}
    func makeAlert(titleInput:String, messageInput:String)//Alert method with parameters
    {
         let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
         let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
         alert.addAction(okButton)
         self.present(alert, animated:true, completion: nil)
    }

}

