//
//  SearchDoctorController.swift
//  Wow Patient
//
//  Created by Amir on 10/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

import Alamofire

class SearchDoctorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UISearchBarDelegate, SelectedDoctorDelegate, FilterDoctorDelegate {
    
    @IBOutlet weak var searchTableView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    var specialityName = String()
    var isSearcBarActive = Bool()
    var isTableReloadFirstTime = Bool()
    var isSearchByCariteria = Bool()
    
    var professionInfoArr = NSMutableArray()
    var searchFilterArr = NSMutableArray()
    var doctorInfoCriteriaArr = NSMutableArray()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        if self.isSearchByCariteria == true
//        {
//            self.showSelectedDoctorByCritiaInTableView()
//        }
//        else
//        {
            self.fetchListOfDoctorBySpecialites()
        //}
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func goBackToAppointmentViewController(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool)
    {

    }
    override func viewDidAppear(_ animated: Bool)
    {
    }
    // MARK: - Filter Doctor Delegate
    func getFilterDoctor(filterDoctors: NSMutableArray)
    {
        self.doctorInfoCriteriaArr = filterDoctors
        self.showSelectedDoctorByCritiaInTableView()
    }
    // MARK:- Selected Doctor Delegate
    func getSelectedDoctorFormList(selectedCell: ProfessionalSearchTableCel)
    {
        let selectedIndexPath = self.searchTableView.indexPath(for: selectedCell)
        var selectedProfessionaObj =  Professionalinfo()
        if self.isSearcBarActive
        {
            let professionInfoObj = self.searchFilterArr[(selectedIndexPath?.row)!] as! Professionalinfo
            selectedProfessionaObj = professionInfoObj
        }
        else
        {
            let professionInfoObj = self.professionInfoArr[(selectedIndexPath?.row)!] as! Professionalinfo
            selectedProfessionaObj = professionInfoObj
        }
        
        let goToDoctorDetailContrler = self.storyboard?.instantiateViewController(withIdentifier: "ProfessionDetailControler") as! ProfessionDetailControler
        goToDoctorDetailContrler.professionalObj = selectedProfessionaObj
        self.navigationController?.pushViewController(goToDoctorDetailContrler, animated: true)
    }
    // MARK: - Go To AppointmentFilterController
    @IBAction func goToAppointmentFilterController(_ sender: Any)
    {
        let goToAppointmentFilterControler = self.storyboard?.instantiateViewController(withIdentifier: "AppointmntFilterControler") as! AppointmntFilterControler
        goToAppointmentFilterControler.filterDoctorDelgate = self
        self.navigationController?.pushViewController(goToAppointmentFilterControler, animated: true)
    }
    func showSelectedDoctorByCritiaInTableView()
    {
        let fetchArr =  self.doctorInfoCriteriaArr
        Singleton.shareInstance.professionalInfo.professionAllInfoArr.removeAll()
        let professionAllInfoArr = NSMutableArray(capacity: fetchArr.count)
        for var i in 0..<fetchArr.count
        {
            let professionSpecialityInfoDict = fetchArr[i] as! NSDictionary
            let professionInfoDict = professionSpecialityInfoDict.value(forKey: "professionalInfo") as! NSDictionary
            let professionInfoObj : Professionalinfo = Professionalinfo.init(professionalInfoDict: professionInfoDict)
            let professionAddressArr = professionSpecialityInfoDict.value(forKey: "professionalAddresses") as! NSArray
            let professionAddresObj : ProfessionalAdresses =  ProfessionalAdresses.init(addressInfoArr: professionAddressArr)
            professionInfoObj.professionAddresss = professionAddresObj
            professionAllInfoArr.add(professionInfoObj)
            i += 1
        }
        
        Singleton.shareInstance.professionalInfo.professionAllInfoArr = professionAllInfoArr as! [Professionalinfo]
        self.professionInfoArr = professionAllInfoArr
        self.searchTableView.reloadData()
    } // end method
    
  
    // MARK: - Fetch List Of Doctor
    func fetchListOfDoctorBySpecialites()
    {
        
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
       // General Physician
       // let url = UrlUtil.getSpecialityUrlByName(name: "General Physician")
        let url = UrlUtil.getSpecialityUrlByName(name: self.specialityName)
        APIManager.getAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                
                let fetchArr = mainDictionary.value(forKey: "professionalsBySpeciality") as! NSArray
                let professionAllInfoArr = NSMutableArray(capacity: fetchArr.count)
                for var i in 0..<fetchArr.count
                {
                    
                    let professionSpecialityInfoDict = fetchArr[i] as! NSDictionary
                    let professionInfoDict = professionSpecialityInfoDict.value(forKey: "professionalInfo") as! NSDictionary
                    let professionInfoObj : Professionalinfo = Professionalinfo.init(professionalInfoDict: professionInfoDict)
                    let professionAddressArr = professionSpecialityInfoDict.value(forKey: "professionalAddresses") as! NSArray
                    let professionAddresObj : ProfessionalAdresses =  ProfessionalAdresses.init(addressInfoArr: professionAddressArr)
                    professionInfoObj.professionAddresss = professionAddresObj
                    professionAllInfoArr.add(professionInfoObj)
                    i += 1
                }
                Singleton.shareInstance.professionalInfo.professionAllInfoArr = professionAllInfoArr as! [Professionalinfo]
                
                self.professionInfoArr = (Singleton.shareInstance.professionalInfo.professionAllInfoArr as NSArray).mutableCopy() as! NSMutableArray
                
                //self.professionInfoArr = Singleton.shareInstance.professionalInfo.professionAllInfoArr as! NSMutableArray//professionAllInfoArr
                self.reloadSerachTableView()
            }
            else
            {
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
                // return allert
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No response received", message: "")
        }
        
    } // end Method
    
   
    func reloadSerachTableView()
    {
        if self.isTableReloadFirstTime == false
        {
            self.searchTableView.delegate = self
            self.searchTableView.dataSource = self
        }
        else
        {
            self.searchTableView.reloadData()
        }
        self.searchTableView.tableFooterView = UIView(frame: .zero)
    }
     // MARK: - Search Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        self.isSearcBarActive = true
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        self.isSearcBarActive = false
        self.searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.isSearcBarActive = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.isSearcBarActive = false
        self.searchTableView.reloadData()
    }
    public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar)
    {
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.showFilterDoctorName(searchtxt: searchText)
    }
    // MARK: - Show Filter Doctor Name
    func showFilterDoctorName(searchtxt : String)
    {
        self.isSearcBarActive = true
        self.searchFilterArr.removeAllObjects()
        if searchtxt.count == 0 {
            self.isSearcBarActive = false
            self.searchTableView.reloadData()
        }
        for var i in 0..<self.professionInfoArr.count
        {
            let professionAllInfo = self.professionInfoArr[i] as! Professionalinfo
            let  firstNameStr = professionAllInfo.firstName
            let  middleNameStr = professionAllInfo.middleName
            let  lastNameStr = professionAllInfo.lastName
            var  professionNameStr = firstNameStr?.appending(" ")
            professionNameStr = professionNameStr?.appending(middleNameStr!)
            professionNameStr = professionNameStr?.appending(" ")
            professionNameStr = professionNameStr?.appending(lastNameStr!)
            if (professionNameStr?.localizedCaseInsensitiveContains(searchtxt))!
            {
                self.searchFilterArr.add(professionAllInfo)
            }
            i += 1
        }
        self.searchTableView.reloadData()
        
    }// end function
    
    // MARK: - Table Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.isSearcBarActive == true
        {
            return self.searchFilterArr.count
        }
        else
        {
            return self.professionInfoArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let celll  = tableView.dequeueReusableCell(withIdentifier: "ProfessionalSearchTableCel") as! ProfessionalSearchTableCel
        var professionInfoObj = Professionalinfo()
        if self.isSearcBarActive == false
        {
            professionInfoObj = self.professionInfoArr[indexPath.row] as! Professionalinfo
        }
        else
        {
            professionInfoObj =  self.searchFilterArr[indexPath.row] as! Professionalinfo
        }
        let  firstNameStr = professionInfoObj.firstName
        let  middleNameStr = professionInfoObj.middleName
        let  lastNameStr = professionInfoObj.lastName
        var  professionNameStr = firstNameStr?.appending(" ")
        professionNameStr = professionNameStr?.appending(middleNameStr!)
        professionNameStr = professionNameStr?.appending(" ")
        professionNameStr = professionNameStr?.appending(lastNameStr!)
        celll.professionNameLbl.text = professionNameStr
        let isAudioAppointment = professionInfoObj.audio
        let isVideoAppointment = professionInfoObj.video
        let isPersonAppointment = professionInfoObj.inPerson

        let imageStr = professionInfoObj.logoPath
        let imageUrl = URL(string: imageStr!)
        if imageUrl == nil
        {
            DispatchQueue.main.async {
              celll.professionImage.image = UIImage(named: "doctorImg")
            }
        }
        else
        {
            celll.professionImage.sd_setImage(with: imageUrl, placeholderImage: nil, options: [.continueInBackground], completed: nil)
        }
        var noOfConditionTrue = 0
        DispatchQueue.main.async {
            if isAudioAppointment == true
            {
                noOfConditionTrue += 1
            }
            if isVideoAppointment == true
            {
                noOfConditionTrue += 1
            }
            if isPersonAppointment == true
            {
                noOfConditionTrue += 1
            }
            if noOfConditionTrue == 1
             {
                 if isAudioAppointment == true
                  {
                     celll.audioImagee.image = UIImage(named:"phoneImg")
                  }
                else if isVideoAppointment == true
                    {
                      celll.audioImagee.image = UIImage(named:"videoImg")
                    }
                else if isPersonAppointment == true
                    {
                     celll.audioImagee.image = UIImage(named:"personImg")
                    }
                    celll.inPersonImage.isHidden = true
                    celll.videoImagee.isHidden = true
             }
            else if noOfConditionTrue == 2
            {
                    if isAudioAppointment == true
                    {
                            celll.audioImagee.image = UIImage(named:"phoneImg")
                            if isVideoAppointment == true
                            {
                                celll.videoImagee.image = UIImage(named:"videoImg")
                            }
                            if isPersonAppointment == true
                            {
                                celll.videoImagee.image = UIImage(named:"personImg")
                            }
                            celll.inPersonImage.isHidden = true
                    }
                    else
                    {
                        celll.audioImagee.image = UIImage(named:"videoImg")
                        celll.videoImagee.image = UIImage(named:"personImg")
                        celll.inPersonImage.isHidden = true
                            
                     }
                    }
            else if noOfConditionTrue == 3
                {
                    celll.inPersonImage.isHidden = false
                    celll.audioImagee.isHidden = false
                    celll.videoImagee.isHidden = false
                    celll.inPersonImage.image = UIImage(named:"personImg")
                    celll.audioImagee.image = UIImage(named:"phoneImg")
                    celll.videoImagee.image = UIImage(named:"videoImg")
                 }
            
        
            let professionalAddressesArr = professionInfoObj.professionAddresss.professionalAdressArr
             var doctorClinicAddress : String?
            for var i in 0..<professionalAddressesArr.count
            {
            let professionalAddresses = professionalAddressesArr[i]
            //var doctorClinicAddress : String?
            if professionalAddresses.addressType == 3
            {
                let addressline1Str = professionalAddresses.addressLine1
                _  = professionalAddresses.addressLine2
                let countryName = professionalAddresses.countryName
                let stateName = professionalAddresses.stateName
                
                _ = professionalAddresses.zipCode
                var fullAddress = addressline1Str?.appending(" ")
                
             /* fullAddress = fullAddress?.appending(addressline2Str!)
                fullAddress = fullAddress?.appending(" ")*/

                fullAddress = fullAddress?.appending(countryName!)
                
                fullAddress = fullAddress?.appending(" ")
                fullAddress = fullAddress?.appending(stateName!)
                
                /*fullAddress = fullAddress?.appending(" ")
                fullAddress = fullAddress?.appending(zipCode!)*/
                doctorClinicAddress = fullAddress
                break
            }
            else
            {
                doctorClinicAddress = ""
            }
            //celll.addressTextView.textContainerInset = UIEdgeInsetsMake(2, 0, 2, 2)
            i += 1
            }
            celll.professionAddressLbl.text = doctorClinicAddress
            celll.professionAddressLbl.adjustsFontSizeToFitWidth = true
            //celll.addressTextView.endEditing(true)
            celll.setNeedsLayout()
            celll.setNeedsDisplay()
        }

        celll.doctorDelegate = self
        return celll
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70.0
    }
    
} // end class

