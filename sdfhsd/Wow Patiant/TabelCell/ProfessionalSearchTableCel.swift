//
//  ProfessionalSearchTableCel.swift
//  Wow Patiant
//
//  Created by Amir on 06/05/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

protocol SelectedDoctorDelegate : class
{
    func getSelectedDoctorFormList(selectedCell : ProfessionalSearchTableCel)
}


class ProfessionalSearchTableCel: UITableViewCell {
    
    @IBOutlet weak var professionImage : UIImageView!
    @IBOutlet weak var professionNameLbl : UILabel!
    
    @IBOutlet weak var professionAddressLbl : UILabel!

    
   // @IBOutlet weak var addressTextView : UITextView!
    @IBOutlet weak var inPersonImage : UIImageView!
    @IBOutlet weak var audioImagee : UIImageView!
    @IBOutlet weak var videoImagee : UIImageView!
    @IBOutlet weak var videoImgLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var audioImgLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var audioWidthConstraint: NSLayoutConstraint!

    weak var doctorDelegate : SelectedDoctorDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func goToSelectedDoctorDetailViewController(_ sender: Any)
    {
        if (self.doctorDelegate != nil)
        {
            self.doctorDelegate?.getSelectedDoctorFormList(selectedCell: self)
        }
     }
    
} // end class
