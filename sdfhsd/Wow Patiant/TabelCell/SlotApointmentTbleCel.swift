//
//  SlotApointmentTbleCel.swift
//  Wow Patient
//
//  Created by Amir on 12/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

class SlotApointmentTbleCel: UITableViewCell {

    @IBOutlet weak var availableLbl : UILabel!
    @IBOutlet weak var startEndTimeLbl: DetailMediumLable!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

} // end class
