//
//  ViewController.swift
//  Test
//
//  Created by Fabian Karl on 29.04.20.
//  Copyright © 2020 Fabian Karl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let delegate = AppDelegate()

    @IBOutlet weak var VibrationLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        VibrationLable.text = String(format:"%.2f", delegate.vibration_value)
    }


}

