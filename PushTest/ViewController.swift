//
//  ViewController.swift
//  PushTest
//
//  Created by Malik Bunton on 10/28/15.
//  Copyright © 2015 Malik Bunton. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var usernameSignUp: UITextField!
    @IBOutlet var passwordSignUp: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var usernameLogin: UITextField!
    @IBOutlet var passwordLogin: UITextField!
    

    @IBOutlet var errorSignUpLabel: UILabel!
    @IBOutlet var errorLoginLabel: UILabel!
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBAction func signUpButton(sender: AnyObject) {
        if usernameSignUp.text == "" || passwordSignUp.text == ""{
            errorSignUpLabel.text = "Please type something in the box"
        }
        else{
            errorSignUpLabel.text = ""
            //Make a spinner
            spinner = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            spinner.center = self.view.center
            spinner.hidesWhenStopped = true
            spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(spinner)
            spinner.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            //create a user
            let user = PFUser()
            
            //checks if passwords match
            if passwordSignUp.text != confirmPassword.text{
                self.errorSignUpLabel.text = "passwords do not match dipshit"
                self.spinner.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
            else{
                //sends password and username
                user.username = usernameSignUp.text
                user.password = passwordSignUp.text
                
                var errorMessage = ""
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    self.spinner.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil{
                        //Successful sign up!!
                        self.performSegueWithIdentifier("secondSignUp", sender: self)
                    }
                        
                    else{
                        //if theres an error in the sign up then say it
                        if let errorString = error!.userInfo["error"] as? String{
                            errorMessage =  errorString
                            self.errorSignUpLabel.text = errorMessage
                        }
                        else{
                            self.errorSignUpLabel.text = "Failed Sign Up"
                        }
                    }
                    
                })
            }
            
        }
        
    }
    
    @IBAction func facebookSignUpButton(sender: AnyObject) {
        
    }
    
    @IBAction func loginButton(sender: AnyObject) {
        spinner.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        if usernameLogin.text == "" || passwordLogin.text == ""{
            errorLoginLabel.text = "Please type something in the box"
            self.spinner.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        else{
            PFUser.logInWithUsernameInBackground(usernameLogin.text!, password:passwordLogin.text!) {
                (user, error) -> Void in
                if user != nil {
                    self.spinner.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.errorLoginLabel.text = "Welcome"
                    self.performSegueWithIdentifier("mainpage", sender: self)
                    // Do stuff after successful login.
                } else {
                    if let errorMessage = error!.userInfo["error"] as? String{
                        self.errorLoginLabel.text = errorMessage
                        self.spinner.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    }
                    else{
                        self.spinner.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        self.errorLoginLabel.text = "Something is wrong try again later"
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameLogin.delegate = self
        self.passwordLogin.delegate = self
        self.passwordSignUp.delegate = self
        self.confirmPassword.delegate = self
        self.usernameSignUp.delegate = self

    }
    
    
    //If screen touched drop keboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField:UITextField)-> Bool{
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

