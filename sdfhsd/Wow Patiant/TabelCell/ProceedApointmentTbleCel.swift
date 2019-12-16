//
//  ProceedApointmentTbleCel.swift
//  Wow Patient
//
//  Created by Amir on 21/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit


protocol ProceedSelectedCellDelegate : class {
    
    func removeSelectedCellProceedInfo(selectedCell : ProceedApointmentTbleCel)
    
}

class ProceedApointmentTbleCel: UITableViewCell {
    
    @IBOutlet weak var serviceName : UILabel!
    @IBOutlet weak var servisAmount : UILabel!
    @IBOutlet weak var removeBtn : UIButton!
    weak var selectedBtnDelegate : ProceedSelectedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func showSelectedBtn(_ sender: Any)
    {
        if (self.selectedBtnDelegate != nil)
        {
           self.selectedBtnDelegate?.removeSelectedCellProceedInfo(selectedCell: self)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
} // end class
