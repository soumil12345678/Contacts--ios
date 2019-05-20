//
//  AddContactVC.swift
//  Contacts
//
//  Created by Soumil on 10/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import UIKit
import CoreData
class AddContactVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var numberfield: UITextField!
    var name = ""
    var number = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        namefield.tag = 1
        numberfield.tag = 2
        namefield.delegate = self
        numberfield.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func saveContactAction(_ sender: UIButton) {

        if (namefield.text != "") && (namefield.text != " ") {
                name = namefield.text!
            }
         if (numberfield.text != "") && (numberfield.text != " ") {
                number = numberfield.text!
            }
        if !checkNameAlreadyExists(name: name) && !checkNumberAlreadyExists(number: number) {
            if DataLibrery.shared.saveData(nameData: name, numberData: number) {
                let alert = UIAlertController(title: "Success", message: "Contact Saved", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "Failed", message: "The Name or Number already exists", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Failed", message: "The Name or Number already exists", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2 {
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            } else {
                if ((textField.text?.count)! < 10) {
                    if self.validateCharacter(valueString: string) {
                        return true          
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            }
        }
        else if textField.tag == 1 {
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            } else {
                if ((textField.text?.count)! < 20) {
                    return true
                } else {
                    return false
                }
            }
        }
        else {
            return false
        }
    }
    
    func validateCharacter(valueString:String) ->Bool {
        
        return valueString.range(of: "[^[0-9]]", options: .regularExpression) == nil
    }
    
    func checkNameAlreadyExists (name: String) -> Bool {
            if DataModel.shared.name.contains(name) {
                return true
            } else {
                return false
            }
        }
    
    func checkNumberAlreadyExists (number: String) -> Bool {
        if DataModel.shared.name.contains(number) {
            return true
        } else {
            return false
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
