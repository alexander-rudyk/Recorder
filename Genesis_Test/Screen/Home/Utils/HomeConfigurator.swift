//
//  HomeConfigurator.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import Foundation

class HomeConfigurator {
    
    class func configure(_ controller: HomeViewController) {
        let uiInitializer = HomeUIInitializer(with: controller)
        controller.uiInitializer = uiInitializer
        
        let interactor = HomeInteractor(with: controller)
        controller.interactor = interactor
        
        let recordWorker = RecordWorker(with: interactor)
        let fileWorker = FileWorker()
        let playerWorker = PlayerWorker()
        
        interactor.recordsWorker = recordWorker
        interactor.fileWorker = fileWorker
        interactor.playerWorker = playerWorker
    }
}
