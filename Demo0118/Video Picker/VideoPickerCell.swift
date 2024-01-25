//
//  VideoPickerCell.swift
//  Demo0118
//
//  Created by Tung on 19/01/2024.
//

import UIKit

class VideoPickerCell: UICollectionViewCell {

    @IBOutlet private var selectedBoundView: UIView!
    
    @IBOutlet private var thumbnailImageView: UIImageView!
    
    @IBOutlet private var selectedIcon: UIImageView!
    
    @IBOutlet private var timeLbl: UILabel!

    var video: VideoImportModel? {
        didSet {
            if let video = video {
                thumbnailImageView.image = video.thumbnail
                timeLbl.text = video.duration
                
                thumbnailImageView.alpha = video.isSelected ? 0.7 : 1
                selectedIcon.isHidden = !video.isSelected
                timeLbl.isHidden = video.isSelected
                selectedBoundView.isHidden = !video.isSelected
            }
        }
    }
}
