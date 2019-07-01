//
//  HomeInteractor.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/29/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import AVFoundation

enum HomeInteractorError: String, Error {
    case failedLoadRecords = "Failed to capture records. Please try again later."
}

class HomeInteractor {
    
    private var dataRepository: HomeDataRepository
    
    private weak var controller: HomeDisplayLogic?
    
    init(with controller: HomeDisplayLogic) {
        self.controller = controller
        
        dataRepository = HomeDataRepository()
        dataRepository.delegate = self
    }
    
    //MARK: - File
    
    var fileWorker: FileWorker?
    
    func fetchRecords() {
        guard let records = fileWorker?.fetchRecords() else {
            controller?.showError(message: HomeInteractorError.failedLoadRecords.rawValue)
            return
        }
        
        dataRepository.set(data: records)
    }
    
    func remove(record: Record) {
        fileWorker?.remove(record)
        dataRepository.remove(record: record)
    }
    
    //MARK: - Record
    
    var recordsWorker: RecordWorker!
    
    func startRecording() {
        recordsWorker?.startRecording()
    }
    
    func finishRecording() {
        recordsWorker?.finishRecording()
    }
    
    var isRecording: Bool {
        return recordsWorker?.isRecording ?? false
    }
    
    //MARK: - Player
    
    var playerWorker: PlayerWorker? {
        didSet { playerWorker?.delegate = self }
    }
    
    func play(record: Record) {
        playerWorker?.play(record: record)
    }
    
    func pause() {
        playerWorker?.pause()
    }
    
    func stop() {
        playerWorker?.stop()
    }
    
    func selected(_ record: Record) {
        switch record.state {
        case .default, .paused:
            play(record: record)
        case .playing:
            pause()
        }
    }
}

extension HomeInteractor: HomeDataRepositoryDelegate {
    func dataChanged(_ newData: [Record]) {
        controller?.showItems(records: newData)
    }
}

extension HomeInteractor: RecordWorkerDelegate {
    func recorder(_ recorder: AVAudioRecorder, didFinisfRecording record: Record) {
        dataRepository.add(record: record)
    }
}

extension HomeInteractor: PlayerWorkerDelegate {
    func record(_ record: Record?, playingTime: Double) {
//        guard var record = record else { return }
//
//        record.currentTime = Float(playingTime)
//
//        dataRepository.update(record)
        print(playingTime)
    }
    
    func record(_ record: Record?, stateDidChange state: RecordState) {
        guard var record = record else { return }
        
        record.state = state
        
        dataRepository.update(record)
    }
}
