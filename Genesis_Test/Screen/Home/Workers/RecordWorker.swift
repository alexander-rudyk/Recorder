//
//  HomeWorker.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import Foundation
import AVFoundation

protocol RecordWorkerDelegate: class {
    func recorder(_ recorder: AVAudioRecorder, didFinisfRecording record: Record)
}

class RecordWorker: NSObject, IRecorder {
    
    struct Constants {
        static let dateFormat = "yyyy-MMM-dd HH:mm:ss"
        static let sampleRate = 8000//1200
        static let numberOfChannels = 1
        static let recordAudioFormat = ".m4a"
        static let maxRecordTime = 30.000
    }
    
    private var audioRecorder: AVAudioRecorder?
    
    private weak var delegate: RecordWorkerDelegate?
    
    init(with delegate: RecordWorkerDelegate) {
        super.init()
        
        self.delegate = delegate
        
        setupRecordingSession(.playAndRecord)
        
        AVAudioSession.sharedInstance().requestRecordPermission { allowed in }
    }
    
    func startRecording() {
        let dateString = Date().string(withFormat: Constants.dateFormat)
        let audioFileName = getDocumentsDirectory().appendingPathComponent(dateString + Constants.recordAudioFormat)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: Constants.sampleRate,
            AVNumberOfChannelsKey: Constants.numberOfChannels,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        setupRecordingSession(.playAndRecord)
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record(forDuration: Constants.maxRecordTime)
        } catch {
            print("RecordWorker Error: ", error)
        }
    }
    
    func finishRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    //MARK: - Private
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension RecordWorker: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let recordURL = recorder.url
        let record = Record(path: recordURL)
        
        delegate?.recorder(recorder, didFinisfRecording: record)
    }
}
