//
//  UIUtilities.swift
//  Demo0118
//
//  Created by Tung on 25/01/2024.
//

import UIKit
import AVFoundation

public class UIUtilities {
//    public static func saveAnalyzingVideoStatus(status: AnalyzingStatus)
    
    public static func getAnalyzingVideoStatus() -> AnalyzingStatus {
        let statusString = UserDefaults.standard.value(forKey: "analyzing_video_status") as? String
        
        if(statusString != nil) {
            var status:
        }
    }
}
