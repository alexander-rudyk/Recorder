//
//  ViewControllerFactory.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import Foundation

class ViewControllerFactory {
    
    class func createHomeVC() -> HomeViewController {
        let vc = HomeViewController()
        HomeConfigurator.configure(vc)
        return vc
    }
}
