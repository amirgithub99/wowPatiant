
//  MedicalChartController.swift
//  Wow Patiant
//  Created by Amir on 02/05/2018.
//  Copyright © 2018 Amir. All rights reserved.

import UIKit

enum SelectedMedicalContrller : Int {
    case MedicalCondtions = 0
    case  MedicationAllergies
    case FamilySocialHistory
    case DischargeNote
    case TestResults
}
//["Medical Condtions", "Medication/Allergies", "Family/Social History", "Discharge Note", "Test Results"]

class MedicalChartController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout { 

    var collectonLblArr = NSArray()
    var cellCenterImgSelctedArr = NSArray()
    var cellCenterImgUnSelctedArr = NSArray()
    @IBOutlet weak var medicalChartCollectionView : UICollectionView!
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
        
        
//        
//        
//        let collectionWidth = Int(self.view.bounds.size.width - 40)
//        let defultt = UserDefaults.standard
//        defultt.set(collectionWidth, forKey: "collectionWidth")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if self.isCollectionReload == false
        {
            self.collectonLblArr = ["Medical Condtions", "Medication/Allergies", "Family/Social History", "Discharge Note", "Test Results"]
            self.cellCenterImgUnSelctedArr = ["medicalCondition",  "medicationAllergies" , "familySocial", "dischargeNote" , "testResult"]
            self.cellCenterImgSelctedArr = ["medicalConditionSelecte", "medicationAllergiesSelected","familySocialSelected", "dischargeNoteSelected", "testResultSelected"]
            let layOutt = self.medicalChartCollectionView.collectionViewLayout as! HomeCollectionViewLayout
            layOutt.scrollDirection = .vertical
            layOutt.scrollDirection = .vertical
            self.medicalChartCollectionView.delegate = self
            self.medicalChartCollectionView.dataSource = self
            self.isCollectionReload = true
        }
        else
        {
            self.medicalChartCollectionView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
    }
    @IBAction func goBackToHomeViewController(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    /**** HomeCollectionViewCell is Reusable *******/
    
    //MARK: - Collection Delegate Method
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
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
        let cellCenterImgHeight = cellCenterImgWidth + 0 //////////10
        let centerImgYaxisPostion = (Int((cellViewHeight - Int(cellCenterImgHeight)) / 2) ) - 10
        
        var centerImgXPositonPositon = Int((collectionWidth - Int(cellCenterImgWidth )) / 2 )
        centerImgXPositonPositon = centerImgXPositonPositon + 1 //5 - 4
        
        celll.cellCenterImg.frame = CGRect(x: centerImgXPositonPositon, y: centerImgYaxisPostion, width: cellCenterImgWidth, height: cellCenterImgHeight)
        //let cellLbHeight = 20
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
        let selectedCell = self.medicalChartCollectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        selectedCell.cellCenterImg.image =  UIImage(named : self.cellCenterImgSelctedArr[indexPath.item] as! String)
        selectedCell.cellBckgroundImg.image = UIImage(named: "homeCollectionCelSelected")
        selectedCell.cellTextView.textColor = UIColor.white
        self.goToSelectedController(selectedIndex: indexPath.item)
    }
    func goToSelectedController(selectedIndex :Int)
    {
        if selectedIndex > 1
        {
            return
        }
        var selectedTab : SelectedMedicalContrller
        selectedTab = SelectedMedicalContrller(rawValue: selectedIndex)!
        var goToSelectedController = UIViewController()
         switch selectedTab {
         case .MedicalCondtions:
            goToSelectedController = self.storyboard?.instantiateViewController(withIdentifier: "MedicalCondtionControler") as! MedicalCondtionControler
         break
         case .MedicationAllergies:
            goToSelectedController = self.storyboard?.instantiateViewController(withIdentifier: "MedicationAlergyControler") as! MedicationAlergyControler
         break
         case .FamilySocialHistory:
         break
         case .DischargeNote:
         break
         case .TestResults:
         break
         //default: break
         }
        self.navigationController?.pushViewController(goToSelectedController, animated: true)
    }
    
} // end class
