//
//  CreateAppointmentControler.swift
//  Wow Patient
//
//  Created by Amir on 12/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Alamofire
import JBDatePicker


class CreateAppointmentControler: UIViewController, UITableViewDelegate, UITableViewDataSource, JBDatePickerViewDelegate {
    
    @IBOutlet weak var slotsTableView : UITableView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var datePickerView: JBDatePickerView!
    @IBOutlet weak var monthLbl: DetailMediumLable!
    
    var selectedDate: Date!
    var professionalID = Int()
    var professionalSlotArr = NSMutableArray()
    var createAppointmentInfo = Appointments()
    var slotDateStr = String()
    public var selectedProfessionalInfo = Professionalinfo()
    
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    // MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        DispatchQueue.main.async
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
            self.contentViewHeightConst.constant = scrollViewHeight
            self.contentView.layoutIfNeeded()
           }
        self.datePickerView.delegate = self
        self.slotsTableView.tableFooterView = UIView(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAppointmentControler.showingKeyBoard(notification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAppointmentControler.hidingKeyBoard(notifaction:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
    }
    override func viewDidAppear(_ animated: Bool)
    {
//        self.getAvailableSlot()
        self.slotsTableView.delegate = self
        self.slotsTableView.dataSource = self

    }
    // MARK:- keyBoard Delegate Method
    @objc func showingKeyBoard(notification : NSNotification)
    {        
        var keyBoardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        keyBoardHeight = keyBoardHeight + 30
        
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyBoardHeight, 0.0)
        }, completion: nil)
    }
    @objc func hidingKeyBoard(notifaction : NSNotification)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        }, completion: nil)
    }
    @objc func dismissKeyBoardOnTouchingOutsideTextField(_ sender : UIGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    // MARK: - Selected Day Date
    func didSelectDay(_ dayView: JBDatePickerDayView)
    {
         var selectedDate = dayView.date
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: .day, value: 1, to: selectedDate!)
        
        let currentDate = Date()
       // let selectedDate = dayView.date
        if selectedDate! < currentDate
        {
            self.showAlertView(title: "Select Current Date Or Next Date", message: "")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: dayView.date!)
        self.getAvailableSlot(date: dateStr)
    }
     // MARK: - Selected Month Date
    func didPresentOtherMonth(_ monthView: JBDatePickerMonthView)
    {
        let monthDate = datePickerView.presentedMonthView.monthDescription
        self.monthLbl.text = monthDate
    }
     // MARK: -show PreviousMonthsDate
    @IBAction func showPreviousMonthDates(_ sender: Any)
    {
     self.datePickerView.loadPreviousView()
    }
    // MARK: -show NextMonthDate
    @IBAction func showNextMonthDates(_ sender: Any)
    {
        self.datePickerView.loadNextView()
    }
    @IBAction func goToProfessionDetailController(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAvailableSlot(date : String)
    {
        
        let dateStr = date
        self.slotDateStr = dateStr
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.professionalID = appDelegate.createAppointmentInfo.professionalInfoo.professionalID!
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
        let url = UrlUtil.getCreateAppointUrl(professionalId: self.professionalID, selectedDate: dateStr)
        APIManager.getAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                let availableSlots = mainDictionary.value(forKey: "availableCalendarSlots") as! NSArray
                Singleton.shareInstance.professionalSlotInfo.professionalSlotArr.removeAllObjects()
                let professionalSlotObj : ProfessionalSlots = ProfessionalSlots.init(slots: availableSlots)
              if (Singleton.shareInstance.professionalSlotInfo.professionalSlotArr.count > 0)
              {
                Singleton.shareInstance.professionalSlotInfo.professionalSlotArr.removeAllObjects()
               }
                Singleton.shareInstance.professionalSlotInfo = professionalSlotObj
                self.professionalSlotArr = Singleton.shareInstance.professionalSlotInfo.professionalSlotArr
                self.slotsTableView.reloadData()
                print("757575")
            }
            else
            {
                if (Singleton.shareInstance.professionalSlotInfo.professionalSlotArr.count > 0)
                {
              Singleton.shareInstance.professionalSlotInfo.professionalSlotArr.removeAllObjects()
                }
                self.professionalSlotArr = Singleton.shareInstance.professionalSlotInfo.professionalSlotArr
                 self.slotsTableView.reloadData()
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (error) -> Void in
            self.slotsTableView.reloadData()
            print("88888")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
        }
    }// end Method
    // MARK:-  Table Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.professionalSlotArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let celll  = tableView.dequeueReusableCell(withIdentifier: "SlotApointmentTbleCel") as! SlotApointmentTbleCel
        
        let professionSlotInfo = self.professionalSlotArr[indexPath.row] as! ProfessionalSlots
        let startTime = professionSlotInfo.startTime
        let endTime = professionSlotInfo.endTime
        let dashStr = " - "
        var fullTimeStr = startTime?.appending(dashStr)
        fullTimeStr = fullTimeStr?.appending(endTime!)
        celll.startEndTimeLbl.text = fullTimeStr
       return celll
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedProfessionSlot = self.professionalSlotArr[indexPath.row] as! ProfessionalSlots
        let goToProceedController = self.storyboard?.instantiateViewController(withIdentifier: "ProceedApointmetControler") as! ProceedApointmetControler
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.createAppointmentInfo.startTime = selectedProfessionSlot.startTime
        appDelegate.createAppointmentInfo.endTime = selectedProfessionSlot.endTime
        appDelegate.createAppointmentInfo.date = self.slotDateStr
        appDelegate.createAppointmentInfo.duration = selectedProfessionSlot.duration
        appDelegate.createAppointmentInfo.reevaluation = false
        appDelegate.createAppointmentInfo.appointmentStatusId = 1
        appDelegate.createAppointmentInfo.slotDetailId = selectedProfessionSlot.calendarSlotDetailId
        appDelegate.createAppointmentInfo.patientId = 146
        appDelegate.createAppointmentInfo.professionalId = selectedProfessionSlot.professionalId
        self.navigationController?.pushViewController(goToProceedController, animated: true)
        
    }
    
} // end class
