//
//  LogInViewController.swift
//  onTheMap
//
//  Created by Aly Essam on 8/21/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit


class ViewController: UIViewController, UITextFieldDelegate {

    //IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet  var loginViaFacebook: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: Program Life Time

    override func viewDidLoad() {
         super.viewDidLoad()
        /* Textfield Delegates */
        emailTextField.delegate = self
        passwordTextField.delegate = self
        hideKeyboardWhenTappedAround()
        emailTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(sender:)), for: .editingChanged)
        
//        let loginBut = FBLoginButton(permissions: [.publicProfile, .email])
//        loginBut.center = self.view.center
//        self.view.addSubview(loginBut)
        
        loginViaFacebook = FBLoginButton(permissions: [.publicProfile, .email])
        loginViaFacebook.addTarget(self, action: #selector(facebookManager), for: .touchUpInside)
        
        if let accessTocken = AccessToken.current {
           print("ACCESS_TOKEN - " + accessTocken.tokenString)
           fetchUserProfile()
       }
    }
    func fetchUserProfile()
    {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error took place: \(String(describing: error))")
            }
            else
            {
                print("Print entire fetched result: \(String(describing: result))")
                let alertController = UIAlertController(
                    title: "Login Success",
                    message: "Login succeeded with granted permissions: \(String(describing: result!))",
                    preferredStyle: UIAlertController.Style.alert
                )
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    @objc func facebookManager() {
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.publicProfile, .userFriends, .email],
            viewController: self
        ) { result in
            self.loginManagerDidComplete(result)
        }
    }
       func loginManagerDidComplete(_ result: LoginResult) {
              let alertController: UIAlertController
              switch result {
              case .cancelled:
                  alertController = UIAlertController(
                      title: "Login Cancelled",
                      message: "User cancelled login.",
                      preferredStyle: UIAlertController.Style.alert
                  )
    
              case .failed(let error):
                  alertController = UIAlertController(
                      title: "Login Fail",
                      message: "Login failed with error \(error)",
                      preferredStyle: UIAlertController.Style.alert
                  )
    
              case .success(let grantedPermissions, _, _):
                  alertController = UIAlertController(
                      title: "Login Success",
                      message: "Login succeeded with granted permissions: \(grantedPermissions)",
                      preferredStyle: UIAlertController.Style.alert
                  )
                  
              }
        
              self.present(alertController, animated: true, completion: nil)
          }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        loginButton.isEnabled = false
        subscribeToKeyboardNotifications() //Subscribe to keyboard notifications to detect when the keyboard appears
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications() // Unsubscribe from keyboard notifications
    }
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        if emailTextField.text != ""  && passwordTextField.text != "" {
            loginButton.isEnabled = true
        }
        else {
            loginButton.isEnabled = false
        }
    }
    //IBActions
    @IBAction func signUpPressed(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signup.url)
    }
    @IBAction func loginPressed(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(username: self.emailTextField.text!, password: self.passwordTextField.text!, completion: handleLoginResponse(success:error:))
   }
    
//    @IBAction func facebookLogin(_ sender: Any) {
////        raiseAlertView(withTitle: "Future Work", withMessage: "Login with Faccebook is not ready now, it is for future work!")
////        //facebookManager()
//    }
    //MARK: Handle Network Response
    func handleLoginResponse (success: Bool, error: Error?) {
        if success {
            setLoggingIn(false)
            UdacityClient.getStudentData()
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        }
        else {
            raiseAlertView(withTitle: "Login Failed", withMessage: error?.localizedDescription ?? "" )
            setLoggingIn(false)
        }
    }
    
    
    
    
//MARK: Configuration the UI
func setLoggingIn(_ loggingIn: Bool){
        if loggingIn {
           activityIndicator.startAnimating()
         }
        else {
           activityIndicator.stopAnimating()
         }
       configUI(enable: !loggingIn)
    }
func configUI(enable: Bool){
    emailTextField.isEnabled = enable
    passwordTextField.isEnabled = enable
    loginButton.isEnabled = enable
  }
    
}
