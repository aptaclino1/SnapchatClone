//
//  SignUpVC.swift
//  SnapchatClone
//
//  Created by Messiah on 11/10/23.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameTextInput: FloatingLabelTextField!
    @IBOutlet weak var passwordTextInput: FloatingLabelTextField!
    @IBOutlet weak var emailTextInput: FloatingLabelTextField!
    @IBOutlet weak var logoImage: UIImageView!

    @IBOutlet weak var showHideBttn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        usernameTextInput.delegate = self
        passwordTextInput.delegate = self
        emailTextInput.delegate = self

        logoImage.backgroundColor = .clear
        updateShowHideButtonImage()

       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func showPassword(_ sender: UIButton) {
        passwordTextInput.isSecureTextEntry.toggle()
        updateShowHideButtonImage()
    }

    func updateShowHideButtonImage() {
        let imageName = passwordTextInput.isSecureTextEntry ? "hide" : "see"
        showHideBttn.setImage(UIImage(named: imageName), for: .normal)
    }

    @IBAction func signUpBttn(_ sender: UIButton) {
        guard let email = emailTextInput.text, let password = passwordTextInput.text, let username = usernameTextInput.text else {
            makeAlert(title: "Error!", message: "Username/Password/Email?")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [self] (auth, error) in
            if let error = error {
                makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                let fireStore = Firestore.firestore()
                let userDictionary: [String: Any] = ["email": email, "username": username]
                fireStore.collection("UserInfo").addDocument(data: userDictionary) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }

                let vc = storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabVC
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        }
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

// MARK: UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
