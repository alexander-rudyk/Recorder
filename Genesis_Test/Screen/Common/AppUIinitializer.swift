//
//  AppUIinitializer.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import UIKit

class AppUIinitializer: IInitializer {
    
    func initialize() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let window = delegate?.window
        let vc = ViewControllerFactory.createHomeVC()
        
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
}
