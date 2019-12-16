//
//  MedicalCondtionTbleCel.swift
//  Wow Patiant
//
//  Created by Amir on 27/05/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

//import UIKit
//
//class MedicalCondtionTbleCel: UITableViewCell {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}

import UIKit

protocol RemoveDiseaseDelegate : class
{
    func removeSelectedDisease(selectedCell : MedicalCondtionTbleCel)
}
class MedicalCondtionTbleCel: UITableViewCell {
    
    
    @IBOutlet weak var diseaseNameLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var medicalCondtionRemoveBtn : UIButton!
    
    weak var diseaseDelegate : RemoveDiseaseDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func removeSelectedDisease(_ sender: Any)
    {
        if (self.diseaseDelegate != nil)
        {
            self.diseaseDelegate?.removeSelectedDisease(selectedCell: self)
        }
        
    }
    
} // end class
