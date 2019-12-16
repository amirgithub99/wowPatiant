//
//  MedicationAlergyControler.swift
//  Wow Patient
//
//  Created by Amir on 13/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

import Alamofire


class MedicationAlergyControler: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, RemoveAllergyDelagate, RemoveMedicationDelegate {
    
    @IBOutlet weak var medicationTableView : UITableView!
    @IBOutlet weak var allergyTableView : UITableView!
    @IBOutlet weak var addAllergyTableView : UITableView!

    @IBOutlet weak var searchBar : UISearchBar!
    
    @IBOutlet weak var searchBarAllergy : UISearchBar!
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var addMedicationAllergyView : UIView!
    @IBOutlet weak var addMedicationView : UIView!
    @IBOutlet weak var addAllergyView : UIView!
    @IBOutlet weak var addAllergyTxtFieldView: UIView!
   // @IBOutlet weak var allergyPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchAllergyTypeView: UIView!
    
    @IBOutlet weak var addMedicationAllergyBtn: UIButton!
    @IBOutlet weak var medicineNameTxtField : UITextField!
    @IBOutlet weak var doseTxtField : UITextField!
    @IBOutlet weak var howOftenTxtField : UITextField!
    @IBOutlet weak var howLongTxtField : UITextField!
    @IBOutlet weak var prescribedTxtField : UITextField!
    @IBOutlet weak var addAllergyTxtField: UITextField!
    
    @IBOutlet weak var medicationBtn: UIButton!
    @IBOutlet weak var allergyBtn: UIButton!
    
    var isMedicationTableShowing = Bool()
    var isMedicationTableReload = Bool()
    var isAllergyTableReload = Bool()
    var isSearcBarActive = Bool()
    var isMedicationSearchBarActive = Bool()
    var isAllergySearcBarActive = Bool()
    var isAllergyTypesSelected = Bool()
    var isAllergyTypeShowing = Bool()
    var isAllergySearBarActive = Bool()
     var isAllergyTypeSearBarActive = Bool()
    var isAlergyTypeFirstTime = Bool()


    var medicationInfoArr = NSMutableArray()
    var allergyInfoArr = NSMutableArray()
    var medicationFilterInfoArr = NSMutableArray()
    var allergyFilterInfoArr = NSMutableArray()
    var allergyTypesArr = NSMutableArray()
    var allergyTypesFilterArr = NSMutableArray()
    
    var selectedAllergyTypeDict = NSDictionary()
    
    
    var patitantProfessionId : Int!
    
    
    
    @IBOutlet weak var addMedicationAllergyViewHeightConstraint: NSLayoutConstraint!
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let userDefaullt  = UserDefaults.standard
        self.patitantProfessionId = userDefaullt.integer(forKey: "userProfessionId")
        self.fetchAllAllergiesType()
        self.fetchAllMedication()
        self.medicationTableView.delegate = self
        self.medicationTableView.dataSource = self
        self.isMedicationTableReload = true
        self.allergyTableView.isHidden = true
        self.medicationTableView.alpha = 1
        self.medicationTableView.isHidden = false
        self.isMedicationTableShowing = true
     
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide , object: nil)
    }

    override func viewWillAppear(_ animated: Bool)
    {
    
        NotificationCenter.default.addObserver(self, selector: #selector(MedicationAlergyControler.showKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MedicationAlergyControler.hidingKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.medicationTableView.tableFooterView = UIView(frame: .zero)
        self.allergyTableView.tableFooterView = UIView(frame: .zero)
        self.addAllergyTableView.tableFooterView = UIView(frame: .zero)
        if self.segmentControl.selectedSegmentIndex == 0
        {
            self.searchBarHeightConstraint.constant = 0
        }
        else
        {
            self.searchBarHeightConstraint.constant = 50;
        }
        self.searchBar.delegate = self
        self.medicineNameTxtField.delegate = self
        self.doseTxtField.delegate = self
        self.howOftenTxtField.delegate = self
        self.howLongTxtField.delegate = self
        self.prescribedTxtField.delegate = self
        self.addAllergyTxtField.delegate = self
        self.scrollView.delegate = self
        
        self.medicineNameTxtField.returnKeyType = .done
        self.doseTxtField.returnKeyType = .done
        self.howOftenTxtField.returnKeyType = .done
        self.howLongTxtField.returnKeyType = .done
        self.prescribedTxtField.returnKeyType = .done
        self.addAllergyTxtField.returnKeyType = .done
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    // MARK: - Show MedicalInfo
    @IBAction func showMedicationInfo(_ sender: Any)
    {
        if self.segmentControl.selectedSegmentIndex == 1
        {
            self.isMedicationTableShowing = true
            self.medicationBtn.setImage(UIImage(named: "medicationSelected"), for: .normal)
            self.allergyBtn.setImage(UIImage(named: "allergy"), for: .normal)
            self.medicationTableView.isHidden = false
            self.allergyTableView.isHidden = true
            self.segmentControl.selectedSegmentIndex = 0
            
            //return
        }
        self.medicationTableView.isHidden = false
        self.medicationTableView.reloadData()
        self.allergyTableView.isHidden = true
        self.isMedicationTableShowing = true
        self.medicationBtn.setImage(UIImage(named: "medicationSelected"), for: .normal)
        self.allergyBtn.setImage(UIImage(named: "allergy"), for: .normal)
    }
    
    @IBAction func backToPreviouscontroller(_ sender: Any)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Cancel Allergy
    @IBAction func cancelAllergy(_ sender: Any)
    {
        //self.isAllergyTypesSelected == false
       self.isAllergyTypesSelected = false
        self.addAllergyTxtField.text = ""
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.alpha = 0
        }, completion: nil)
    }
    // MARK: - Save AllergyInfo
    @IBAction func saveAllergy(_ sender: Any)
    {
        if self.isAllergyTypesSelected == false
        {
        self.showAlertView(titlee: "Select Allergy types", messagee: "")
        return
        }
        let allergyDict = self.selectedAllergyTypeDict
        //self.allergyTypesArr[self.pickerView.selectedRow(inComponent: 0)] as! NSDictionary
        let allergyNameStr = allergyDict.value(forKey: "allergyName") as? String
        let allergyIDStr = String(describing: allergyDict.value(forKey: "allergyID") as! Int)
        let allergydescriptions = allergyDict.value(forKey: "description") as? String
        let parameterr  = ["allergyName" : allergyNameStr , "allergyID" : allergyIDStr, "description" : allergydescriptions]
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }

         let url = UrlUtil.getAddAllergyUrl(patiantId: self.patitantProfessionId)
        APIManager.postAPIRequest(url, parameter: parameterr, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let allergyObj = Allergy()
                allergyObj.allergyName = allergyDict.value(forKey: "allergyName") as? String
                allergyObj.allergyID = allergyDict.value(forKey: "allergyID") as? Int
                allergyObj.descriptions = allergyDict.value(forKey: "descriptions") as? String
                allergyObj.selected = allergyDict.value(forKey: "selected") as? String
                let allergyArrObj = Singleton.shareInstance.alllergyInfo.allergyArr
                allergyArrObj.add(allergyObj)
                self.allergyInfoArr = Singleton.shareInstance.alllergyInfo.allergyArr
   
                
                self.isAllergyTypesSelected = false
                
                self.addAllergyView.isHidden = false
                //self.allergyPickerView.isHidden = true
                 self.searchAllergyTypeView.isHidden = true
                self.searchAllergyTypeView.alpha = 1
                self.addAllergyTxtField.text = ""
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.scrollView.alpha = 0
                    self.addAllergyView.isHidden = true
                    self.searchAllergyTypeView.isHidden = true

                }, completion: nil)
                self.allergyTableView.reloadData()
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }
            
        }) { (error) -> Void in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
        }
    }
    
     // MARK: - Show AllergyInfo
    @IBAction func showAllergyInfo(_ sender: Any)
    {
        if self.segmentControl.selectedSegmentIndex == 1 
        {
            self.isMedicationTableShowing = false
            self.allergyTableView.isHidden = true
            self.medicationTableView.isHidden = true
            self.medicationBtn.setImage(UIImage(named: "medication"), for: .normal)
            self.allergyBtn.setImage(UIImage(named: "allergySelected"), for: .normal)
            
            self.segmentControl.selectedSegmentIndex = 0
           // return
        }
        self.searchAllergyTypeView.isHidden = true
        self.allergyTableView.isHidden = false
        self.allergyTableView.alpha = 1
        if self.isAllergyTableReload == false
        {
            self.allergyTableView.delegate = self
            self.allergyTableView.dataSource = self
            self.fetchAllAlergies()
            self.isAllergyTableReload = true
        }
        else
        {
           self.allergyTableView.reloadData()
        }
        self.medicationTableView.isHidden = true
        self.isMedicationTableShowing = false
        self.medicationBtn.setImage(UIImage(named: "medication"), for: .normal)
        self.allergyBtn.setImage(UIImage(named: "allergySelected"), for: .normal)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MedicationAlergyControler.showAllergyTypes(sender:)))
        gestureRecognizer.delegate = self
        gestureRecognizer.numberOfTapsRequired = 1
       //self.addAllergyTxtFieldView.addGestureRecognizer(gestureRecognizer)
        self.addAllergyTxtField.isUserInteractionEnabled = true
        self.addAllergyTxtField.addGestureRecognizer(gestureRecognizer)
    }
    // MARK: - Show AllergyTypes
    @objc func showAllergyTypes(sender : UITapGestureRecognizer)
    {
        if self.isAlergyTypeFirstTime == false
        {
            self.addAllergyTxtField.delegate = self
            self.addAllergyTableView.delegate = self
            self.addAllergyTableView.dataSource = self
            DispatchQueue.main.async
                {
                 self.addAllergyTableView.reloadData()
                }
            self.isAlergyTypeFirstTime = true
        }
        else
        {
            self.addAllergyTableView.reloadData()
        }
        self.searchBarAllergy.delegate = self
        self.addAllergyTxtField.isSelected = false
        self.searchAllergyTypeView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.searchAllergyTypeView.alpha = 1

        }
        self.isAllergyTypeShowing = true
    } // end method
    @IBAction func doneAllergyTypeSelected(_ sender: Any)
    {
       self.isAllergyTypesSelected = true
        let allergyDict = self.allergyTypesArr[self.pickerView.selectedRow(inComponent: 0)] as! NSDictionary
        let allergyName = allergyDict.value(forKey: "allergyName") as? String
        self.addAllergyTxtField.text = allergyName
        //selectedYear = yearArray[yearPickerView.selectedRow(inComponent: 0)]
    }
      // MARK: - Save Medication
    @IBAction func saveMedication(_ sender: Any)
    {
        let medicationNameStr = self.medicineNameTxtField.text
        if  (medicationNameStr?.isEmpty)!{
            self.showAlertView(titlee: "Medicine name is required", messagee: "")
            return
        }
        
        let doctorName = self.prescribedTxtField.text
         let doseStr = self.doseTxtField.text
        let frequencyStr = self.howOftenTxtField.text
        //medicationObj.frequency =  frequency
        let durationStr = self.howLongTxtField.text
        
        let parameterss = ["medicationName" : medicationNameStr, "frequency" : frequencyStr, "dose" : doseStr, "duration" : durationStr, "description" : "", "doctorName" : doctorName]
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
        let url = UrlUtil.getAddMedicationUrl(patiantId: self.patitantProfessionId)
        APIManager.postAPIRequest(url, parameter: parameterss, success: { (JSONResponse) -> Void in
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let medicationObj = Medication()
                
                let medicationID = mainDictionary.value(forKey: "patientMedicationID") as! Int
                
                medicationObj.medicationID = medicationID
                medicationObj.medicationName = medicationNameStr//self.medicineNameTxtField.text
                medicationObj.doctorName = doctorName
                medicationObj.dose = doseStr
                medicationObj.frequency =  frequencyStr
                medicationObj.duration = durationStr//self.howLongTxtField.text
                Singleton.shareInstance.medicationInfo.medicationArr.add(medicationObj)
                self.medicationInfoArr =  Singleton.shareInstance.medicationInfo.medicationArr
                self.medicineNameTxtField.text = ""
                self.howOftenTxtField.text = ""
                self.howLongTxtField.text = ""
                self.prescribedTxtField.text = ""
                self.doseTxtField.text = ""
                UIView.animate(withDuration: 0.5, animations: {
                    self.scrollView.alpha = 0
                    self.addMedicationView.alpha = 0
                }, completion: nil)
                
                self.medicationTableView.reloadData()
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }
            
        }) { (error) -> Void in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
        }
    }// end method
    @IBAction func ShowAddMedicationOrAddAllergyView(_ sender: Any)
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
        self.addMedicationAllergyViewHeightConstraint.constant = scrollViewHeight
        self.addMedicationAllergyView.layoutIfNeeded()
        //addMedicationAllergyViewHeightConstraint
        
        
        
        if self.isMedicationTableShowing
        {
            self.scrollView.backgroundColor =  UIColor().getCustomBlurColor()
            self.scrollView.alpha = 1
            self.view.bringSubview(toFront: self.scrollView)
            self.addAllergyView.alpha = 0
            self.addAllergyView.isHidden = true
            self.searchAllergyTypeView.isHidden = true
            self.addMedicationAllergyView.backgroundColor = UIColor.clear//().getCustomBlurColor()
            self.addMedicationView.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollView.alpha = 1
                self.addMedicationView.alpha = 1
            }, completion: nil)
        }
        else
        {
            self.scrollView.backgroundColor = UIColor().getCustomBlurColor()//UIColor.clear
             self.scrollView.alpha = 1
            self.view.bringSubview(toFront: self.scrollView)
            self.addMedicationView.alpha = 0
            self.addMedicationView.isHidden = true
            self.addAllergyView.isHidden = false
            self.searchAllergyTypeView.isHidden = true
            self.searchAllergyTypeView.alpha = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollView.alpha = 1
                self.addAllergyView.alpha = 1
            }, completion: nil)
        }
        
    }// end method
    // MARK: - Cancel Medication
    @IBAction func cancelMedication(_ sender: Any)
    {
        if self.isMedicationTableShowing == true
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollView.alpha = 0
            }, completion: nil)
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollView.alpha = 0
            }, completion: nil)
        }
    }// end Method
    
    // MARK: - SegmentControl
    @IBAction func showDataByTapingSegmentControl(_ sender: Any)
    {
        if self.segmentControl.selectedSegmentIndex == 0
        {
            self.searchBarHeightConstraint.constant = 0
            self.addMedicationAllergyBtn.isHidden = false
            self.medicationTableView.isHidden = false
             if self.isMedicationTableShowing
             {
                self.medicationTableView.isHidden = false
                 self.allergyTableView.isHidden = true
            }
            else
            
             {
                 self.medicationTableView.isHidden = true
                 self.allergyTableView.isHidden = false
            }
        }
        else
        {
            self.medicationTableView.isHidden = true
            self.allergyTableView.isHidden = true
            self.searchBarHeightConstraint.constant = 50;
            self.addMedicationAllergyBtn.isHidden = true
        }
        if self.isMedicationTableShowing
        {
             self.isMedicationSearchBarActive = false
            self.medicationTableView.reloadData()
        }
        else
        {
            self.isAllergySearcBarActive  = false
            self.allergyTableView.reloadData()
        }
        if self.segmentControl.selectedSegmentIndex == 1
        {
             self.medicationTableView.isHidden = true
            self.allergyTableView.isHidden = true
           // self.searchBarHeightConstraint.constant
        }
    }
    func fetchAllAllergiesType()
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
        let url = UrlUtil.getAllergyTypesUrl()

        APIManager.getAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let fetchArr = mainDictionary.value(forKey: "allergies") as! NSArray
                if self.allergyTypesArr.count > 0
                {
                    self.allergyTypesArr.removeAllObjects()
                }
                self.allergyTypesArr = fetchArr.mutableCopy() as! NSMutableArray
                //self.medicationTableView.reloadData()
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }
            
        }) { (error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
        }
        
    } // end methid
    // MARK: - Fetch All Allergies
    func fetchAllAlergies()
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
        let url = UrlUtil.getAllergyUrl(patiantId: self.patitantProfessionId)
        APIManager.getAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
    
    let allergyArr = mainDictionary.value(forKey: "patientAllergies") as! NSArray
    /* Sote AlergyObj In Singletion Class*/
    
    let allergyObj : Allergy = Allergy.init(allergyArr: allergyArr)
    Singleton.shareInstance.alllergyInfo = allergyObj
    
    self.allergyInfoArr = Singleton.shareInstance.alllergyInfo.allergyArr
                DispatchQueue.main.async {
                    
                    self.allergyTableView.reloadData()
                }
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }
            
        }) { (error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
        }
    } // end methdod
    func fetchAllMedication()
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
        let url = UrlUtil.getMedicationUrl(patiantId: self.patitantProfessionId)
        APIManager.getAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                 MBProgressHUD.hide(for: self.view, animated: true)
                let patientMedicationsDict = mainDictionary.value(forKey: "patientMedications") as! NSDictionary
                /* Store Medication Obj in Singleton Clas Obj */
                let medicationObj : Medication = Medication.init(medicationDict: patientMedicationsDict)
                Singleton.shareInstance.medicationInfo =  medicationObj
                self.medicationInfoArr = Singleton.shareInstance.medicationInfo.medicationArr
                self.medicationTableView.reloadData()
            }
            else
            {
                 MBProgressHUD.hide(for: self.view, animated: true)
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }
           
        }) { (error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
        }
    }
    func getMedicationInfo(medicationArr : NSArray)
    {
    }
    func getAllergyInfo(medicationArr : NSArray)
    {
    }
     // MARK: - Sear Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        self.isSearcBarActive = true
        self.searchBar.setShowsCancelButton(true, animated: true)
        if self.isAllergyTypeShowing == true
        {
         self.searchBarAllergy.setShowsCancelButton(true, animated: true)
        }
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
        if self.isMedicationSearchBarActive == true
        {
//            self.isMedicationSearchBarActive = false
//            self.medicationTableView.reloadData()
            self.searchBar.setShowsCancelButton(false, animated: true)
        }
        else if self.isAllergySearcBarActive == true
        {
//            self.isAllergySearcBarActive = false
//            self.allergyTableView.reloadData()
            self.searchBar.setShowsCancelButton(false, animated: true)
        }
        else if self.isAllergyTypeShowing == true
        {
            //self.isAllergyTypeShowing = false
            //self.isAllergyTypeSearBarActive = false
            //self.alle.setShowsCancelButton(false, animated: true)
            self.searchBarAllergy.setShowsCancelButton(false, animated: true)
            //searchBar.resignFirstResponder()
           // self.addAllergyTableView.reloadData()
        }
       searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.isSearcBarActive = false
        if self.isMedicationSearchBarActive == true
        {
            self.isMedicationSearchBarActive = false
            self.searchBar.setShowsCancelButton(false, animated: true)
            self.searchBar.resignFirstResponder()
            //self.medicationTableView.reloadData()
        }
        else if self.isAllergySearcBarActive == true
        {
           self.isAllergySearcBarActive = false
            self.searchBar.setShowsCancelButton(false, animated: true)
           //self.allergyTableView.reloadData()
            self.searchBar.resignFirstResponder()
        }
        else if self.isAllergyTypeShowing == true
        {
            //self.isAllergyTypeShowing = false
            //self.isAllergyTypeSearBarActive = false
            //self.alle.setShowsCancelButton(false, animated: true)
            self.searchBarAllergy.setShowsCancelButton(false, animated: true)
           self.searchBarAllergy.resignFirstResponder()
            //self.addAllergyTableView.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if self.isAllergyTypeShowing == true
        {
            self.isMedicationSearchBarActive = false
            self.isAllergySearcBarActive = false
            if searchText.count < 1
            {
                ///uuuuuu
                //self.isAllergyTypeShowing = false
                self.isAllergyTypeSearBarActive = false
                 self.addAllergyTableView.reloadData()
            }
            else
            {
                self.searchBarAllergy.setShowsCancelButton(true, animated: true)
                self.showFilterAllergyTypes(searchtxt: searchText)
            }
        }
        else
        {
          self.showFilterMedicationAllergyName(searchtxt: searchText)
        }
    }
    //bbbbbbb
    func showFilterAllergyTypes(searchtxt : String)
    {
        self.isAllergyTypeSearBarActive = true
        self.allergyTypesFilterArr.removeAllObjects()
        for var i in 0..<self.allergyTypesArr.count
        {
            let allergyDict = self.allergyTypesArr[i] as! NSDictionary
            let allergyName = allergyDict.value(forKey: "allergyName") as? String
            if (allergyName?.localizedCaseInsensitiveContains(searchtxt))!
            {
                 self.allergyTypesFilterArr.add(allergyDict)
            }
            i += 1
        } // for loop end
        self.addAllergyTableView.reloadData()
    }
    func showFilterMedicationAllergyName(searchtxt : String)
    {
        if self.isMedicationTableShowing == true
         {
             self.medicationFilterInfoArr.removeAllObjects()
            //self.isMedicationSearchBarActive = true
            //self.isAllergySearcBarActive = false
            if searchtxt.isEmpty
            {
                  self.isSearcBarActive = false
                  self.isMedicationSearchBarActive = false
                 self.isAllergySearcBarActive = false
                 self.medicationTableView.reloadData()
            }
            else
            {
                self.isMedicationSearchBarActive = true
                self.isAllergySearcBarActive = false
                for var i in 0..<self.medicationInfoArr.count
                {
                    let medicationAllInfo = self.medicationInfoArr[i] as! Medication
                    let medicationStr = medicationAllInfo.medicationName
                    if (medicationStr?.localizedCaseInsensitiveContains(searchtxt))!
                    {
                        self.medicationFilterInfoArr.add(medicationAllInfo)
                    }
                    i += 1
                } // for loop end
                self.medicationTableView.reloadData()
            }
         } // if end
        else
        {
            if searchtxt.isEmpty
            {
                self.allergyFilterInfoArr.removeAllObjects()
                //self.isSearcBarActive = false
                self.isMedicationSearchBarActive = false
                self.isAllergySearcBarActive = false
                self.allergyTableView.reloadData()
            }
            else
            {
                self.isMedicationSearchBarActive = false
                self.isAllergySearcBarActive = true
                if self.isMedicationTableShowing == false
                {
                    self.allergyFilterInfoArr.removeAllObjects()
                    for var i in 0..<self.allergyInfoArr.count
                    {
                        let allergyAllInfo = self.allergyInfoArr[i] as! Allergy
                        let allergyStr = allergyAllInfo.allergyName
                        if (allergyStr?.localizedCaseInsensitiveContains(searchtxt))!
                        {
                            self.allergyFilterInfoArr.add(allergyAllInfo)
                        }
                        i += 1
                    } // for loop end
                    self.allergyTableView.reloadData()
                }
            }
         // else end
        }
    }// end function
    // MARK: - Show Alert Controller
    func showAlertView(titlee : NSString, messagee : NSString)
    {
        let alertController = UIAlertController(title: titlee as String, message: messagee as String, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title : "Ok", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            // male is Selected
        }))
        present(alertController, animated: true, completion: nil)
    } // end function
    // MARK: - Remove  Medication Delete Method
    func removeSelectedMedication(selectedCell: MedicationTableCel)
    {
        selectedCell.medicationDeleteBtn.setImage(UIImage(named: "crossPurple"), for: .normal)
        
        let selectedIndexPath  = self.medicationTableView.indexPath(for: selectedCell)
        let madicationId = (self.medicationInfoArr[(selectedIndexPath?.row)!] as! Medication).medicationID
        let selectedIndex = selectedIndexPath?.row
          let selecteDate = (self.medicationInfoArr[(selectedIndexPath?.row)!] as! Medication).dose
        let alertController = UIAlertController(title: "Are You Want To Delete This", message:"" , preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title : "Yes", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            self.deleteSelectedMedication(madicationID: madicationId!, selectedIndex: selectedIndex!, slecteDate: selecteDate!, selecteMedicationcell: selectedCell)
            
        }))
        
        alertController.addAction(UIAlertAction(title : "No", style:.default, handler:{
            (action : UIAlertAction) -> Void in
        selectedCell.medicationDeleteBtn.setImage(UIImage(named: "crossGrey"), for: .normal)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteSelectedMedication(madicationID : Int, selectedIndex : Int, slecteDate : String, selecteMedicationcell : MedicationTableCel)
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
        let url = UrlUtil.getMedicationDeleteUrl(patiantId: self.patitantProfessionId, madicationid: madicationID,date: slecteDate)
        
        APIManager.deleteAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
    
               let medicationArr = Singleton.shareInstance.medicationInfo.medicationArr
               medicationArr.removeObject(at: (selectedIndex))
               self.medicationInfoArr = Singleton.shareInstance.medicationInfo.medicationArr
               self.medicationTableView.reloadData()
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }
            
        }) { (error) -> Void in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
        }
    }
    // MARK: - KeyBoard Delegate Method
    @objc func showKeyBoard(notification :  NSNotification)
    {
        var keyBoardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        keyBoardHeight = keyBoardHeight + 30
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyBoardHeight, 0.0)
        }, completion: nil)
       // self.scrollView.setNeedsLayout()
    }
    @objc func hidingKeyBoard(notification :  NSNotification)
    {
        //self.scrollView.setNeedsLayout()
       // self.scrollView.backgroundColor = UIColor.blue
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
           // self.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }, completion: nil)
        //self.scrollView.setNeedsLayout()
    }
    // MARK: - Text Field Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return true
    }
    // MARK: - Remove Selected Allergy
    func removeSelectedAllergy(selectedCell: AllergyTableCell)
    {
        selectedCell.deleteAllergyBtn.setImage(UIImage(named: "crossPurple"), for: .normal)
        let selectedIndexPath = self.allergyTableView.indexPath(for: selectedCell)
        let selectedAllergyID = (self.allergyInfoArr[(selectedIndexPath?.row)!] as! Allergy).allergyID
        let alertController = UIAlertController(title: "Are You Want To Delete This", message:"" , preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title : "Yes", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            self.deleteSelectedAllergy(allergy_ID: selectedAllergyID!, selectedIndex: (selectedIndexPath?.row)!, slecteDate: "crossGrey")
        }))
        alertController.addAction(UIAlertAction(title : "No", style:.default, handler:{
            (action : UIAlertAction) -> Void in
      selectedCell.deleteAllergyBtn.setImage(UIImage(named: ""), for: .normal)
        }))
        present(alertController, animated: true, completion: nil)
    }
    // MARK:- delete Selected Allergy
    func deleteSelectedAllergy(allergy_ID : Int, selectedIndex : Int, slecteDate : String)
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
        let url = UrlUtil.getAllergyDeleteUrl(patiantId: self.patitantProfessionId, allergyId: allergy_ID)
        APIManager.deleteAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                ////sssssss
                MBProgressHUD.hide(for: self.view, animated: true)
                let allergyArr = Singleton.shareInstance.alllergyInfo.allergyArr
                allergyArr.removeObject(at: (selectedIndex))
                self.allergyInfoArr = Singleton.shareInstance.alllergyInfo.allergyArr
                UIView.animate(withDuration: 0.5, animations: {
                    self.scrollView.alpha = 0
                    self.searchAllergyTypeView.isHidden = true
                    self.allergyTableView.isHidden = false
                    self.allergyTableView.reloadData()
                }, completion: nil)

            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }
            
        }) { (error) -> Void in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
        }
    } // end Method

    // MARK: - Table View Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.medicationTableView
        {
            if self.isMedicationSearchBarActive == true
            {
                return self.medicationFilterInfoArr.count
            }
            else
            {
             return self.medicationInfoArr.count
            }
        }
        else if tableView == self.addAllergyTableView
        {
            if self.isAllergyTypeSearBarActive == false
            {
              return self.allergyTypesArr.count
            }
            else
            {
                return self.allergyTypesFilterArr.count
            }
        }
        else
        {
            if self.isAllergySearcBarActive == true
            {
                return self.allergyFilterInfoArr.count
            }
            else
            {
                return self.allergyInfoArr.count
            }
        }
    }
    
    /*  ApointmntSpeclityTbleCel Is using  ReuseableCell */ 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == self.medicationTableView //&& self.isAllergyTypeShowing == false
        {
            let medicationCell = tableView.dequeueReusableCell(withIdentifier: "MedicationTableCel") as! MedicationTableCel
            
            var medicationInfoObj = Medication()
            
            if self.isMedicationSearchBarActive == true
            {
                 medicationInfoObj  = self.medicationFilterInfoArr[indexPath.row] as! Medication
                medicationCell.medicationDeleteBtn.isHidden = true
            }
            else
            {
                medicationCell.medicationDeleteBtn.isHidden = false
             medicationInfoObj  = self.medicationInfoArr[indexPath.row] as! Medication
            }
            var frequencyDurationStr = medicationInfoObj.frequency
            frequencyDurationStr = frequencyDurationStr?.appending(" , ")
            let durationStr = medicationInfoObj.duration
            frequencyDurationStr = frequencyDurationStr?.appending(durationStr!)
            medicationCell.frequencyLable.text = frequencyDurationStr
            medicationCell.frequencyLable.adjustsFontSizeToFitWidth = true
            medicationCell.medicineName.text =  medicationInfoObj.medicationName
            medicationCell.doctorName.text =  medicationInfoObj.doctorName
            medicationCell.dateLbl.text = medicationInfoObj.date
            medicationCell.medicationDelegate = self
            return medicationCell
        }
         else if tableView == self.addAllergyTableView //&& self.isAllergyTypeShowing == true
         {
            var allergyTypeCell = ApointmntSpeclityTbleCel()
             var allergyDict = NSDictionary()
            if self.isAllergyTypeSearBarActive == false
            {
                allergyTypeCell = tableView.dequeueReusableCell(withIdentifier: "ApointmntSpeclityTbleCel") as! ApointmntSpeclityTbleCel
                allergyDict = self.allergyTypesArr[indexPath.row] as! NSDictionary
            }
            else
            {
              allergyTypeCell = tableView.dequeueReusableCell(withIdentifier: "ApointmntSpeclityTbleCel") as! ApointmntSpeclityTbleCel
              allergyDict = self.allergyTypesFilterArr[indexPath.row] as! NSDictionary
            }
            let allergyName = allergyDict.value(forKey: "allergyName") as! String
            allergyTypeCell.specialityLable.text = allergyName
            allergyTypeCell.selectionStyle = .none
            allergyTypeCell.cellBackGroundImg.image = UIImage(named: "apontmntTxtfild")
            return allergyTypeCell
         }
        else if tableView == self.allergyTableView //&& self.isAllergyTypeShowing == false
        {
            let allergyCell = tableView.dequeueReusableCell(withIdentifier: "AllergyTableCell") as! AllergyTableCell
            var allergyInfoObj = Allergy()
            if self.isAllergySearcBarActive == true
            {
                allergyInfoObj = self.allergyFilterInfoArr[indexPath.row] as! Allergy
                allergyCell.deleteAllergyBtn.isHidden = true
            }
            else
            {
                allergyCell.deleteAllergyBtn.isHidden = false
                allergyInfoObj = self.allergyInfoArr[indexPath.row] as! Allergy
            }
            //let allergyInfoObj = self.allergyInfoArr[indexPath.row] as! Allergy
            allergyCell.allergyName.text = allergyInfoObj.allergyName
            allergyCell.allergyDelegate = self
            //allergyCell.d
            return allergyCell
        }
        return AllergyTableCell()
    }// end function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.addAllergyTableView
        {
            
            let selectedCell = self.addAllergyTableView.cellForRow(at: indexPath) as! ApointmntSpeclityTbleCel
            selectedCell.cellBackGroundImg.image = UIImage(named: "smallcellBackround")
            
            let  allergyDict = self.allergyTypesArr[indexPath.row] as! NSDictionary
            self.selectedAllergyTypeDict = allergyDict
            let allergyName = allergyDict.value(forKey: "allergyName") as! String
            self.addAllergyTxtField.text = allergyName
            self.isAllergyTypesSelected = true
        }
      UIView.animate(withDuration: 0.5)
        {
            self.searchAllergyTypeView.alpha = 0
        }
        self.isAllergyTypeShowing = false
        
        //self.is
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == self.medicationTableView
        {
            return  70.0
        }
        else
        {
            return 44
        }
       // return 44
    }
} // end class
