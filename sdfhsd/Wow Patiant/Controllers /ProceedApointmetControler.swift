//
//  ProceedApointmetControler.swift
//  Wow Patient
//
//  Created by Amir on 20/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Alamofire

class ProceedApointmetControler: UIViewController, UITextViewDelegate, UITextFieldDelegate , UIGestureRecognizerDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, ProceedSelectedCellDelegate{
    
    @IBOutlet weak var detailtTxtView: UITextView!
    @IBOutlet weak var servisTxtField: UITextField!
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var addServisView : UIView!
    @IBOutlet weak var servicesLargeView : UIView!
    @IBOutlet weak var serviceSubView: UIView!
    @IBOutlet weak var proceedBtnView: UIView!

    
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    

    @IBOutlet weak var proceedTableView: UITableView!
    @IBOutlet weak var servicesTableView: UITableView!
    
    var createAppointmentInfo = Appointments()
    var professionalServicesArr = NSMutableArray()
    var proceedDictArr = NSMutableArray()
    var isFirstTimeInsertText = Bool()
    var isFirtTimeSelected = Bool()
    var isServisTableReload = Bool()
    var netAmount = Float()
    var isServicesLargeViewShowing = Bool()
    
    // MARK: - View Life Cycle
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
        self.serviceSubView.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool)
    {
        let addServisGesture = UITapGestureRecognizer(target: self, action:#selector(ProceedApointmetControler.showServices(sender:)))
        addServisGesture.delegate = self
        addServisGesture.numberOfTapsRequired = 1
        self.servisTxtField.addGestureRecognizer(addServisGesture)
        
        let addServisViewGesture = UITapGestureRecognizer(target: self, action:#selector(ProceedApointmetControler.showServices(sender:)))
        addServisViewGesture.delegate = self
        addServisViewGesture.numberOfTapsRequired = 1
        self.addServisView.addGestureRecognizer(addServisViewGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProceedApointmetControler.showKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProceedApointmetControler.hidingKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.proceedTableView.tableFooterView = UIView(frame: .zero)
        self.servicesTableView.tableFooterView = UIView(frame: .zero)
        
        self.detailtTxtView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.proceedTableView.delegate = self
        self.proceedTableView.dataSource = self
    }
    // MARK: - Show Services
    @objc func showServices(sender : UITapGestureRecognizer)
    {
        self.proceedBtnView.backgroundColor = UIColor().getCustomBlurColor()

        self.view.endEditing(true)
        if self.isServisTableReload == false
        {
            self.fetchProfessionalServices()
            self.servicesTableView.delegate = self
            self.servicesTableView.dataSource = self
            self.isServisTableReload = true
        }
        else
        {
            self.servicesTableView.reloadData()
        }
        UIView.animate(withDuration: 0.5) {
            self.servicesLargeView.alpha = 1
        }
        self.proceedBtnView.backgroundColor = UIColor().getCustomBlurColor()
        self.servicesLargeView.backgroundColor = UIColor().getCustomBlurColor()
        self.scrollView.backgroundColor = UIColor().getCustomBlurColor()
        self.contentView.bringSubview(toFront: self.servicesLargeView)
        self.isServicesLargeViewShowing = true
    }

    // MARK: - hide ServiceLargeView
    @IBAction func hideServiceLargeView(_ sender: Any)
    {
         self.isServicesLargeViewShowing = false
        UIView.animate(withDuration: 0.5) {
            self.servicesLargeView.alpha = 0
            self.servicesLargeView.backgroundColor = UIColor.clear
            self.scrollView.backgroundColor = UIColor.clear
           self.proceedBtnView.backgroundColor = UIColor(red:0.94, green:0.86, blue:1.00, alpha:1.0)
            //self.proceedBtnView.backgroundColor = UIColor().getCustomBlurColor()
        }
         self.isServicesLargeViewShowing = false
    }
    // MARK: - Go Back Create AppointmentCintroler
    @IBAction func gBackToCreateAppointmentController(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Create Proceed
    @IBAction func goToFinalAppointmentController(_ sender: Any)
    {
        if  self.isServicesLargeViewShowing == true
        {
            return
        }
        
        if self.proceedDictArr.count < 1
        {
            self.showAlertView(title: "Select Services", message: "")
            return
        }
        let goToFinalAppointmentController = self.storyboard?.instantiateViewController(withIdentifier: "FinalApointmentControler") as! FinalApointmentControler
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.createAppointmentInfo.appointmentServices = self.proceedDictArr
          appDelegate.createAppointmentInfo.reasonForVisit = self.detailtTxtView.text
           if self.detailtTxtView.text.contains("Type Detail..")
           {
            self.detailtTxtView.text  = ""
           }
        appDelegate.createAppointmentInfo.reasonForVisit = self.detailtTxtView.text
        appDelegate.createAppointmentInfo.netTotal = self.netAmount
        self.navigationController?.pushViewController(goToFinalAppointmentController, animated: true)
    }
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
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        }, completion: nil)
    }
    // MARK: - Text Field Delegate Method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    // MARK: - Textview Delegate Method
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text.contains("Type Detail..")
        {
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    // MARK:-  Fetch Professional Services
    func fetchProfessionalServices()
    {
        let url = UrlUtil.getProfessionalServicesUrl(professionId: 8)
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
        APIManager.getAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                self.serviceSubView.alpha = 1
                let servicesArr = mainDictionary.value(forKey: "servicesByProfessional") as! NSArray//servicesByProfessional
                let professionalServicesObj : ProfessionalServices = ProfessionalServices.init(servicesArr: servicesArr)
                if(Singleton.shareInstance.professionalServicesInfo.professionalServicesArr.count > 0)
                 {
              Singleton.shareInstance.professionalServicesInfo.professionalServicesArr.removeAllObjects()
                 }
                Singleton.shareInstance.professionalServicesInfo = professionalServicesObj
                self.professionalServicesArr =  Singleton.shareInstance.professionalServicesInfo.professionalServicesArr
                self.servicesTableView.reloadData()
            }
            else
            {
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (error) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
        }
    } // end Method
    // MARK: - Delete Selected Service
    func removeSelectedCellProceedInfo(selectedCell: ProceedApointmentTbleCel)
    {
        let selectedIndexPath = self.proceedTableView.indexPath(for: selectedCell)
        self.proceedDictArr.removeObject(at: (selectedIndexPath?.row)!)
        self.netAmount = 0
        self.proceedTableView.reloadData()
        let selectedImg = UIImage(named: "removeSelected")
        selectedCell.removeBtn.setImage(selectedImg, for: .normal)
    }
    // MARK: - Table Delegate Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == servicesTableView
        {
            return self.professionalServicesArr.count
        }
        else
        {
            return self.proceedDictArr.count
        }
    }
    /*  ApointmntSpeclityTbleCel Is using  ReuseableCell */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == servicesTableView
        {
            let celll = tableView.dequeueReusableCell(withIdentifier: "ApointmntSpeclityTbleCel", for: indexPath) as! ApointmntSpeclityTbleCel
            let services = self.professionalServicesArr[indexPath.row] as! ProfessionalServices
            celll.specialityLable.text = services.name
            celll.selectionStyle = .none
            
            celll.cellBackGroundImg.image = UIImage(named: "apontmntTxtfild")
            return celll
        }
        else
        {
            let celll = tableView.dequeueReusableCell(withIdentifier: "ProceedApointmentTbleCel", for: indexPath) as! ProceedApointmentTbleCel
            let proceedInfoDict = self.proceedDictArr[indexPath.row] as! NSDictionary
            celll.serviceName.text = proceedInfoDict.value(forKey: "serviceName") as? String
            var servisCharges  =  proceedInfoDict.value(forKey: "serviceCharges") as? Float
            if servisCharges == nil
            {
                servisCharges = 0
            }
            let servisAmount = servisCharges
            self.netAmount = servisAmount! + netAmount
            let dollarSign = "$"
            var servisChargesStr = String(servisCharges!)
            servisChargesStr = servisChargesStr.appending(dollarSign)
            celll.servisAmount.text = String(servisChargesStr)
            let netTotalAmountStr = String(self.netAmount)
            //self.netAmountLbl.text = "$ ".appending(netTotalAmountStr)
            celll.selectedBtnDelegate = self
            celll.removeBtn.setImage(UIImage(named: "crossGrey"), for: .normal)
            return celll
        }
        
    }// end Method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.isFirtTimeSelected == false
        {
            self.proceedTableView.delegate = self
            self.proceedTableView.dataSource = self
        }
        var isContain = Bool()
        let servicesInfo = self.professionalServicesArr[indexPath.row] as! ProfessionalServices
        let servisNamee = servicesInfo.name//servicesDict.value(forKey: "name") as! String
        let servisCharges = servicesInfo.serviceCharges
        let servisID = servicesInfo.id
        let servisInfoDict  = ["serviceName" : servisNamee as Any, "serviceCharges" : servisCharges as Any, "serviceID" : servisID as Any ]
        if tableView == servicesTableView
        {
            let selectServisCell = self.servicesTableView.cellForRow(at: indexPath) as! ApointmntSpeclityTbleCel
            selectServisCell.cellBackGroundImg.image = UIImage(named: "smallcellBackround")
            if self.proceedDictArr.count == 0
            {
                self.proceedDictArr.add(servisInfoDict)
                //self.servicesLargeView.alpha = 0
                UIView.animate(withDuration: 0.5) {
                    self.servicesLargeView.alpha = 0
                    self.scrollView.backgroundColor = UIColor.clear
                    self.proceedBtnView.backgroundColor = UIColor(red:0.94, green:0.86, blue:1.00, alpha:1.0)


                }
                self.proceedTableView.reloadData()
                
                self.isServicesLargeViewShowing = false
                //self.ispr
            }
            else
            {
                for var i in 0..<self.proceedDictArr.count
                {
                    let proceedInfo = self.proceedDictArr[i] as! NSDictionary
                    let proceedName = proceedInfo.value(forKey: "serviceName") as! String
                    if (proceedName.localizedCaseInsensitiveContains(servisNamee!))
                    {
                        // alert Already Selecte
                        self.showAlertView(title: "Already Exist", message: "")
                        //self.servicesLargeView.alpha = 0
                        UIView.animate(withDuration: 0.5) {
                            self.servicesLargeView.alpha = 0
                            self.scrollView.backgroundColor = UIColor.clear
                            self.proceedBtnView.backgroundColor = UIColor(red:0.94, green:0.86, blue:1.00, alpha:1.0)


                        }
                        
                        selectServisCell.cellBackGroundImg.image = UIImage(named: "apontmntTxtfild")
                        isContain = true
                        
                         self.isServicesLargeViewShowing = false
                    }
                    else if (isContain == false && i == self.proceedDictArr.count - 1)
                    {
                        self.proceedDictArr.add(servisInfoDict)
                        //self.servicesLargeView.alpha = 0
                        UIView.animate(withDuration: 0.5) {
                            //self.proceedBtnView.backgroundColor = UIColor.red
                            self.servicesLargeView.alpha = 0
                            self.scrollView.backgroundColor = UIColor.clear
                            self.proceedBtnView.backgroundColor = UIColor(red:0.94, green:0.86, blue:1.00, alpha:1.0)
                        }
                        self.netAmount = 0
                        self.proceedTableView.reloadData()
                         self.isServicesLargeViewShowing = false
                    }
                    i += 1
                } // end for loop
                
            }
        } // if end 
        
        self.isFirtTimeSelected = true
    }// end Method

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
}// end class
