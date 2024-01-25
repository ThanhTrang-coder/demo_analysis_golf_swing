//
//  VideoPickerViewController.swift
//  Demo0118
//
//  Created by T.Trang on 19/01/2024.
//

import UIKit
import Photos

class VideoPickerViewController: UIViewController {
    var videoSelected: (([VideoImportModel]) -> ())?
    var cancelClick: (() -> ())?
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var doneBtn: UIButton!
    
    private var videosPicker = [VideoImportModel]()
    private var videos = [VideoImportModel]()
    private var assetCollection: PHAssetCollection?
    private var imageManager = PHCachingImageManager()
    private var indicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetup()
        self.loadVideosFromDevice()
        
        
    }
}

// MARK: Actions
extension VideoPickerViewController {
    @IBAction private func cancelClick(_ sender: Any) {
        cancelClick?()
    }
    
    @IBAction private func doneClick(_ sender: Any) {
        let videos = videosPicker.filter{ video in
            return video.isSelected
        }
        videoSelected?(videos)
    }
}

// MARK: Collection View
extension VideoPickerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIColorPickerViewControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videosPicker.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoPickerCell", for: indexPath) as! VideoPickerCell
        cell.video = videosPicker[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videosPicker[indexPath.row]
        
        video.isSelected = !video.isSelected
        collectionView.reloadData()
        let videosSelected = videosPicker.filter({ $0.isSelected })
        doneBtn.isEnabled = !videosSelected.isEmpty
    }
}

// MARK: Video data
extension VideoPickerViewController {
    private func loadVideosFromDevice() {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        let fetchResult = PHAsset.fetchAssets(with: .video, options: options)
        
        let imageOptions = PHImageRequestOptions()
        imageOptions.isSynchronous = true
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isNetworkAccessAllowed = true
        imageOptions.resizeMode = .exact
        
        for index in 0...fetchResult.count - 1 {
            let phAsset = fetchResult.object(at: index)
            let video = VideoImportModel()
            video.phAsset = phAsset
            video.duration = getDurationString(duration: Int(phAsset.duration.rounded()))
            
            imageManager.requestImage(for: phAsset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: imageOptions) { (image, info) -> Void in
                video.thumbnail = image
            }
            
            videosPicker.append(video)
        }
    }
}

// MARK: UI Setting
extension VideoPickerViewController {
    private func collectionViewSetup() {
        collectionView.register(UINib(nibName: "VideoPickerCell", bundle: nil), forCellWithReuseIdentifier: "VideoPickerCell")
        
        let width = (view.frame.size.width - 8) / 3
        let size = CGSize(width: width, height: width)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = size
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
    }
}

// MARK: Class functions
extension VideoPickerViewController {
    func getDurationString(duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        
        let secondsStr = seconds > 0 && seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        return "\(minutes):\(secondsStr)"
    }
}

class VideoImportModel {
    var id = UUID().uuidString
    var phAsset: PHAsset?
    var thumbnail: UIImage?
    var duration: String = ""
    var isSelected: Bool = false
    var createDateTime = ""
}
