//
//  ViewController.swift
//  Test
//
//  Created by Fabian Karl on 29.04.20.
//  Copyright © 2020 Fabian Karl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var vibrationLable: UILabel!
    var vib_value: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vibrationLable.text = "0.00"
        // Do any additional setup after loading the view.
        vibrationLable.text = String(format:"%.2f", self.vib_value)
    }


}

