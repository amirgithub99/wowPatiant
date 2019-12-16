//
//  TextViewFont.swift
//  Wow Patient
//
//  Created by Amir on 16/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
//@IBDesignable
class TextViewFont: UITextView {
    
    @IBInspectable var fontSizee : CGFloat = 12.5
    @IBInspectable var fontFamily : String = "Montserrat-Light"
    
    override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
     //   self.setUp()
    }
    override func awakeFromNib()
    {
       super.awakeFromNib()
        self.setUp()
    }
   func setUp()
    {
        self.font = UIFont(name: self.fontFamily, size: self.fontSizee)
        self.textColor = UIColor.black
    }
    

}
