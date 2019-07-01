//
//  Record.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import AVFoundation

enum RecordState {
    case `default`
    case playing
    case paused
}

struct Record {
    
    private var recordAsset: AVURLAsset
    
    var state: RecordState = .default
    var path: URL
    
    var name: String {
        return path.deletingPathExtension().lastPathComponent
    }
    
    var duration: Float {
        let cmTime = recordAsset.duration
        return Float(CMTimeGetSeconds(cmTime))
    }
    
    var currentTime: Float = 0
    
    var precent: Float {
        return currentTime / duration
    }
    
    var durationString: String {
        return duration.stringFormat(toPlaces: 2)
    }
    
    var currentTimeString: String {
        return currentTime.stringFormat(toPlaces: 2)
    }
    
    init(path: URL) {
        self.path = path
        
        recordAsset = AVURLAsset(url: path)
    }
}

extension Record: Equatable {
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.path == rhs.path
    }
}
