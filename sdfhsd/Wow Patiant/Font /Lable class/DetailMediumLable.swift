//
//  DetailMediumLable.swift
//  Wow Patient
//
//  Created by Amir on 13/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//



/*  DetailMediumLable class is used for table large and bold Lable */



import UIKit

// An UILabel subclass allowing you to automatize the process of adjusting the font size.
//@IBDesignable
open class DetailMediumLable: UILabel {
  
//    @IBInspectable var fontSizee : CGFloat = 12.5
//    @IBInspectable var fontNameee : String = "Montserrat-Medium"
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
    func setUp()
    {
//        let labletext = NSMutableAttributedString(attributedString: self.attributedText!)
//        labletext.addAttribute(NSAttributedStringKey.font, value: UIFont(name: self.fontNameee,size: self.fontSizee)!, range: NSMakeRange(0, labletext.length))
        //self.attributedText = labletext
        self.textColor = UIColor.black
        
        //self.font = UIFont(name: fontNameee, size: fontSizee)
        
        self.font = UIFont(name: "Montserrat-Medium", size: 12.5)

    }
    
  
}





