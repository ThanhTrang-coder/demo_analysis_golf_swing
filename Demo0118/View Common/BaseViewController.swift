//
//  BaseViewController.swift
//  Demo0118
//
//  Created by T.Trang on 18/01/2024.
//

import UIKit

class BaseViewController: UIViewController {
    var windowStatusBar: UIView = UIView(frame: UIApplication.shared.statusBarFrame)
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter{ $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    var indicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        windowStatusBar.tag = 102
        let subviewStatus = keyWindow?.rootViewController?.view.viewWithTag(102)
        if(subviewStatus == nil) {
            keyWindow?.rootViewController?.view.addSubview(windowStatusBar)
        } else {
            windowStatusBar = subviewStatus!
        }
        
        
        
        indicatorView = self.activityIndicator(style: .large, center: self.view.center)
        self.view.addSubview(indicatorView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
    }
    
    func setTopHeader(backgroundColor: UIColor, statusBarColor: UIColor) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.backgroundColor = backgroundColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        if #available(iOS 15.0, *) {
            navigationController?.navigationBar.tintColor = .tintColor
        }
        
        windowStatusBar.backgroundColor = statusBarColor
    }
    
    private func activityIndicator(style: UIActivityIndicatorView.Style = .large,
                                   frame: CGRect? = nil,
                                   center: CGPoint? = nil) -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        
        if let center = center {
            activityIndicatorView.center = center
        }
        
        return activityIndicatorView
    }
}
