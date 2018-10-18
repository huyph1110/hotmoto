//
//  AttendanceViewController.swift
//  MotoPark
//
//  Created by Huy on 9/26/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import AlamofireImage

class AttendanceViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate {

    var park: Park?
    @IBOutlet weak var titileBarItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionCode.register(UINib(nibName: "AttendanceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        
        if let apark = park {
            let array = fetchMobies()
            arrayMobi = array.filter{$0.parkID == apark.id && $0.state == Mobi_State.checkin.rawValue}
            arrayMobiResult = arrayMobi
            titileBarItem.title = apark.name
        }
        
        newmobiVC.complete = {
            (mobile) -> Void in
            mobile.parkID = self.park?.id
            mobile.save()
            self.newmobiVC.dismiss()
            self.arrayMobi.insert(mobile, at: 0)
            self.arrayMobiResult.insert(mobile, at: 0)

            self.collectionCode.insertItems(at: [IndexPath(row: 0, section: 0)])
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func history(_ sender: Any) {
        let vc = HistoryViewController()
        vc.park = park
        self.present(vc) {
            
        }
    }
    var newmobiVC = NewMobiViewController()
    
    @IBAction func add(_ sender: Any) {
        self.presentLikePopup(newmobiVC) {
            
        }
    }
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionCode: UICollectionView!
    var arrayMobi = [Mobile]()
    var arrayMobiResult = [Mobile]()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMobiResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let mobile = arrayMobiResult[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AttendanceCollectionViewCell
        cell.lblCode.text = mobile.code
        if mobile.image != nil {
           
            cell.imvImage.image = UIImage.af_threadSafeImage(with: mobile.image!)

        }else {
            cell.imvImage.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mobile = arrayMobiResult[indexPath.row]
        let mobivc = EditMobiViewController()
        mobivc.mobi = mobile
        mobivc.park = park
        
        mobivc.saveComplete = {
            () -> Void in
            collectionView.reloadItems(at: [indexPath])
            mobivc.dismiss()
        }
        mobivc.delComplete = {
            () -> Void in
            self.arrayMobiResult.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            mobivc.dismiss()

        }
        self.presentLikePopup(mobivc) {
            
        }
        
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.length > 0 {
            arrayMobiResult = arrayMobi.filter{ ($0.code?.contains(searchText))!}
        }else {
            arrayMobiResult = arrayMobi
        }
        collectionCode.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
    }
}
