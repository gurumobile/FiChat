//
//  LoginVC.swift
//  FiChat
//
//  Created by sambo on 5/3/17.
//  Copyright © 2017 sambo. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        if nameField.text != "" {
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                if let err = error {
                    print(err.localizedDescription)
                    
                    return
                }
                self.performSegue(withIdentifier: "toNavigation", sender: nil)
            })
        }
    }
}
