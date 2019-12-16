//
//  AllergyTableCell.swift
//  Wow Patient
//
//  Created by Amir on 23/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

protocol RemoveAllergyDelagate : class
{
    func removeSelectedAllergy(selectedCell : AllergyTableCell)
}
class AllergyTableCell: UITableViewCell {

    @IBOutlet weak var allergyName : UILabel!
    @IBOutlet weak var deleteAllergyBtn : UIButton!

    weak var allergyDelegate : RemoveAllergyDelagate?
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func removeSelectedAllergies(_ sender: Any)
    {
        if (self.allergyDelegate != nil)
        {
            self.allergyDelegate?.removeSelectedAllergy(selectedCell: self)
        }
    }
} // end class
