//
//  RecordTableViewCell.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RecordTableViewCell: UITableViewCell {

    private struct Constants {
        static let edgeOffset: CGFloat = 16
    }
    
    private var disposeBug = DisposeBag()
    
    private var record: Record?
    
    private var progressView: UIView!
    private var playButton: UIButton!
    private var titleLabel: UILabel!
    private var durationLabel: UILabel!
    
    var playButtonAction: ((Record?) -> ())?
    
    func configure(with model: Record) {
        setupSubviews()
        
        record = model
        
        titleLabel.text = model.name
        durationLabel.text = model.durationString
        
        let icon: UIImage
        
        switch model.state {
        case .default, .paused:
            icon = #imageLiteral(resourceName: "ic_play")
        case .playing:
            icon = #imageLiteral(resourceName: "ic_pause")
        }
        
        playButton.setImage(icon, for: .normal)
        
        if model.state == .default {
            progressView?.isHidden = true
        } else {
            progressView?.isHidden = false
            
            let progressWidth: CGFloat = 100.0//bounds.width / CGFloat(model.precent)
            
            progressView?.frame.size = CGSize(width: progressWidth, height: bounds.height)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        progressView?.isHidden = true
    }
    
    func setupSubviews() {
        accessoryType = .disclosureIndicator
        
        addProgressView()
        addPlayButton()
        addTitleLabel()
        addDurationLabel()
        
        subscribeToButtonAction()
        
        bringSubviewToFront(contentView)
    }
    
    //MARK: - Private
    
    private func addProgressView() {
        guard progressView == nil else { return }
        
        progressView = UIView(frame: .zero)
        
        progressView.frame.size = CGSize(width: 0, height: bounds.height)
        progressView.isHidden = true
        progressView.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        progressView.alpha = 0.5
        
        addSubview(progressView)
    }
    
    private func addPlayButton() {
        guard playButton == nil else { return }
        
        playButton = UIButton(type: .system)
        
        playButton.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        contentView.addSubview(playButton)
        
        playButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(Constants.edgeOffset)
            maker.size.equalTo(35)
        }
    }
    
    private func addTitleLabel() {
        guard titleLabel == nil else { return }
        
        titleLabel = UILabel()
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(playButton.snp.trailing).offset(Constants.edgeOffset)
        }
    }
    
    private func addDurationLabel() {
        guard durationLabel == nil else { return }
        
        durationLabel = UILabel()
        
        durationLabel.textColor = .lightGray
        durationLabel.textAlignment = .right
        durationLabel.font = UIFont.systemFont(ofSize: 13)
        
        contentView.addSubview(durationLabel)
        
        durationLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.lessThanOrEqualTo(titleLabel.snp.trailing).offset(Constants.edgeOffset)
            maker.trailing.equalToSuperview().offset(-Constants.edgeOffset)
        }
    }
    
    private func subscribeToButtonAction() {
        playButton.rx
            .tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.playButtonAction?(self.record)
            }
            .disposed(by: disposeBug)
    }
}
