//
//  DetailLightLable.swift
//  Wow Patient
//
//  Created by Amir on 16/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//






import UIKit

// An UILabel subclass allowing you to automatize the process of adjusting the font size.
//@IBDesignable
open class DetailLightLable: UILabel {
    
    
//
//    @IBInspectable var fontSizee : CGFloat = 12.5
//    @IBInspectable var fontfamily : String = "Montserrat-Light"
    
    
    open override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
      // self.setUp()
    }
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        self.setUp()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
//    func setUp()
//    {
//        let labletext = NSMutableAttributedString(attributedString: self.attributedText!)
//        labletext.addAttribute(NSAttributedStringKey.font, value: UIFont(name: self.fontfamily,size: self.fontSizee)!, range: NSMakeRange(0, labletext.length))
//        self.attributedText = labletext
//        self.textColor = UIColor.blue
//    }
//
    
    func setUp()
    {
//        let labletext = NSMutableAttributedString(attributedString: self.attributedText!)
//        labletext.addAttribute(NSAttributedStringKey.font, value: UIFont(name: self.fontfamily,size: self.fontSizee)!, range: NSMakeRange(0, labletext.length))
//        self.attributedText = labletext
        self.textColor = UIColor.black
        
        
        
        
        
        
        self.textColor = UIColor.black
        //self.font = UIFont(name: fontfamily, size: fontSizee)
        
        self.font = UIFont(name: "Montserrat-Light", size: 12.5)
        
        
        
    }
    
}





