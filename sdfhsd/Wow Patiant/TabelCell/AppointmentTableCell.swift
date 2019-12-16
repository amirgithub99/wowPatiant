//
//  AppointmentTableCell.swift
//  Wow Patient
//
//  Created by Amir on 04/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

protocol SelectedAppointmentDelegate : class
{
    func getSelecteAppointmentInfoFromSelectedTableViewCell(SelectedCell : AppointmentTableCell)
}
class AppointmentTableCell: UITableViewCell {

    
    @IBOutlet weak var doctorImage : UIImageView!
    @IBOutlet weak var doctorName : UILabel!
    @IBOutlet weak var appointmentDate : UILabel!
    @IBOutlet weak var appointmentTime : UILabel!
    @IBOutlet weak var appointmentTypeImg : UIImageView!
    weak var appointmentDelagte : SelectedAppointmentDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /*  Slected Appintment Delagate*/
    @IBAction func goToSelectedAppointmentDetailViewController(_ sender: Any)
    {
        if (self.appointmentDelagte != nil)
        {
            self.appointmentDelagte?.getSelecteAppointmentInfoFromSelectedTableViewCell(SelectedCell: self)
        }
    }

} // end class
