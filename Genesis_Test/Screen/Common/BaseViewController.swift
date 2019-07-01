//
//  BaseViewController.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var uiInitializer: IInitializer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiInitializer?.initialize()
    }
}
