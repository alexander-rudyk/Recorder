//
//  PlayerWorker.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa

protocol PlayerWorkerDelegate: class {
    func record(_ record: Record?, stateDidChange state: RecordState)
    func record(_ record:Record?, playingTime: Double)
}

class PlayerWorker: NSObject, IRecorder {
    
    private var player: AVAudioPlayer? {
        didSet {
            guard player != nil else { return }
            
            subscribeToPlayer()
        }
    }
    private var timer: Timer?
    
    private var playingRecord: Record?
    
    weak var delegate: PlayerWorkerDelegate?
    
    override init() {
        super.init()
        
        setupRecordingSession(.playback)
    }
    
    func play(record: Record) {
        
        setupRecordingSession(.playback)
        
        if player != nil {
            if playingRecord == record {
                delegate?.record(playingRecord, stateDidChange: .playing)
                subscribeToPlayer()
                player?.play()
                return
            } else {
                delegate?.record(playingRecord, stateDidChange: .default)
                unsubscribeToPlayer()
                player?.stop()
                playingRecord = record
            }
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: record.path, fileTypeHint: AVFileType.m4a.rawValue)
            player?.delegate = self
            
            delegate?.record(playingRecord, stateDidChange: .playing)
            
            player?.play()
        } catch {
            print(error)
        }
    }
    
    func pause() {
        delegate?.record(playingRecord, stateDidChange: .paused)
        unsubscribeToPlayer()
        player?.pause()
    }
    
    func stop() {
        delegate?.record(playingRecord, stateDidChange: .default)
        unsubscribeToPlayer()
        player?.stop()
        player = nil
    }
    
    //MARK: - Private
    
    private func subscribeToPlayer() {
        unsubscribeToPlayer()

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self = self,
                let player = self.player else {

                    timer.invalidate()
                    return
            }

            self.delegate?.record(self.playingRecord, playingTime: player.currentTime)
        }
    }
    
    private func unsubscribeToPlayer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}

extension PlayerWorker: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.record(playingRecord, stateDidChange: .default)
        
        self.player = nil
    }
}
