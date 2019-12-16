//
//  AppointmntFilterControler.swift
//  Wow Patient
//  Created by Amir on 10/04/2018.
//  Copyright © 2018 Amir. All rights reserved.


import UIKit
import Alamofire
protocol FilterDoctorDelegate : class {
    
    func getFilterDoctor(filterDoctors : NSMutableArray)
}

class AppointmntFilterControler: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate , MapViewLongLatDelegate{

    @IBOutlet weak var nameTxtField : UITextField!
    @IBOutlet weak var specialityTxtField : UITextField!
    @IBOutlet weak var locationTxtField : UITextField!
    @IBOutlet weak var serviceTxtField : UITextField!
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var specialityServisTable : UITableView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var specialityView : UIView!
    @IBOutlet weak var serviceView : UIView!
    @IBOutlet weak var mapView : UIView!
    @IBOutlet weak var specialityServisLargeView : UIView!
    @IBOutlet weak var specialityServisSubView : UIView!
    
    
    
    @IBOutlet weak var applyView : UIView!

    @IBOutlet weak var selectSpecialityLbl: UILabel!
    var latitude = Double()
    var longitude = Double()
    var specialityInfoArr  = [Specialities]()
    var servisInfoArr  = NSMutableArray()
    weak var filterDoctorDelgate : FilterDoctorDelegate?
    var isSpeciality = Bool()
    var isTableFirstTimeCall = Bool()
    var isServisInfoArrContain = Bool()
    var isServisLargeViewShowing = Bool()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.specialityServisSubView.alpha = 0
        self.nameTxtField.delegate = self
        self.specialityTxtField.delegate = self
        self.serviceTxtField.delegate = self
        
        self.nameTxtField.keyboardType = .asciiCapable
        self.specialityTxtField.keyboardType = .asciiCapable
        self.serviceTxtField.keyboardType = .asciiCapable
        
        self.nameTxtField.returnKeyType = .done
        self.specialityTxtField.returnKeyType = .done
        self.serviceTxtField.returnKeyType = .done
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.addingGestureRecognizerInSpecialityServisLocationView()
        self.scrollView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(AppointmntFilterControler.showKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppointmntFilterControler.hidingKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.specialityServisTable.tableFooterView = UIView(frame: .zero)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        
    }
    // MARK: - addingGestureRecognizerInSpecialityServisLocationView
    func addingGestureRecognizerInSpecialityServisLocationView()
    {
        let servisGesture = UITapGestureRecognizer(target: self, action: #selector(AppointmntFilterControler.showServisView(sender:)))
        servisGesture.delegate = self
        servisGesture.numberOfTapsRequired = 1
        self.serviceTxtField.addGestureRecognizer(servisGesture)
        
        let specialityGesture = UITapGestureRecognizer(target: self, action: #selector(AppointmntFilterControler.showSpecialityView(sender:)))
        specialityGesture.delegate = self
        specialityGesture.numberOfTapsRequired = 1
        self.specialityTxtField.addGestureRecognizer(specialityGesture)
        
        
        let locationGesture = UITapGestureRecognizer(target: self, action: #selector(AppointmntFilterControler.showMapView(sender:)))
        locationGesture.delegate = self
        locationGesture.numberOfTapsRequired = 1
        self.locationTxtField.addGestureRecognizer(locationGesture)
        
        let specilitViewGesture = UITapGestureRecognizer(target: self, action: #selector(AppointmntFilterControler.showSpecialityView(sender:)))
        specilitViewGesture.delegate = self
        specilitViewGesture.numberOfTapsRequired = 1
        self.specialityView.addGestureRecognizer(specilitViewGesture)
    
        let locationviewGesture = UITapGestureRecognizer(target: self, action: #selector(AppointmntFilterControler.showMapView(sender:)))
        locationviewGesture.delegate = self
        locationviewGesture.numberOfTapsRequired = 1
        self.mapView.addGestureRecognizer(locationviewGesture)
    
        let sericeViewGesture = UITapGestureRecognizer(target: self, action: #selector(AppointmntFilterControler.showServisView(sender:)))
        sericeViewGesture.delegate = self
        sericeViewGesture.numberOfTapsRequired = 1
        self.serviceView.addGestureRecognizer(sericeViewGesture)
        
    }
    // MARK: - Show SpecialityView
    @objc func showSpecialityView(sender :  UITapGestureRecognizer)
    {
        self.applyView.backgroundColor = UIColor().getCustomBlurColor()

        self.specialityServisSubView.alpha = 1

        UIView.animate(withDuration: 0.5) {
            self.specialityServisLargeView.alpha = 1
            //self.applyView.backgroundColor = UIColor().getCustomBlurColor()
            
            //self.scrollView.backgroundColor = UIColor().getCustomBlurColor()

        }
        //self.applyView.backgroundColor = UIColor().getCustomBlurColor()

        self.isSpeciality = true
        self.specialityInfoArr = Singleton.shareInstance.specialities.specialitiesInfos
        
         self.applyView.backgroundColor = UIColor().getCustomBlurColor()
        //self.specialityServisLargeView.backgroundColor = UIColor().getCustomBlurColor()
        
        self.contentView.bringSubview(toFront: self.specialityServisLargeView)
        
        self.scrollView.backgroundColor = UIColor().getCustomBlurColor()
       
        
        if self.isTableFirstTimeCall == false
        {
            self.specialityServisTable.delegate = self
            self.specialityServisTable.dataSource = self
            self.specialityServisTable.reloadData()
            self.isTableFirstTimeCall = true
        }
        else
        {
            self.specialityServisTable.reloadData()
        }
        self.selectSpecialityLbl.text = "Select Speciality"
         self.isServisLargeViewShowing = true
        
        //applyView
    }
     // MARK: - Show ServisView
    @objc func showServisView(sender :  UITapGestureRecognizer)
    {
        UIView.animate(withDuration: 0.5) {
            self.specialityServisLargeView.alpha = 1
        }
        if self.isServisInfoArrContain == false
        {
            self.fetchProfessionalServices()
            self.isServisInfoArrContain = true
        }
        else
        {
           // self.servisInfoArr = Singleton.shareInstance.specialities.specialitiesInfos
        }
        self.applyView.backgroundColor = UIColor().getCustomBlurColor()

        self.isSpeciality = true
        self.isSpeciality = false
        self.servisInfoArr = Singleton.shareInstance.professionalServicesInfo.professionalServicesArr
        //self.specialityServisLargeView.backgroundColor = UIColor().getCustomBlurColor()
        self.scrollView.backgroundColor = UIColor().getCustomBlurColor()
        self.contentView.bringSubview(toFront: self.specialityServisLargeView)
        if self.isTableFirstTimeCall == false
        {
            self.specialityServisTable.delegate = self
            self.specialityServisTable.dataSource = self
            self.isTableFirstTimeCall = true
        }
        else
        {
            self.specialityServisTable.reloadData()
        }
        self.selectSpecialityLbl.text = "Select Services"
        
        
        self.isServisLargeViewShowing = true
    } // end method
    // MARK: - Map View Delegate
    func getMapViewLongtitudeLatitude(longitude: Double, latitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
        let latitudeStr : String! = String(describing: self.latitude)
        let longitudeStr : String! = String(describing: self.longitude)
        var latLongStr = "{ lat : "
        latLongStr = latLongStr.appending(latitudeStr)
        latLongStr = latLongStr.appending(", ")
        latLongStr = latLongStr.appending("lon : ")
        latLongStr = latLongStr.appending(longitudeStr)
        latLongStr = latLongStr.appending(" }")
        self.locationTxtField.text = latLongStr
    }
    // MARK:-  Fetch Professional Services
    func fetchProfessionalServices()
    {
        let url = UrlUtil.getAllServicesUrl()
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
                let servicesArr = mainDictionary.value(forKey: "allServices") as! NSArray//servicesByProfessional
                let professionalServicesObj : ProfessionalServices = ProfessionalServices.init(servicesArr: servicesArr)
                Singleton.shareInstance.professionalServicesInfo = professionalServicesObj
                self.servisInfoArr =  Singleton.shareInstance.professionalServicesInfo.professionalServicesArr
                DispatchQueue.main.async {
                    self.specialityServisTable.reloadData()

                }
                self.specialityServisSubView.alpha = 1
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

    // MARK: - Show MapView
    @objc func showMapView(sender:  UITapGestureRecognizer)
    {
        let goToMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        goToMapViewController.mapViewDelegate = self
        self.navigationController?.pushViewController(goToMapViewController, animated: true)
    }
    
    // MARK: - Hide SpecialityLaegeView
    @IBAction func hideSpecialityServisLargeView(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5)
        {

            self.scrollView.backgroundColor = UIColor.clear
            self.specialityServisLargeView.alpha = 0
            self.applyView.backgroundColor = UIColor(red:0.94, green:0.86, blue:1.00, alpha:1.0)
            self.isServisLargeViewShowing = false
        }
    }
  // MARK: -Back TosearchDoctorsController
    @IBAction func goBackTosearchDoctorsController(_ sender : Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - searchDoctorsByFilterAll TextField
    @IBAction func searchDoctorsByFilter(_ sender : Any)
    {
        if self.isServisLargeViewShowing == true
        {
            return
        }
        
        let fullName = self.nameTxtField.text
        var firstName : String!
        var middleName : String?
        var lastName  : String?
        var specialityName : String?
        var serviceName : String?
        specialityName = self.specialityTxtField.text
        serviceName = self.serviceTxtField.text
        
        let nameArr = fullName?.components(separatedBy: " ")
        if (nameArr?.count)! > 0
        {
            firstName = nameArr?[0]
            
            if (nameArr?.count)! > 1
            {
                middleName = nameArr?[1]
            }
            
            if (nameArr?.count)! > 2
            {
                lastName = nameArr?[2]
            }
        }
        let payRoll = ["firstName" : firstName as Any, "middleName" : middleName as Any,  "lastName" : lastName as Any, "speciality" : specialityName as Any, "serviceName" : serviceName as Any ,"lat" : self.longitude as Any , "lon" : self.longitude]
         let url = UrlUtil.getProfessionByCritiaUrl()
        
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        //indicatorActivity.isUserInteractionEnabled = false;
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
        APIManager.postAPIRequest(url, parameter:payRoll, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let doctorInfoArr = mainDictionary.value(forKey: "professionalsByCriteria") as! NSArray
                if doctorInfoArr.count < 1
                {
                    self.showAlertView(titlee: "No Result Match", messagee: "")
                    return
                }
                else
                {
                    if (self.filterDoctorDelgate != nil)
                    {
                        self.filterDoctorDelgate?.getFilterDoctor(filterDoctors:  doctorInfoArr.mutableCopy() as! NSMutableArray)
                    }
                    self.navigationController?.popViewController(animated: true)
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
    } // end method
    
    // MARK: - Show Alert Controller
    func showAlertView(titlee : NSString, messagee : NSString)
    {
        let alertController = UIAlertController(title: titlee as String, message: messagee as String, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title : "Ok", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            // male is Selected
        }))
        self.present(alertController, animated: true, completion: nil)
    } // end function
    
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
           // self.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }, completion: nil)
    }
    // MARK: - Text Field Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.locationTxtField ||  textField == self.specialityTxtField || textField == self.serviceTxtField
        {
          textField.resignFirstResponder()
            self.view.endEditing(true)
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if self.isSpeciality == true
        {
            return self.specialityInfoArr.count
        }
        else
        {
            return self.servisInfoArr.count
        }
    }
    
     /*  ApointmntSpeclityTbleCel Is using  ReuseableCell */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let celll = tableView.dequeueReusableCell(withIdentifier: "ApointmntSpeclityTbleCel")  as! ApointmntSpeclityTbleCel
        //celll.specialityLable.text =
        if self.isSpeciality == true
        {
            celll.specialityLable.text = self.specialityInfoArr[indexPath.row].name
            print (self.specialityInfoArr[indexPath.row])
        }
        else
        {
            let services = self.servisInfoArr[indexPath.row] as! ProfessionalServices
            //celll.specialityLable.text = specialityDict.value(forKey: "name") as? String
            celll.specialityLable.text = services.name
        }
        celll.cellBackGroundImg.image = UIImage(named: "apontmntTxtfild")
        celll.selectionStyle = .none
        
     //celll.ap
        return celll
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedCell = self.specialityServisTable.cellForRow(at: indexPath) as! ApointmntSpeclityTbleCel
        selectedCell.cellBackGroundImg.image = UIImage(named: "smallcellBackround")
        if self.isSpeciality == true
        {
          self.specialityTxtField.text = self.specialityInfoArr[indexPath.row].name
        }
        else
        {
            let services = self.servisInfoArr[indexPath.row] as! ProfessionalServices
            self.serviceTxtField.text = services.name
        }
        UIView.animate(withDuration: 0.5) {
            self.specialityServisLargeView.alpha = 0
             self.scrollView.backgroundColor = UIColor.clear
            self.applyView.backgroundColor = UIColor(red:0.94, green:0.86, blue:1.00, alpha:1.0)
        }
         self.isServisLargeViewShowing = false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 36
    }
    
    
}// end class
