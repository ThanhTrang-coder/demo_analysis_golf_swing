//
//  UIViewControllerExtension.swift
//  Demo0118
//
//  Created by Tung on 19/01/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertSettingAppPermission(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertConfirm(title: String, message: String, clickListener: @escaping ((Bool) -> ())) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let denyAction = UIAlertAction(title: "No", style: .default, handler: { _ in
            clickListener(false)
        })
        
        alert.addAction(denyAction)
        
        let settingAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in
            clickListener(true)
        })
        
        alert.addAction(settingAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertError(title: String, message: String, clickListener: @escaping((Bool) -> ())) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let settingsAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            clickListener(true)
        })
        alert.addAction(settingsAction)
        self.present(alert, animated: true, completion: nil)
    }
}
