//
//  ViewController.swift
//  hotmoto
//
//  Created by Huy on 3/25/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txfPasswords: UITextField!
    @IBOutlet weak var txfUserName: UITextField!
    
    var type = LOGIN_TYPE.GUEST
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectLoginType(_ sender: UIButton) {
        if type == LOGIN_TYPE.GUEST {
            type = LOGIN_TYPE.PARK
            
            sender.setTitle("as park", for: .normal)
        }else {
            type = LOGIN_TYPE.GUEST
            sender.setTitle("as guest", for: .normal)

        }
        
    }
    
    @IBAction func login(_ sender: UIButton) {
        if type == LOGIN_TYPE.GUEST {
            self.performSegue(withIdentifier: segue_type.guest.rawValue, sender: self)
        }else {
            self.performSegue(withIdentifier: segue_type.park.rawValue, sender: self)

        }
        
    }
    
}

