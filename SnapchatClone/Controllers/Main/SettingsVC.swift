//
//  SettingsVc.swift
//  SnapchatClone
//
//  Created by Messiah on 11/9/23.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: self.view.bounds)
             backgroundImage.image = UIImage(named: "background")
             backgroundImage.contentMode = .scaleAspectFill
             self.view.addSubview(backgroundImage)
             self.view.sendSubviewToBack(backgroundImage)
    }
    

    @IBAction func logOutButton(_ sender: UIButton) {
        
        do {
            try  Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        } catch {
            
        }
    }
}
    
