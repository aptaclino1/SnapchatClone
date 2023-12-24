//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Messiah on 11/9/23.
//

import UIKit


class LoginVC: UIViewController {
    
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        logoImage.backgroundColor = .clear
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
    }
    @IBAction func signUpButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUp1", sender: nil)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
     performSegue(withIdentifier: "toSignIn", sender: nil)
    }
    
    
}

