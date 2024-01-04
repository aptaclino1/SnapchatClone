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
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

