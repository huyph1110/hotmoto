//
//  CountUpdateViewController.swift
//  hotmoto
//
//  Created by Huy on 9/10/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class CountUpdateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        stepCount.step = 1
        stepCount.max = max
        stepCount.min = min
        stepCount.value = value
        stepCount.tfContent.font = UIFont.systemFont(ofSize: 17)
        stepCount.actionHandle = {
            (finish) -> Void in
            
        }
        
        // Do any additional setup after loading the view.
    }
    var completeHandler : ((Int) -> Void)?
    var max = 10
    var min = 0
    var value = 0

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        completeHandler?(stepCount.value)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var stepCount: GreenStepField!

}
