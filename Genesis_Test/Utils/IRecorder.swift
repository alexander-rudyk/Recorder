//
//  IRecorder.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/29/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import AVFoundation

protocol IRecorder {
    func setupRecordingSession(_ category:  AVAudioSession.Category)
}

extension IRecorder {
    func setupRecordingSession(_ category:  AVAudioSession.Category) {
        do {
            try AVAudioSession.sharedInstance().setCategory(category, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            print(error)
        }
    }
}
