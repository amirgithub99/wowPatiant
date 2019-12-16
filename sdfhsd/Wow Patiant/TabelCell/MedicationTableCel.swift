//
//  MedicationTableCel.swift
//  Wow Patient
//
//  Created by Amir on 23/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

protocol RemoveMedicationDelegate : class{

    func removeSelectedMedication(selectedCell : MedicationTableCel)
    
}

class MedicationTableCel: UITableViewCell {

    @IBOutlet weak var medicineName : UILabel!
    @IBOutlet weak var medicationDeleteBtn : UIButton!
     @IBOutlet weak var frequencyLable: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    weak var medicationDelegate : RemoveMedicationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    // MARK: - Remove Selected Mediaction
    @IBAction func removeSelectedMedication(_ sender: Any)
    {
        if (self.medicationDelegate != nil)
        {
            self.medicationDelegate?.removeSelectedMedication(selectedCell: self)
        }
    }
}// end class
