//
//  ImportViewController.swift
//  Demo0118
//
//  Created by T.Trang on 19/01/2024.
//

import UIKit
import Photos

class ImportViewController: BaseViewController {
    var videosImport = [VideoImportModel]()
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var percentView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var loadingPercentLbl: UILabel!
    
    @IBOutlet private var cancelBtn: UIButton!
    
    private var ANALYZING_TEXT = "Analyzing..."
    
    private var isImportVideo = false
    private var videosPickedCount = 0
    private var videoLocalId : String? = nil // video id save in photo lib
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !videosImport.isEmpty {
            self.videosPickedCount = videosImport.count
            
            if let video = self.videosImport.first {
                self.videosImport.remove(at: 0)
                self.checkVideoBeforeAnalysis(vc: self, video: video)
            }
        } else {
            loadingView.isHidden = true
            percentView.isHidden = true
            cancelBtn.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showVideoPicker()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTopHeader(backgroundColor: UIColor.clear, statusBarColor: UIColor.clear)
    }
}

// Actions
extension ImportViewController {
    @IBAction private func cancelImport(_ sender: Any) {
        loadingView.isHidden = true
        percentView.isHidden = true
        
        showAlertConfirm(vc: self, title: "Cancel", message: "Cancel analysis video", completion: { isOk in
            if isOk {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.loadingView.isHidden = false
                self.percentView.isHidden = false
            }
        })
    }
}

// MARK: Video Picker Controller
extension ImportViewController {
    
    private func showVideoPicker() {
        let stb = UIStoryboard(name: "VideoPicker", bundle: nil)
        let picker = stb.instantiateViewController(withIdentifier: "VideoPickerViewController") as! VideoPickerViewController
        picker.modalPresentationStyle = .formSheet
        picker.videoSelected = { videos in
            self.videosImport = videos.reversed()
            self.videosPickedCount = videos.count
            print("num of selected video: \(videos.count)")
            self.videoSelected(picker: picker, videos: videos)
        }
        picker.cancelClick = {
            self.keyWindow?.rootViewController?.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
    private func videoSelected(picker: UIViewController, videos: [VideoImportModel]) {
        if videosImport.isEmpty {
            self.keyWindow?.rootViewController?.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
            return
        }
        
        self.showAlertConfirm(vc: picker, title: "Import video", message: "Do you want to import this video?") {
            isSelect in
            if isSelect {
                self.cancelBtn.isHidden = false
                if let video = self.videosImport.first {
                    self.videosImport.remove(at: 0)
                    self.checkVideoBeforeAnalysis(vc: picker, video: video)
                }
            }
        }
    }
    
    private func checkVideoBeforeAnalysis(vc: UIViewController, video: VideoImportModel) {
        print("check video before analysis")
        guard let phAsset = video.phAsset else {
            self.showAlertError(vc: vc, title: "Error", message: "Could not import video")
            return
        }
        
        let currentVideoIndex = videosPickedCount - videosImport.count
        ANALYZING_TEXT = " Analyzing (\(currentVideoIndex)/\(videosPickedCount) videos)"
        
        self.loadingView(percent: "", text: self.ANALYZING_TEXT, isHidden: false)
        
        self.requestAVAsset(vc: vc, phAsset: phAsset)
    }
    
    private func requestAVAsset(vc: UIViewController, phAsset: PHAsset) {
        print("request AVAsset")
        DispatchQueue.main.async(execute: {
            if vc is VideoPickerViewController {
                vc.dismiss(animated: true, completion: nil)
            }
        })
        
        let videoOptions = PHVideoRequestOptions()
        videoOptions.version = PHVideoRequestOptionsVersion.original
        videoOptions.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: videoOptions, resultHandler: { (asset, audioMix, info) -> Void in
            if let asset = asset as? AVURLAsset {
                self.isImportVideo = true
                self.videoLocalId = phAsset.localIdentifier
                _ = self.exportVideo(url: asset.url)
            } else {
                self.showAlertError(vc: vc, title: "Error", message: "Could not import video.")
            }
        })
    }
}

// MARK: Video
extension ImportViewController {
    private func exportVideo(url: URL) -> URL? {
        print("export video")
        
        return url
    }
}

// MARK: Alert
extension ImportViewController {
    private func showAlertConfirm(vc: UIViewController, title: String, message: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default, 
                                         handler: { action in
                completion(false)}
            )
            
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, 
                                          handler:{ action in
                completion(true)}
            )
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            
            DispatchQueue.main.async(execute: {
                vc.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    private func showAlertError(vc: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                self.keyWindow?.rootViewController?.dismiss(animated: true) {
                    self.dismiss(animated: true)
                }
            }))
            
            vc.present(alert, animated: true)
        }
    }
}

// MARK: Class functions
extension ImportViewController {
    private func loadingView(percent: String, text: String, isHidden: Bool) {
        DispatchQueue.main.async { [self] in
            loadingView.isHidden = isHidden
            percentView.isHidden = isHidden
            loadingLbl.text = text
            if(percent.count > 1) {
                let progressText = NSMutableAttributedString.init(string: percent)
                progressText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)], range: NSMakeRange(percent.count - 1, 1))
                loadingPercentLbl.attributedText = progressText
            } else {
                loadingPercentLbl.text = percent
            }
        }
    }
}
