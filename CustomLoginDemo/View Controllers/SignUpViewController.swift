//
//  SignUpViewController.swift
//  CustomLoginDemo
//
//  Created by Foo Jia Jieng on 14/04/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
        
    }

    func setUpElements(){
        
        //Hide the error label
        errorLabel.alpha = 0
    
        //Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    //Check the Fields and Validate that the Fields is Correct. If Everything correct, this method return nil. Otherwise, it returns error message
    func validateFields() -> String?{
        
        //Check that all Fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please Fill in All Fields."
        }
        
        //check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //Password isn't secure
            return "Please make sure password is at least 8 characters, contain atleast a special character and a number"
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //Validate the Fields
        let error = validateFields()
        if error != nil{
            //There's something wrong with the fields show error message
            showError(error!)
        }
        
        else{
            
            //Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create Users
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for Error
                if err != nil {
                    //If there was an error creating user
                    self.showError("Error creating user")
                }
                else{
                    //User was created successfully,now store the first and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid":result!.user.uid ]){ (error) in
                        
                        if error != nil{
                            //Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    //Transition to the Main Screen (ViewController)
                    self.transitionToView()
                }
            }
        
    }
    }
    
    func showError(_ message: String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToView(){
        //Constant.Storyboard can find at Helpers folder.Constants.swift
        let viewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.viewController) as? ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
