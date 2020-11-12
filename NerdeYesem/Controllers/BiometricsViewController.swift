//
//  BiometricsViewController.swift
//  NerdeYesem
//
//  Created by Cem Sertkaya on 12.11.2020.
//  Copyright © 2020 Cem Sertkaya. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class BiometricsViewController: UIViewController
{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication()
    }
    
    func authentication()
    {
        let currentUser = Auth.auth().currentUser
        var segueString = ""
        if currentUser != nil
        {
          segueString = "toMain"
        }
        else
        {
           segueString = "toSignUp"
        }
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            {
                [weak self] success, authenticationError in
                DispatchQueue.main.sync
                    {
                    if success
                    {
                        self?.performSegue(withIdentifier: segueString, sender: self)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                        alert.addAction(okButton)
                        self?.present(alert, animated: true, completion: nil)
                        
                    }
                }
            }
        }
        else//No biometry
        {
            let alert = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
