//
//  AppointmentDetailControler.swift
//  Wow Patient
//
//  Created by Amir on 12/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Alamofire

enum AppointmentsType : Int
{
    case Upcoming = 0
    case Completed
    case Cancelled
}
enum Foo : String {
    case Bing
    case Bang
    case Boom
    
   }

class AppointmentDetailControler: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var specialityLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var encounterLbl : UILabel!
    @IBOutlet weak var netTotalLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var  scrollView : UIScrollView!
    @IBOutlet weak var detailTextView : UITextView!
    @IBOutlet weak var servisTextView : UITextView!
    
    @IBOutlet weak var cancelView : UIView!
    @IBOutlet weak var upcomingView : UIView!
    @IBOutlet weak var reschduleView : UIView!
    @IBOutlet weak var cancelAppointmentView : UIView!

    @IBOutlet weak var centerViewHeightContant: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var centerImageView: UIImageView!


    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    
    
    
    
    var selectedAppointmentTab = Int()
    var selecteAppointmentID = Int()
    var selecteAppointmentInfo = Appointments()
    
    // MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.detailTextView.delegate = self
        self.servisTextView.delegate = self
        self.detailTextView.endEditing(true)
        self.servisTextView.endEditing(true)
        
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
            //self.contentView.backgroundColor = UIColor.red
            self.contentView.layoutIfNeeded()
            self.detailView.layoutIfNeeded()
            self.centerView.layoutIfNeeded()
            self.centerImageView.layoutIfNeeded()
          }
        
        
        self.fecthAppointmentByAppointmentId()
        self.updateAllView()
       // self.showAppointmentDetail()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.detailTextView.endEditing(true)
        self.servisTextView.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool)
    {
    }
    // MARK: - Fetch AppointmentByID
  func fecthAppointmentByAppointmentId()
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
    
    let url = UrlUtil.getAppointmenetUrlByAppointmentId(appointentId: self.selecteAppointmentID)
    
    APIManager.getAPIRequest(url, parameter: nil, success: { (JSONResponse) -> Void in
        
        let mainDictionary =  JSONResponse
        let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
        let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
        let messageCode = statusObj.message?.code
        if (messageCode?.contains("S001"))!
        {
            let selectAppointmentDict = mainDictionary.value(forKey: "appointment") as! NSDictionary
            let appointmentObj : Appointments = Appointments.init(appointmentDict: selectAppointmentDict)
            self.selecteAppointmentInfo = appointmentObj
            self.showAppointmentDetail()
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
    }
    func updateAllView()
    {
        var selecteAppointmentType : AppointmentsType
        selecteAppointmentType = AppointmentsType(rawValue: self.selectedAppointmentTab)!
        switch selecteAppointmentType {
        case .Upcoming:
            
            self.cancelView.isHidden = true
            self.upcomingView.isHidden = false
            //self.upcomingView.alpha = 1
            //self.centerViewHeightContant.constant = 414
            self.reschduleView.isHidden = false
            self.cancelAppointmentView.isHidden = false
            break
        case .Completed:
            self.cancelView.isHidden = true
            self.upcomingView.isHidden = true
            //self.centerViewHeightContant.constant = 484
            self.reschduleView.isHidden = true
            self.cancelAppointmentView.isHidden = true
            break
        case .Cancelled:
            self.upcomingView.isHidden = true
            self.cancelView.isHidden = false
           // self.centerViewHeightContant.constant = 436
            //self.cancelView.alpha = 1
            self.reschduleView.isHidden = true
            self.cancelAppointmentView.isHidden = true
            
            break
        //default:break
        }
    }
    @IBAction func goToAppointViewController(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    func showAppointmentDetail()
    {
        let selectedAppointmentInfo = self.selecteAppointmentInfo
        let selectedProfessionalInfo = selectedAppointmentInfo.professionalInfoo
        let netTotalValue = selectedAppointmentInfo .netTotal
         let dateStr = selectedAppointmentInfo.date
        let firstName = selectedProfessionalInfo.firstName
        let middleName = selectedProfessionalInfo.middleName
        let lastName = selectedProfessionalInfo.lastName
        var fullNameStr = firstName?.appending(" ")
        fullNameStr = fullNameStr?.appending(middleName!).appending("")
        fullNameStr = fullNameStr?.appending(lastName!)
        let detailStr = selectedAppointmentInfo.reasonForVisit
        let isVideo = selectedAppointmentInfo.video
        let isAudio = selectedAppointmentInfo.audio
        let isInPerson = selectedAppointmentInfo.inPerson
        let appointmentTime = selectedAppointmentInfo.startTime
        
        let specialityNameStr = selectedProfessionalInfo.specialityName
        
        if isAudio !=  nil
        {
            if isAudio == true
            {
                self.encounterLbl.text = "Audio Call"
            }
        }
        if isVideo !=  nil
        {
            if isVideo == true
            {
                self.encounterLbl.text = "Video Call"
            }
        }
        if isInPerson !=  nil
        {
            if isInPerson == true
            {
                self.encounterLbl.text = "in person encounter"
            }
        }
        
        self.timeLbl.text = appointmentTime
        self.nameLbl.text = fullNameStr
        self.dateLbl.text = dateStr
        self.specialityLbl.text = specialityNameStr
        var netTotalStr : String? //String(describing: netTotalValue)
        if netTotalValue != nil
        {
            let totalAmount : Float! = netTotalValue
            netTotalStr = String(totalAmount)
            //netTotalValue =  netTotalValue!
        }
        let dollarSign : String? = "$ "
        
        self.netTotalLbl.text = "$".appending(netTotalStr!)
        //self.servisTextView.text = servisStr
         self.detailTextView.text = detailStr
         var servisStr = String()
         let servisesArr = selectedAppointmentInfo.appointmentServices
        if servisesArr != nil {
         
            for var i in 0..<servisesArr!.count
            {
                let servisDict = servisesArr![i] as? NSDictionary
                let servisName = servisDict?.value(forKey: "serviceName") as! String
                servisStr += servisName.appending("\n")
                i += 1
            }
            self.servisTextView.text = servisStr
        }
    } // end method
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
} // end Class
