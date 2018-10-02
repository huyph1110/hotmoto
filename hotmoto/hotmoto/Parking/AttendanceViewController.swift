//
//  AttendanceViewController.swift
//  MotoPark
//
//  Created by Huy on 9/26/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {


    override func viewDidLoad() {
        super.viewDidLoad()
        collectionCode.register(UINib(nibName: "AttendanceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        arrayMobi = fetchMobies()
        newmobiVC.complete = {
            (mobile) -> Void in
            mobile.save()
            self.newmobiVC.dismiss()
            self.arrayMobi.insert(mobile, at: 0)
            self.collectionCode.insertItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    @IBAction func history(_ sender: Any) {
    
    }
    var newmobiVC = NewMobiViewController()
    
    @IBAction func add(_ sender: Any) {
        self.presentLikePopup(newmobiVC) {
            
        }
    }
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var collectionCode: UICollectionView!
    var arrayMobi = [Mobile]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMobi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let mobile = arrayMobi[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AttendanceCollectionViewCell
        cell.lblCode.text = mobile.code
        if mobile.image != nil {
            cell.imvImage.image = UIImage(data: mobile.image!)

        }else {
            cell.imvImage.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mobile = arrayMobi[indexPath.row]
        let mobivc = EditMobiViewController()
        mobivc.mobi = mobile
        mobivc.saveComplete = {
            () -> Void in
            collectionView.reloadItems(at: [indexPath])
            mobivc.dismiss()
        }
        mobivc.delComplete = {
            () -> Void in
            self.arrayMobi.remove(at: indexPath.row)
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

    
    
}
