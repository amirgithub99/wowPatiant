//
//  TextFieldFont.swift
//  Wow Patient
//
//  Created by Amir on 16/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

/*  TextFieldFont class is used for  small and unbold textField Text */
//@IBDesignable
class TextFieldFont: UITextField {
    
    @IBInspectable var fontSizee : CGFloat = 11.0
    @IBInspectable var fontFamily : String = "Montserrat-Light"
    
    override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        //self.setUp()
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.setUp()
    }
    func setUp()
    {
      self.font = UIFont(name: self.fontFamily, size: self.fontSizee)
        self.textColor = UIColor.orange
        
        let placeHolderColor = UIColor.gray
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes:[NSAttributedStringKey.foregroundColor : placeHolderColor])
        self.textColor = UIColor.black
    }
}
