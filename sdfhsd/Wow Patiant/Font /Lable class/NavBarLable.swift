
//
//  NavBarLable.swift
//  Wow Patient
//
//  Created by Amir on 13/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

// An UILabel subclass allowing you to automatize the process of adjusting the font size.
//@IBDesignable
open class NavBarLable: UILabel {
    
    // MARK: Properties
    
//    /// If true, the font size will be adjusted each time that the text or the frame change.
//    @IBInspectable public var autoAdjustFontSize: Bool = true
//    
//    /// The biggest font size to use during drawing. The default value is the current font size
//    @IBInspectable public var maxFontSize: CGFloat = CGFloat.nan
//    
//    /// The scale factor that determines the smallest font size to use during drawing. The default value is 0.1
//    @IBInspectable public var minFontScale: CGFloat = CGFloat.nan
    
    /// UIEdgeInset
//    @IBInspectable public var leftInset: CGFloat = 0
//    @IBInspectable public var rightInset: CGFloat = 0
//    @IBInspectable public var topInset: CGFloat = 0
//    @IBInspectable public var bottomInset: CGFloat = 0
    
    
    @IBInspectable var fontSizee : CGFloat = 8.0
    @IBInspectable var fontNameee : String = "Montserrat-Regular"

    
    // MARK: Properties override
    
//    open override var text: String? {
//        didSet {
//          
//        }
//    }
//    
//    open override var frame: CGRect {
//        didSet {
//           
//        }
//    }
    
    // MARK: Private
    
    var isUpdatingFromIB = false
    
    // MARK: Life cycle
    
    open override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        self.textColor = UIColor.blue
        //self.setUp()
    }
    
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        self.setUp()
        //isUpdatingFromIB = autoAdjustFontSize
        //self.textColor = UIColor.black
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
       self.setUp()

        }
    
    func setUp()
    {
//         let labletext = NSMutableAttributedString(attributedString: self.attributedText!)
//        labletext.addAttribute(NSAttributedStringKey.font, value: UIFont(name: self.fontNameee,size: self.fontSizee)!, range: NSMakeRange(0, labletext.length))
//        self.attributedText = labletext
        
        //self.font = UIFont(name: self.fontNameee, size: self.fontSizee)
        
        self.font = UIFont(name: "Montserrat-Regular", size: 18.0)

        self.textColor = UIColor.black
    }
    
    // MARK: Insets
    
//    open override func drawText(in rect: CGRect) {
//        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//    }
    
}

// MARK: Helpers




