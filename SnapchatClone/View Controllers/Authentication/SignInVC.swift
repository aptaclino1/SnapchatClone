//
//  SignInVC.swift
//  SnapchatClone
//
//  Created by Messiah on 11/10/23.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var emailText: FloatingLabelTextField!
    @IBOutlet weak var showHideBttn: UIButton!
    @IBOutlet weak var passwordText: FloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.becomeFirstResponder()
        emailText.isUserInteractionEnabled = true
        passwordText.isUserInteractionEnabled = true
        showHideBttn.isUserInteractionEnabled = true
        
        emailText.placeholder = "EMAIL"
        passwordText.placeholder = "PASSWORD"
        
        
        emailText.delegate = self
        passwordText.delegate = self
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        updateShowHideButtonImage()
    }
    
    @IBAction func signUpBttn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        passwordText.isSecureTextEntry.toggle()
        updateShowHideButtonImage()
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        if passwordText.text != "" && emailText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
                if let error = error {
                    print("Sign-in Error: \(error.localizedDescription)")
                    print("Error Code: \((error as NSError).code)")
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabVC
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        } else {
            self.makeAlert(title: "Error", message: "Password/Email cannot be empty.")
        }
    }
    
    func updateShowHideButtonImage() {
        let imageName = passwordText.isSecureTextEntry ? "hide" : "see"
        showHideBttn.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK:  UITextFieldDelegate
extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
