
//  FinalApointmentControler.swift
//  Wow Patient
//  Created by Amir on 21/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Alamofire

class FinalApointmentControler: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var specialityLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var  encounterLbl : UILabel!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var netPayableLbl: UILabel!
    
    @IBOutlet weak var appointmnetDetailTxtView : UITextView!
    @IBOutlet weak var servisDetailTxtView : UITextView!
    @IBOutlet weak var serviceAmountTxtView: UITextView!
    
    @IBOutlet weak var finalView: UIView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!


    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var paymentDetailView: UIView!
    //@IBOutlet weak var centerView: UIView!
    @IBOutlet weak var paymentDetailImageView: UIImageView!
    
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    
    
    

    // MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        DispatchQueue.main.async {
            
            
            
            
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
            // self.contentView.backgroundColor = UIColor.red
            self.paymentDetailView.layoutIfNeeded()
            self.paymentDetailImageView.layoutIfNeeded()
            
           
        }
        
        
        
        
        self.updateViewWithData()
       // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.appointmnetDetailTxtView.delegate = self
        self.servisDetailTxtView.delegate = self
        self.appointmnetDetailTxtView.endEditing(true)
         self.servisDetailTxtView.endEditing(true)
//        UIView.animate(withDuration: 0.5)
//        {

       
        //}
        
    }
    // MARK: - UpdateView With Data
    func updateViewWithData()
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let createAppointmentInfoo = appdelegate.createAppointmentInfo
        let fullName = createAppointmentInfoo.professionalName
        let selectedAppointmentServis = createAppointmentInfoo.appointmentServices
        var servicesStr = String()
        var servicesAmountStr = String()
        for var i in 0..<selectedAppointmentServis!.count
        {
            let servisInfoDict  = selectedAppointmentServis![i] as! NSDictionary
            let servisName = servisInfoDict.value(forKey: "serviceName") as! String
            servicesStr += (servisName.appending("\n"))
            let charges = servisInfoDict.value(forKey: "serviceCharges") as! Float
            var chargesStr = String(charges)
            chargesStr = chargesStr.appending("$")
           // chargesStr = chargesStr.appending("\n")
            servicesAmountStr += chargesStr.appending("\n")
            i += 1
        }
        self.nameLbl.text = fullName
        self.dateLbl.text = createAppointmentInfoo.date
        self.specialityLbl.text = createAppointmentInfoo.professionalSpeciality
        self.appointmnetDetailTxtView.text = createAppointmentInfoo.reasonForVisit
        if createAppointmentInfoo.video!
        {
        self.encounterLbl.text = "Video"
        }
        else if createAppointmentInfoo.audio!
        {
            self.encounterLbl.text = "Audio"
        }
        else if createAppointmentInfoo.inPerson!
        {
            self.encounterLbl.text = "Inperson"
        }
        self.timeLbl.text = createAppointmentInfoo.startTime
        self.servisDetailTxtView.text = servicesStr
        self.serviceAmountTxtView.text = servicesAmountStr
        let netTotalAmount : Float! = createAppointmentInfoo.netTotal
        
        //let dollarSign : String? = "$ "
        let netTotalStr = String(netTotalAmount)
        self.netPayableLbl.text = "$ ".appending(netTotalStr)
        self.discountLbl.text = "0"
        self.subtotalLbl.text = "0"
    
    }
    // MARK: - Back To ProceedController
    @IBAction func goBackToProceedController(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Create Final Appointment
    @IBAction func createFinalAppointment(_ sender : Any)
    {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let createAppointmentInfoo = appdelegate.createAppointmentInfo
        let selectedAppointmentServises = createAppointmentInfoo.appointmentServices
        let parameters = ["date" : createAppointmentInfoo.date as Any,
                       "startTime" : createAppointmentInfoo.startTime as Any,
                       "endTime" : createAppointmentInfoo.endTime as Any,
                       "duration" : createAppointmentInfoo.duration as Any,
                       "video" : createAppointmentInfoo.video as Any,
                       "audio" : createAppointmentInfoo.audio as Any,
                       "inPerson" : createAppointmentInfoo.inPerson as Any,
                       "status" : "ok",
                       "reasonForVisit" : createAppointmentInfoo.reasonForVisit as Any, "professionalId" : createAppointmentInfoo.professionalId as Any,
                       //"appointmentId" : cre,
                       "reevaluation" :createAppointmentInfoo.reevaluation as Any,
                       "appointmentStatusId" :createAppointmentInfoo.appointmentStatusId as Any,
                       "patientId" : createAppointmentInfoo.patientId as Any,
                       "slotDetailId" : createAppointmentInfoo.slotDetailId as Any, "appointmentServices" : selectedAppointmentServises as Any, "paymentMethodId" : "1"]
        
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
        let url = UrlUtil.getCreateAppointmnetUrl()
        APIManager.postAPIRequest(url, parameter: parameters, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                //createAppointmentInfoo.appointmentId
                Singleton.shareInstance.appointments.appointmentUpcomingArr.add(createAppointmentInfoo)
                
                let alertController = UIAlertController(title: "Appointment Added Successfully", message:"" , preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title : "Yes", style:.default, handler:{
                    (action : UIAlertAction) -> Void in
                    let goToHomeController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(goToHomeController, animated: true)
                }))
               self.present(alertController, animated: true, completion: nil)
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        textView.endEditing(true)
        textView.resignFirstResponder()
        return false
    }
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        textView.endEditing(true)
        textView.resignFirstResponder()
        //return false
    }
} // end class
