//
//  DetailBoldLable.swift
//  Wow Patient
//
//  Created by Amir on 16/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

class DetailBoldLable: UILabel {

    @IBInspectable var fontSize :  CGFloat = 12.5
    @IBInspectable var fontFamily : String = "Montserrat-SemiBold"
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let lableText = NSMutableAttributedString(attributedString: self.attributedText!)
        lableText.addAttribute(NSAttributedStringKey.font, value: UIFont(name : self.fontFamily, size : self.fontSize)!, range: NSMakeRange(0, lableText.length))
        self.attributedText = lableText
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
