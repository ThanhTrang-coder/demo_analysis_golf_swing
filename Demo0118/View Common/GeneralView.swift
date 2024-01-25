//
//  GeneralView.swift
//  Demo0118
//
//  Created by T.Trang on 19/01/2024.
//

import UIKit

@IBDesignable
public class GeneralView: UIControl {
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            if self.cornerRadius > 0.0 {
                self.layer.cornerRadius = self.cornerRadius
            }
        }
    }
    
    @IBInspectable
    public var isRoundCircle: Bool = false {
        didSet {
            if self.isRoundCircle {
                self.layer.cornerRadius = self.bounds.size.width / 2
            }
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? = nil {
        didSet {
            guard let borderColor = borderColor else { return }
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
    }
}
