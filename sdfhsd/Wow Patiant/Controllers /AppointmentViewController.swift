//
//  AppointmentViewController.swift
//  Wow Patient
//
//  Created by Amir on 04/04/2018.
//  Copyright © 2018 Amir. All rights reserved.

import UIKit
import Alamofire
import SDWebImage


class AppointmentViewController: UIViewController , UITableViewDelegate, UITableViewDataSource , UIAlertViewDelegate,UIGestureRecognizerDelegate, SelectedAppointmentDelegate {
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var appointmentTableView : UITableView!
    @IBOutlet weak var specialityTableView : UITableView!
    
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var specilityTextFieldView: UIView!
    @IBOutlet weak var addAppointmentTableView: UIView!
    @IBOutlet weak var scrollView : UIScrollView!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var selectSpecialityLbl: UILabel!

    var specialitySelectedStr = String()
    var appointmentInfoArr : NSMutableArray? //= NSMutableArray()
    var specialityInfoArr = [Specialities]()
    var isTableReloadFirstTime = Bool()
    var isSpecilityTableloadFirstTime = Bool()
    var isSpecialityCellSelected = Bool()
    var isSpecialityTableViewIsShowing = Bool()
    var isViewAppearFirstTime = Bool()
    @IBOutlet weak var specialityDoneView: UIView!
    @IBOutlet weak var specialityDoneBotomConstraint: NSLayoutConstraint!
    //  MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if isViewAppearFirstTime == false
        {
            self.appointmentTableView.delegate = self
            self.appointmentTableView.dataSource = self
            self.fetchAllAppointmentInfo()
            self.fetchAllSpecialitiesInfo()
             isViewAppearFirstTime = true
        }
        else
        {
            self.appointmentTableView.reloadData()
            self.scrollView.alpha = 0
            self.addAppointmentTableView.alpha = 0
            self.selectSpecialityLbl.text = "Select Speciality"
            self.specialitySelectedStr = ""
            self.segmentControl.selectedSegmentIndex = 0
            self.segmentControl.sendActions(for: UIControlEvents.valueChanged)
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
      //  self.view.setNeedsDisplay()
    }
    // MARK: - Fetch AllAppointmentInfo
    func fetchAllAppointmentInfo()
    {
        let defaultt  = UserDefaults.standard
        let professionID = defaultt.integer(forKey: "userProfessionId")
        let url = UrlUtil.getPatientAppointmentsUrl(patiantId: professionID)
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        indicatorActivity.isUserInteractionEnabled = false;
        APIManager.getAPIRequest(url, parameter: nil, success:  {
            (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                let fetchArr = mainDictionary.value(forKey: "appointments") as! NSArray
                let appointmentObj : Appointments = Appointments.init(appointmentArr: fetchArr)
                Singleton.shareInstance.appointments = appointmentObj
                self.appointmentInfoArr = Singleton.shareInstance.appointments.appointmentUpcomingArr

                DispatchQueue.main.async {
                    self.appointmentTableView.reloadData()
                }
            }
            else
            {
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
                // return allert
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) {
            (error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
            //Error(error) //ert(error)
        }
        
    } // end method
     // MARK: - Fetch AllSpecialitiesInfo
    func fetchAllSpecialitiesInfo()
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
        
        let url = UrlUtil.getAllSpecialitiesUlr()
        
        APIManager.getAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                let fetchSpecialtiesArr = mainDictionary.value(forKey: "specialities") as! NSArray
                let specialitesObj : Specialities = Specialities.init(specialitiesArr: fetchSpecialtiesArr)
                Singleton.shareInstance.specialities = specialitesObj
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
            self.showAlertView(title: "No Response Received", message: "")
        }
    } // end Method

    // MARK: - Selected Appointment Delegate
    func getSelecteAppointmentInfoFromSelectedTableViewCell(SelectedCell: AppointmentTableCell)
    {
        let selectedIndexPath = self.appointmentTableView.indexPath(for: SelectedCell)
        let appointmentObj =  self.appointmentInfoArr?[(selectedIndexPath?.row)!] as! Appointments
        let goToAppointmentDetailController = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentDetailControler") as! AppointmentDetailControler
        goToAppointmentDetailController.selectedAppointmentTab = self.segmentControl.selectedSegmentIndex
        goToAppointmentDetailController.selecteAppointmentInfo = appointmentObj
        goToAppointmentDetailController.selecteAppointmentID = appointmentObj.appointmentId!
        self.navigationController?.pushViewController(goToAppointmentDetailController, animated: true)
    }
    
    @IBAction func reloadDataByTapingSegmentControll(_ sender: Any)
    {
        if self.segmentControl.selectedSegmentIndex == 0
        {
            self.appointmentInfoArr = Singleton.shareInstance.appointments.appointmentUpcomingArr
        }
        else if self.segmentControl.selectedSegmentIndex == 1
        {
            self.appointmentInfoArr = Singleton.shareInstance.appointments.appointmentCompletedArr
        }
        else if self.segmentControl.selectedSegmentIndex == 2
        {
            self.appointmentInfoArr = Singleton.shareInstance.appointments.appointmentCanceledArr
        }
        self.appointmentTableView.reloadData()
    }
    
    // MARK: - Done
    @IBAction func specialityisDone(_ sender : Any)
    {
        let goToSearchDoctorControler = self.storyboard?.instantiateViewController(withIdentifier: "SearchDoctorController") as! SearchDoctorController
        goToSearchDoctorControler.specialityName = self.specialitySelectedStr
            self.navigationController?.pushViewController(goToSearchDoctorControler, animated: true)
       
    }
    // MARK: - goTo Home Controller
    @IBAction func goToHomecontroller(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Speciality Cancel
    @IBAction func specialityIsCancel(_sender : Any)
    {
        self.isSpecialityCellSelected = false
        self.isSpecialityTableViewIsShowing = false
        //self.te
        self.selectSpecialityLbl.text = "Select Speciality"
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.alpha = 0
            self.addAppointmentTableView.alpha = 0
            
        }, completion: nil)
    }
    // MARK: - Show Add AppointmentView
    @IBAction func showAddAppointmentView(_ sender : Any)
    {
        
        
       var scrollViewHeight = CGFloat()
        if self.scrollView.frame.size.height > self.scrollView.frame.size.width
        {
            scrollViewHeight =  self.scrollView.frame.size.height
        }
        else
        {
            scrollViewHeight =  self.scrollView.frame.size.width
        }
        self.contentViewHeightConstraint.constant = scrollViewHeight
        self.contentView.layoutIfNeeded()
        
        
        
        
        
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight
        {
            let screenheight = self.view.frame.size.height / 2 - self.specialityDoneView.frame.size.height / 2
            self.specialityDoneView.frame = CGRect(x: self.specialityDoneView.frame.origin.x, y: screenheight, width: self.specialityDoneView.frame.size.width, height: self.specialityDoneView.frame.size.height)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.addAppointmentTableView.alpha = 0
                self.contentView.alpha = 1
                self.scrollView.alpha = 1
                self.addAppointmentTableView.alpha = 0.0
                self.scrollView.isHidden = false
                self.contentView.backgroundColor = UIColor.clear
                self.scrollView.backgroundColor = UIColor().getCustomBlurColor()
                self.view.bringSubview(toFront: self.scrollView)
            }, completion: nil)
        }
        
        else
        
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.addAppointmentTableView.alpha = 0
                self.contentView.alpha = 1
                self.scrollView.alpha = 1
                self.addAppointmentTableView.alpha = 0.0
                self.scrollView.isHidden = false
                self.contentView.backgroundColor = UIColor.clear
                self.scrollView.backgroundColor = UIColor().getCustomBlurColor()
                self.view.bringSubview(toFront: self.scrollView)
            }, completion: nil)
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AppointmentViewController.showSpecialityView(sender:)))
        gestureRecognizer.delegate = self
        gestureRecognizer.numberOfTapsRequired = 1
        self.specilityTextFieldView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func showSpecialityView(sender : UITapGestureRecognizer)
    {
//        if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight || UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
//        {
//
//            self.specialityDoneBotomConstraint.constant = 40.0
//        }
        
        let specialtiesInfos = Singleton.shareInstance.specialities.specialitiesInfos
        self.specialityInfoArr = specialtiesInfos
         self.reloadSpecialityTableView()
        
        
        
    } // end function
    func reloadSpecialityTableView()
    {
        if self.isSpecialityTableViewIsShowing == true
        {
            return
        }
        else
        {
           self.specialityTableView.tableFooterView = UIView(frame: .zero)
            UIView.animate(withDuration: 0.5, animations: {
                self.addAppointmentTableView.alpha = 1
            }, completion: nil)
           if self.isSpecilityTableloadFirstTime == false
           {
            self.specialityTableView.dataSource = self
            self.specialityTableView.delegate = self
            self.isSpecilityTableloadFirstTime = true
           }
         else
          {
            self.specialityTableView.reloadData()
          }
      }
        self.isSpecialityTableViewIsShowing = true
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight || UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
        {
            self.specialityDoneBotomConstraint.constant = 40.0
        }
    }
    // MARK:-  Show Specialicity View
    func reloadAppointmentableView()
    {
        self.appointmentTableView.tableFooterView = UIView(frame: .zero)
        if self.isTableReloadFirstTime == false
        {
            self.appointmentTableView.delegate = self
            self.appointmentTableView.dataSource = self
            self.isTableReloadFirstTime = true
        }
        else
        {
            self.appointmentTableView.reloadData()
        }
    }
    //MARk: - Table Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //self.specialityInfoArr
        if tableView == self.appointmentTableView
        {
            if self.appointmentInfoArr != nil
            {
                return ((self.appointmentInfoArr?.count))!
            }
            else
            {
                return 0
            }
        }
        else if tableView == self.specialityTableView
        {
            return self.specialityInfoArr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == self.appointmentTableView
        {
            let celll = tableView.dequeueReusableCell(withIdentifier: "AppointmentTableCell")  as! AppointmentTableCell
            let appointmentObj = self.appointmentInfoArr?[indexPath.row] as? Appointments;
            celll.appointmentDate.text = appointmentObj?.date;
            var startTimeStr = appointmentObj?.startTime
            let endTimeStr = appointmentObj?.endTime
            let toStr = " to "
            startTimeStr = startTimeStr?.appending(toStr)
            startTimeStr = startTimeStr?.appending(endTimeStr!)
            celll.appointmentTime.text = startTimeStr
      
            let imageStr : String?  = appointmentObj?.professionalInfoo.logoPath
            var imageUrl : URL!
            if imageStr !=  nil
            {
                 imageUrl = URL(string: imageStr!)
            }
            
            if imageUrl == nil
            {
                DispatchQueue.main.async
                {
                     celll.doctorImage.image = UIImage(named: "doctorImg")
                }
            }
            else
            {
                celll.doctorImage.sd_setImage(with: imageUrl, placeholderImage: nil, options: [.continueInBackground], completed: nil)
            }
            //celll.doctorImage.image =
            if appointmentObj?.inPerson == true
            {
                celll.appointmentTypeImg.image = UIImage(named :"personImg")
            }
            else if appointmentObj?.video == true
            {
                 celll.appointmentTypeImg.image = UIImage(named :"videoImg")
            }
            else if appointmentObj?.audio == true
            {
                celll.appointmentTypeImg.image = UIImage(named :"phoneImg")
            }
            let professionalObj = appointmentObj?.professionalInfoo
            let firstNameStr = professionalObj?.firstName?.appending(" ")
            let middleNameStr = professionalObj?.middleName?.appending(" ")
            let lastNameStr = professionalObj?.lastName
            let fullName = firstNameStr?.appending(middleNameStr!).appending(lastNameStr!)
            celll.doctorName.text = fullName
            celll.appointmentTime.adjustsFontSizeToFitWidth = true
            celll.appointmentDelagte = self
            return celll
        }
            // Appointment Table view
            /* speciality Table View */
        else if tableView == self.specialityTableView
        {
            let celll  = tableView.dequeueReusableCell(withIdentifier: "ApointmntSpeclityTbleCel") as! ApointmntSpeclityTbleCel
            celll.specialityLable.text = self.specialityInfoArr[indexPath.row].name
             celll.cellBackGroundImg.image = UIImage(named : "apontmntTxtfild")
            celll.selectionStyle = .none
            return celll
        }
        //return celll
        //}
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.specialityTableView
        {
            
            let selectCell = self.specialityTableView.cellForRow(at: indexPath) as! ApointmntSpeclityTbleCel
            selectCell.cellBackGroundImg.image = UIImage(named : "smallcellBackround")
            
            self.specialitySelectedStr = self.specialityInfoArr[indexPath.row].name!
            self.selectSpecialityLbl.text =   self.specialitySelectedStr//selectesSpeceilty
            self.isSpecialityCellSelected = true
            self.isSpecialityCellSelected = true
            self.isSpecialityTableViewIsShowing = false
            UIView.animate(withDuration: 0.5, animations: {
                self.addAppointmentTableView.alpha = 0
            }, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        if tableView == self.specialityTableView
        {
        let deselectCell = self.specialityTableView.cellForRow(at: indexPath) as! ApointmntSpeclityTbleCel
        deselectCell.cellBackGroundImg.image = UIImage(named : "apontmntTxtfild")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == self.appointmentTableView
        {
            return  70.0
        }
        else if tableView == self.specialityTableView
        {
            return 36
        }
        return 0
    }
} // end calss
