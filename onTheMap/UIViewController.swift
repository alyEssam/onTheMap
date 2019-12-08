//
//  UIViewController.swift
//  onTheMap
//
//  Created by Aly Essam on 8/27/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
// Mark: -- Alert Method
/***************************************************************/
    
 func raiseAlertView(withTitle: String, withMessage: String) {
        
      let alertController = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alertController, animated: true)
    }
    
    //MARK: Moving a view out of the way of the Keyboard
    /** Keyboard functions **/
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // When the keyboardWillShow notification is received, shift the view's frame up
    @objc func keyboardWillShow(_ notification:Notification) {
        if UIDevice.current.orientation.isLandscape {
                view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    // When the keyboardWillHide notification is received, shift the view's frame down
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    //To get the height of the Keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    //Hide keyboard when tapped outside it
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //Dismiss the keyboard when a user presses return key.
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

