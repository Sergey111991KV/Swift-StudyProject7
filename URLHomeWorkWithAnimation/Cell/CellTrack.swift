//
//  CellTrack.swift
//  URLHomeWorkWithAnimation
//
//  Created by Сергей Косилов on 17.08.2019.
//  Copyright © 2019 Сергей Косилов. All rights reserved.
//


protocol TrackCellDelegate {
    func cancelTapped(_ cell: CellTrack)
    func downloadTapped(_ cell: CellTrack)
    func pauseTapped(_ cell: CellTrack)
    func resumeTapped(_ cell: CellTrack)
}



import UIKit

class CellTrack: UITableViewCell {

    
     var delegate: TrackCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressViewDownload: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    
    @IBAction func stopButton(_ sender: UIButton) {
        delegate?.cancelTapped(self)
    }
    
    @IBAction func downloadButton(_ sender: UIButton) {
        delegate?.downloadTapped(self)
    }
    
    
    @IBAction func pauseOrPlay(_ sender: Any) {
        if(playButton.titleLabel?.text == "II") {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
        
    }
    
    func configureCell(track: Track){
        artistLabel.text = track.artist
        nameLabel.text = track.name
    }
    
}
