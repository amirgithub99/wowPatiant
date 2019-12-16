//
//  NavigationBarView.swift
//  Wow Patient
//
//  Created by Amir on 17/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
//@IBDesignable
class NavigationBarView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //151,63
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
        self.backgroundColor = UIColor(red:0.40, green:0.00, blue:0.40, alpha:1.0)
        let logoImgView = UIImageView()
        let logoWidth = 136
        let logoHeight = 54
        let xPostion = Int(self.bounds.size.width) - logoWidth
        logoImgView.image = UIImage(named: "waterMarklogo")
        logoImgView.frame = CGRect(x: xPostion, y: 2, width: logoWidth, height: logoHeight)
        self.addSubview(logoImgView)
    }
    

}
