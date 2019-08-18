//
//  Track.swift
//  URLHomeWorkWithAnimation
//
//  Created by Сергей Косилов on 17.08.2019.
//  Copyright © 2019 Сергей Косилов. All rights reserved.
//

import Foundation

class Track {
    //
    // MARK: - Constants
    //
    let artist: String
    let index: Int
    let name: String
    let previewURL: URL
    
    //
    // MARK: - Variables And Properties
    //
    var downloaded = false
    
    //
    // MARK: - Initialization
    //
    init(name: String, artist: String, previewURL: URL, index: Int) {
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
    }
}
