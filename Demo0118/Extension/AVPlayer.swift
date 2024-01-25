//
//  AVPlayer.swift
//  Demo0118
//
//  Created by Tung on 18/01/2024.
//

import Foundation
import AVKit

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
