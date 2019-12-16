//
//  CustomImageRoundClass.swift
//  Wow Patient
//
//  Created by Amir on 04/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
@IBDesignable
class CustomImageRoundClass: UIImageView {
    
    @IBInspectable var imageCornerRadius : CGFloat = 0.0 {
    didSet{
    
        self.clipsToBounds = true
         self.layer.cornerRadius = imageCornerRadius
        self.layer.masksToBounds = imageCornerRadius > 0
      }
    }
    
    @IBInspectable var imageBorderWidth : CGFloat = 0.0 {
        didSet{
        self.layer.borderWidth = imageBorderWidth
        
        }
    }
    
    @IBInspectable var colorBorder : UIColor = UIColor.white
        {
    
        didSet{
        
        
            self.layer.borderColor = UIColor.white.cgColor
        }
    
    }
 
    

} // end class
