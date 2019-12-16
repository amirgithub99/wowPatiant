//
//  MedicalCondtionControler.swift
//  Wow Patient
//
//  Created by Amir on 12/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Alamofire
import JBDatePicker

class MedicalCondtionControler: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, RemoveDiseaseDelegate, UIAlertViewDelegate, JBDatePickerViewDelegate
{

   // @IBOutlet weak var datePickerOtlet: UIDatePicker!
    @IBOutlet weak var medicalTableView : UITableView!
    @IBOutlet weak var addMedicationView: UIView!
    @IBOutlet weak var medicalNameTxtFildView: UIView!
    @IBOutlet weak var dateTxtFildView: UIView!
    @IBOutlet weak var datePickerLargeView: UIView!
    
    @IBOutlet weak var saveMedicationView: UIView!

    @IBOutlet weak var addMedicaitonViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var addMedicaalCondtionBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var medicalNameTxtField: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var monthLable: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    
    var isDateViewShowing = Bool()
    var isDateSelected = Bool()
    var medicalCondtionArr = NSMutableArray()
    var medicalCondtionFilterArr = NSMutableArray()
    var medicalCondtionNameArr = NSMutableArray()
    var isSearcBarActive = Bool()
    var dateStr = String()
    
    @IBOutlet weak var datePickerView: JBDatePickerView!
    var patitantProfessionId : Int!

    // MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let userDefaullt  = UserDefaults.standard
        self.patitantProfessionId = userDefaullt.integer(forKey: "userProfessionId")
        
        self.showSearchBarView()
        NotificationCenter.default.addObserver(self, selector: #selector(MedicalCondtionControler.showKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MedicalCondtionControler.hidingKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.datePickerView.delegate = self
        self.medicalTableView.tableFooterView = UIView(frame: .zero)
        self.searchBar.delegate = self
        self.scrollView.delegate = self
        self.medicalNameTxtField.delegate = self
        self.medicalNameTxtField.returnKeyType = .done
        self.dateTxtField.delegate = self
        //self.datePickerOtlet.maximumDate = Date()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.fetchMedicalConditionInfo()
        self.medicalTableView.delegate = self
        self.medicalTableView.dataSource = self
    }
    // MARK: - Segment Control
    @IBAction func reloadDataByTapingSegmentControl(_ sender: Any)
    {
        if self.segmentControl.selectedSegmentIndex == 0
        { self.medicalTableView.isHidden = false
            self.addMedicaalCondtionBtn.isHidden = false
        }
        else
        {
            self.medicalTableView.isHidden = true
            self.addMedicaalCondtionBtn.isHidden = true
        }
       self.showSearchBarView()
       self.view.endEditing(true)
    }
    func showSearchBarView()
    {
        if self.segmentControl.selectedSegmentIndex == 0
        {
            self.searchBarHeightConstraint.constant = 0
        }
        else
        {
            self.searchBarHeightConstraint.constant = 50
        }
    }
    // MARK: - Selected Disease
    func removeSelectedDisease(selectedCell: MedicalCondtionTbleCel)
    {
        
        selectedCell.medicalCondtionRemoveBtn.setImage(UIImage(named: "crossPurple"), for: .normal)
     let selectedIndexPath = self.medicalTableView.indexPath(for: selectedCell)
        let selectedMedicalCondtionId = (self.medicalCondtionArr[(selectedIndexPath?.row)!] as! MedicalCondition).medicalConditionID
        let datee = (self.medicalCondtionArr[(selectedIndexPath?.row)!] as! MedicalCondition).date

        let alertController = UIAlertController(title: "Are You Want To Delete This", message:"" , preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title : "Yes", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            
            self.deleteSelectedDisease(medicalCondtion_ID: selectedMedicalCondtionId!, selectedIndex: (selectedIndexPath?.row)!, date:datee!)
        }))
        alertController.addAction(UIAlertAction(title : "No", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            
             selectedCell.medicalCondtionRemoveBtn.setImage(UIImage(named: "crossGrey"), for: .normal)
        }))
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func cancelAddAppointmentView(_ sender: Any)
    {
        
    }
    @IBAction func doneDatePickerView(_ sender: Any)
    {
        self.isDateSelected = true
        self.isDateViewShowing = false
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        // dateStr = formatter.string(from: self.datePickerOtlet.date)
        //self.dateTxtField.text = dateStr
        UIView.animate(withDuration: 0.5)
        {
            self.datePickerView.alpha = 0
        }
    }
    // MARK: - Show Next Month Dates
    @IBAction func showPreviousMonthDates(_ sender: Any)
    {
        self.datePickerView.loadPreviousView()
    }
    @IBAction func showNextMonthDates(_ sender: Any)
    {
        self.datePickerView.loadNextView()
    }
    // MARK: - Calendar Delegate
    func didSelectDay(_ dayView: JBDatePickerDayView)
    {
        var selectedDate = dayView.date
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: .day, value: 1, to: selectedDate!)
        let currentDate = Date()
        // let selectedDate = dayView.date
        if selectedDate! > currentDate
        {
            self.isDateSelected = false
            self.dateTxtField.text = ""
            self.showAlertView(title: "Select Current Date Or Previous Date", message: "")
            return
        }
        self.isDateSelected = true
        self.isDateViewShowing = false
        UIView.animate(withDuration: 0.5)
        {
            self.datePickerLargeView.alpha = 0
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss Z"
         self.dateStr = dateFormatter.string(from: dayView.date!)
      self.dateTxtField.text = self.dateStr
    }
    func didPresentOtherMonth(_ monthView: JBDatePickerMonthView)
    {
        let monthDate = datePickerView.presentedMonthView.monthDescription
        self.monthLable.text = monthDate
    }
    
    @IBAction func goBackToMedicalChartController(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Show AddMedicalConditionView
    @IBAction func showAddMedicalConditonView(_ sender: Any)
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
        self.addMedicaitonViewHeightConstraint.constant = scrollViewHeight
        self.addMedicationView.layoutIfNeeded()
        
        
        //self.addMedicaitonViewHeightConstraint.constant
        
        self.scrollView.alpha = 1
        self.scrollView.backgroundColor = UIColor().getCustomBlurColor()//UIColor.clear
        self.view.bringSubview(toFront: self.scrollView)
        self.addMedicationView.backgroundColor = UIColor.clear//().getCustomBlurColor()
        
        let dateViewGesture = UITapGestureRecognizer(target: self, action: #selector(MedicalCondtionControler.showDatePickerView(sender:)))
        dateViewGesture.delegate = self
        dateViewGesture.numberOfTapsRequired = 1
        self.dateTxtFildView.addGestureRecognizer(dateViewGesture)
        
        self.datePickerLargeView.alpha = 0
        self.dateTxtField.delegate = self
        self.medicalNameTxtField.delegate = self
    
//        let addMedicationViewGesture = UITapGestureRecognizer(target: self, action: #selector(MedicalCondtionControler.hideAddMedicationView(sender:)))
//        addMedicationViewGesture.delegate = self
//        addMedicationViewGesture.numberOfTapsRequired = 1
//        self.addMedicationView.addGestureRecognizer(addMedicationViewGesture)
    }
    // MARK: - Hide AddMedicationView
    @objc func hideAddMedicationView(sender: UITapGestureRecognizer)
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.scrollView.alpha = 0
            self.isDateViewShowing = false
            self.dateTxtField.text = ""
            self.medicalNameTxtField.text = ""
            self.datePickerLargeView.alpha = 0
        }, completion: nil)
    }
    //saveMedicationView
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
//    {
//        if (touch.view?.isDescendant(of: self.datePickerLargeView))! || (touch.view?.isDescendant(of: self.saveMedicationView))!
//        {
//            return false
//        }
//
//
//        return true
//    }
    
    // MARK:- Save MedicalCondtion
    @IBAction func saveMedicalConditon(_ sender: Any)
    {
        if (self.medicalNameTxtField.text?.isEmpty)!
        {
            self.showAlertView(title: "Enter Medicine Name", message: "")
            return
        }
        if self.isDateSelected == false
        {
            self.showAlertView(title: "Select Date", message: "")
            return
        }
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
         let parameterr = ["medicalConditionName" : self.medicalNameTxtField.text! , "date" : dateStr] as [String : Any]
        let url = UrlUtil.getAddMedicalConditionalURL(patiantId: self.patitantProfessionId )
        APIManager.postAPIRequest(url, parameter: parameterr, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let patiantMedicalconitionID = mainDictionary.value(forKey: "patientMedicalConditionID") as! Int
                let medicalCondtionObj = MedicalCondition()
                medicalCondtionObj.date = self.dateStr
                medicalCondtionObj.medicalConditionName = self.medicalNameTxtField.text
                medicalCondtionObj.medicalConditionID =  patiantMedicalconitionID
                Singleton.shareInstance.medicalConditionInfo.medicalConditionArr.add(medicalCondtionObj)
                self.medicalCondtionArr = Singleton.shareInstance.medicalConditionInfo.medicalConditionArr
                self.scrollView.alpha = 0
                self.datePickerLargeView.alpha = 0
                self.isDateSelected  = false
                self.dateTxtField.text = ""
                 self.medicalNameTxtField.text = ""
                self.medicalTableView.reloadData()
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
    } // end method
    // MARK: - Cancel Medication
    @IBAction func cancelMedicalConditon(_ sender: Any)
    {
        self.scrollView.alpha = 0
        self.isDateViewShowing = false
        self.dateTxtField.text = ""
       self.medicalNameTxtField.text = ""
    }
    @objc func showDatePickerView(sender : UITapGestureRecognizer)
    {
       // self.isDateViewShowing = true
        self.showDateView()
    }
    func showDateView()
    {
        self.view.endEditing(true)
       // self.datePickerOtlet.datePickerMode = .date
        if self.isDateViewShowing == false
        {
            UIView.animate(withDuration: 0.5, animations: {
                  self.datePickerLargeView.alpha = 1
            }, completion: nil)
            self.isDateViewShowing = true
        }
    }
    func deleteSelectedDisease(medicalCondtion_ID : Int, selectedIndex : Int, date : String)
    {
        let defaultt  = UserDefaults.standard
        let userID = defaultt.integer(forKey: "userid")
        let tokenstr = defaultt.value(forKey: "token") as! String
        let headerr : HTTPHeaders = ["auth-token" : tokenstr, "auth-userID" :   "\(userID)"]
        
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
        let url = UrlUtil.getDeleteMedicalConditionalURL(patiantId: self.patitantProfessionId , medicalCondtionID: medicalCondtion_ID, date: date)
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headerr).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let mainDicationary =  response.result.value as! NSDictionary
                    let statusDict = mainDicationary.value(forKey: "status") as! NSDictionary
                    let messageDict = statusDict.value(forKey: "message") as! NSDictionary
                    let successCode = messageDict.value(forKey: "code") as! String
                    if successCode.contains(UrlUtil.getSuccessCode())
                    {
                        let medicalArr = Singleton.shareInstance.medicalConditionInfo.medicalConditionArr
                        medicalArr.removeObject(at: (selectedIndex))
                       self.medicalCondtionArr = Singleton.shareInstance.medicalConditionInfo.medicalConditionArr
                        self.medicalTableView.reloadData()
                    }
                    else
                    {
                        return
                    }
                }// succes end
                break
                
            case .failure(_):
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showAlertView(title: "No response received", message: "")
                break
            }
        }
    } // end method
    // MARK: - Fetch Medical CondtionInfos
    func fetchMedicalConditionInfo()
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
        let url = UrlUtil.getMedicalConditionalURL(patiantId: self.patitantProfessionId )
        APIManager.getAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
               
                let medicalCondtionArr = mainDictionary.value(forKey: "patientMedicalConditions") as! NSArray
                let medicalCondtionObj : MedicalCondition = MedicalCondition.init(medicalArr: medicalCondtionArr)
                if Singleton.shareInstance.medicalConditionInfo.medicalConditionArr.count > 0
                {
                    Singleton.shareInstance.medicalConditionInfo.medicalConditionArr.removeAllObjects()
                }
                Singleton.shareInstance.medicalConditionInfo = medicalCondtionObj
                self.medicalCondtionArr = Singleton.shareInstance.medicalConditionInfo.medicalConditionArr
                self.medicalTableView.reloadData()
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
} // end method
    // MARK: - KeyBoard Delegate Method
    @objc func showKeyBoard(notification :  NSNotification)
    {
        var keyBoardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        keyBoardHeight = keyBoardHeight + 30
        
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyBoardHeight, 0.0)
        }, completion: nil)
    }
    @objc func hidingKeyBoard(notification :  NSNotification)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }, completion: nil)
    }
    
    // MARK: - Sear Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //self.isSearcBarActive = true
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
        self.medicalTableView.reloadData()
    
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.showFilterMedicalCondtionName(searchtxt: searchText)
    }
    // MARK: - Show Filter Doctor Name
    func showFilterMedicalCondtionName(searchtxt : String)
    {
        if searchtxt.count == 0 {
            self.isSearcBarActive = false
            self.medicalTableView.reloadData()
            return
        }
        
        self.isSearcBarActive = true
        self.medicalCondtionFilterArr.removeAllObjects()
        for var i in 0..<self.medicalCondtionArr.count
        {
            let medicalCondition = self.medicalCondtionArr[i] as! MedicalCondition
            let medicalCondtionName = medicalCondition.medicalConditionName
            //vehicleInfo.plate_No localizedCaseInsensitiveContainsString:filterStr
            if (medicalCondtionName?.localizedCaseInsensitiveContains(searchtxt))!
            {
                self.medicalCondtionFilterArr.add(medicalCondition)
            }
            
            i += 1
        }
        self.medicalTableView.reloadData()
    }// end function
    // MARK: - Text Field Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.dateTxtField
        {
            textField.resignFirstResponder()
            self.showDateView()
            return false
        }
        else
        {
           UIView.animate(withDuration: 0.5, animations: {
            self.datePickerLargeView.alpha = 0
            self.isDateViewShowing = false
           })
        }
        return true
    }

    // MARK: - Table View Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.isSearcBarActive == true
        {
           return self.medicalCondtionFilterArr.count
        }
        else
        {
            return self.medicalCondtionArr.count
        }
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let celll = tableView.dequeueReusableCell(withIdentifier: "MedicalCondtionTbleCel") as! MedicalCondtionTbleCel
        var medicalCondtionObj = MedicalCondition()
        if self.isSearcBarActive == true
        {
            medicalCondtionObj = self.medicalCondtionFilterArr[indexPath.row] as! MedicalCondition
        celll.medicalCondtionRemoveBtn.isHidden = true
        }
        else
        {
            medicalCondtionObj = self.medicalCondtionArr[indexPath.row] as! MedicalCondition
            celll.medicalCondtionRemoveBtn.isHidden = false
        }
         celll.dateLbl.text = medicalCondtionObj.date
         celll.diseaseNameLbl.text = medicalCondtionObj.medicalConditionName
        celll.diseaseDelegate = self
          return celll
        }
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
         {
             return  70.0
         }

    }// end class

