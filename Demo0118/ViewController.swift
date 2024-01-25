//
//  ViewController.swift
//  Demo0118
//
//  Created by T.Trang on 18/01/2024.
//

import UIKit
import AVKit
import ReplayKit
import Photos

class ViewController: BaseViewController {
    var url: String = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var importStackView: UIStackView!
    @IBOutlet weak var settingStackView: UIStackView!
    
    
    
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer? = nil
    
    private var screenRecorder = RPScreenRecorder.shared()
    
    private var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        settingLayout()
//        loadVideo()
    }
}
    
// MARK: Actions
extension ViewController {
    @IBAction func playPressed(_ sender: Any) {
        guard let player = player else { return }
        if (player.isPlaying) {
            player.pause()
            playOrPauseBtn.setTitle("Pause", for: .normal)
        } else {
            player.rate = 1
            playOrPauseBtn.setTitle("Play", for: .normal)
        }
    }
    
    @IBAction func recordPressed(_ sender: Any) {
        screenRecordingClick()
    }
    
    @objc func importClick() {
        requestPhotoPermission()
        print("import click")
    }
    
    @objc func settingClick() {
        toSettingVC()
        print("setting click")
    }
}
    
// MARK: Functions
extension ViewController {
    func settingLayout() {
//        tableView.layoutMargins = UIEdgeInsets.zero
//        tableView.separatorInset = UIEdgeInsets.zero
        
        importStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(importClick)))
        settingStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingClick)))
    }
    
    private func requestPhotoPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .limited:
                print("Permission limited.")
                DispatchQueue.main.async {
                    self.showImportVC(isPermissionLimited: true)
                }
                break;
            case .authorized:
                print("Permission authorized.")
                DispatchQueue.main.async {
                    self.showImportVC()
                }
                break
            case .denied:
                print("Permission Denied")
                DispatchQueue.main.async {
                    self.showAlertSettingAppPermission(title: "", message: "")
                }
                break
            case .restricted:
                print("Permission restricted.")
                DispatchQueue.main.async {
                    self.showAlertSettingAppPermission(title: "", message: "")
                }
                break
            case .notDetermined:
                print("Permission not determined.")
                PHPhotoLibrary.requestAuthorization({ status in
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async {
                            self.showImportVC()
                        }
                    } else {
                        print("Permission Denied.")
                    }
                })
                break
            default:
                break
            }
        }
    }
    
    private func showImportVC(isPermissionLimited: Bool = false) {
        let stb = UIStoryboard(name: "Import", bundle: nil)
        let importVC = stb.instantiateViewController(withIdentifier: "ImportViewController") as! ImportViewController
        importVC.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(importVC, animated: true)
        
        self.present(importVC, animated: false, completion: nil)
    }
    
    private func toSettingVC() {
        let stb = UIStoryboard(name: "Setting", bundle: nil)
        let settingVC = stb.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        settingVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(settingVC, animated: true)
        
//        self.present(importVC, animated: false, completion: nil)
    }
    
    func loadVideo() {
        if(player == nil) {
            guard var videoUrl = URL(string: url) else { return }
            let playerItem = AVPlayerItem(url: videoUrl)
            player = AVPlayer(playerItem: playerItem)
            playerLayer = AVPlayerLayer(player: player)
            playerView.layer.addSublayer(playerLayer!)
            playerLayer!.frame = playerView.bounds
        }
    }
    
    func screenRecordingClick() {
        if !isRecording {
            startScreenRecording()
        } else {
            stopScreenRecording()
        }
    }
    
    func startScreenRecording() {
        self.screenRecorder.startRecording { (error) in
            if let error = error as? NSError, let code = RPRecordingErrorCode(rawValue: error.code) {
                switch code {
                case .userDeclined: print("recording: User declined")
                default: print("recording: capture completion error: \(error)")
                }
                return
            }
            print("Start recording")
            self.isRecording = true
        }
    }
    
    func stopScreenRecording() {
        isRecording = false
        let recordUrl = URL(fileURLWithPath: NSTemporaryDirectory() + "\(UUID().uuidString).mov")
        
        self.screenRecorder.stopRecording(withOutput: recordUrl) { error in
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlertError(title: "", message: "There is an error", clickListener: {_ in })
                }
                return
            }
            print("Stop recording")
            self.player?.pause()
            self.saveRecordingToPhotos(url: recordUrl)
        }
    }
    
    func saveRecordingToPhotos(url: URL) {
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            request?.creationDate = Date()
        } completionHandler: { success, error in
            if success {
                print("Saved Successfully")
            } else {
                print("Failed to save")
            }
        }
    }
}
    
// MARK: Scroll view
extension ViewController {
    
}
    

    


