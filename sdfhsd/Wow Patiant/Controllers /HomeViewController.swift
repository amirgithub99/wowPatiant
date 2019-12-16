//
//  HomeViewController.swift
//  Wow Patient
//
//  Created by Amir on 02/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

enum SelectedContrller : Int {
    case ViewAppointments = 0
    case  MedicalChart
    case Tasks
    case Referrals
    case Profile
    case Wallet

}
class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var homeCollectionView : UICollectionView!
    
    var collectonLblArr = NSArray()
    var cellCenterImgSelctedArr = NSArray()
    var cellCenterImgUnSelctedArr = NSArray()

    var isCollectionReload = Bool()
    // MARK : - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let height = self.view.bounds.size.height
         var collectionWidth = Int(self.view.bounds.size.width - 40)
        if height < self.view.bounds.size.width  {
         collectionWidth = Int(self.view.bounds.size.height - 40)
        }
        
         //collectionWidth = Int(self.view.bounds.size.width - 40)
        let defultt = UserDefaults.standard
        
        
        
        defultt.set(collectionWidth, forKey: "collectionWidth")
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
   {
     if self.isCollectionReload == false
     {
        self.collectonLblArr = ["View Appointments", "Medical Chart", "Tasks", "Referrals", "Profile", "Wallet"]
        self.cellCenterImgUnSelctedArr = ["appointmentImg",  "medicalImg" , "taskImg", "referral" , "profileHomeImg", "walletImg"]
        self.cellCenterImgSelctedArr = ["appointmentImgSelected", "medicalSelected",
                                        "taskSelectedImg", "referalSelectedImg", "profileHomeImgSelct", "walletUnselectedImg"]
        let layOutt = self.homeCollectionView.collectionViewLayout as! HomeCollectionViewLayout
        layOutt.scrollDirection = .vertical
        layOutt.scrollDirection = .vertical
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        self.isCollectionReload = true
     }
     else
     {
        self.homeCollectionView.reloadData()
     }
    } // end
    override func viewDidAppear(_ animated: Bool)
    {
    }
      //MARK: - Collection Delegate Method
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let celll = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        celll.cellCenterImg.image = UIImage(named : self.cellCenterImgUnSelctedArr[indexPath.item] as! String)
        let userDefaultt = UserDefaults.standard
        var collectionWidth = userDefaultt.integer(forKey: "collectionWidth")

        collectionWidth = Int((collectionWidth)  / 2 )
        collectionWidth =  collectionWidth - 5
        let widthPlusEquHeightValue = 20
        let cellViewHeight = collectionWidth + widthPlusEquHeightValue
        celll.cellView.frame = CGRect(x: 0, y: 0, width: collectionWidth, height: cellViewHeight)
        celll.cellBckgroundImg.frame = CGRect(x: 1, y: 1, width: collectionWidth  - 2, height:cellViewHeight - 2)
        let cellCenterImgWidth = Int(CGFloat(collectionWidth - 20) * 0.40)
        let cellCenterImgHeight = cellCenterImgWidth + 0 //10
        let centerImgYaxisPostion = (Int((cellViewHeight - Int(cellCenterImgHeight)) / 2) ) - 10
        
        var centerImgXPositonPositon = Int((collectionWidth - Int(cellCenterImgWidth )) / 2 )
        centerImgXPositonPositon = centerImgXPositonPositon + 1 //5 - 4
        
        celll.cellCenterImg.frame = CGRect(x: centerImgXPositonPositon, y: centerImgYaxisPostion, width: cellCenterImgWidth, height: cellCenterImgHeight)
                let cellLblWidth = 100
        let celLblXposition = (collectionWidth - cellLblWidth) / 2
        let cellLblYpositon = centerImgYaxisPostion + cellCenterImgHeight + 10
        
         celll.cellTextView.frame = CGRect(x: celLblXposition, y: cellLblYpositon, width: cellLblWidth, height: Int(38))
        celll.cellTextView.font = UIFont(name: "Montserrat-Regular", size: 12.5)
        celll.cellTextView.text = self.collectonLblArr[indexPath.item] as? String
        //celll.cellTextView.textin
        celll.cellTextView.textContainerInset = UIEdgeInsetsMake(2, 0, 0, 0)
        celll.cellTextView.textAlignment = .center
        celll.cellTextView.isUserInteractionEnabled = false
        celll.cellBckgroundImg.image = UIImage(named: "homeCollectioncellUnselec")
      celll.cellTextView.textColor = UIColor.black
        return celll
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let selectedCell = self.homeCollectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        selectedCell.cellCenterImg.image =  UIImage(named : self.cellCenterImgSelctedArr[indexPath.item] as! String)
        selectedCell.cellBckgroundImg.image = UIImage(named: "homeCollectionCelSelected")
        selectedCell.cellTextView.textColor = UIColor.white
        self.goToSelectedController(selectedIndex: indexPath.item)
    }
    // MARK: - Go To SelectedController
    func goToSelectedController(selectedIndex :Int)
    {
        if selectedIndex > 1
        {
            return
        }
        var selectedTab : SelectedContrller
        selectedTab = SelectedContrller(rawValue: selectedIndex)!
        var goToSelectedController = UIViewController()
        switch selectedTab
        {
         case .ViewAppointments:
            goToSelectedController = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentViewController") as! AppointmentViewController
            break
         case .MedicalChart:
             goToSelectedController = self.storyboard?.instantiateViewController(withIdentifier: "MedicalChartController") as! MedicalChartController
            break
         case .Tasks:
            break
            
          case .Referrals:
            break
            
          case .Profile:
            break
         
          case .Wallet:
            break
        }
        
        
//        let goToAppointMententController = self.storyboard?.instantiateViewController(withIdentifier: "AppointmentViewController") as! AppointmentViewController
//        self.navigationController?.pushViewController(goToAppointMententController, animated: true)
//
//        let goToAppointMententController = self.storyboard?.instantiateViewController(withIdentifier: "MedicalChartController") as! MedicalChartController
        
        
        self.navigationController?.pushViewController(goToSelectedController, animated: true)
    }
    
}// Class End
