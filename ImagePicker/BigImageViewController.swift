//
//  BigImageViewController.swift
//  ImagePicker
//
//  Created by Hugo Zhang on 10/15/17.
//  Copyright © 2017 Hugo Zhang. All rights reserved.
//

import UIKit
import Firebase

class BigImageViewController : UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var bigImage: UIImageView!
    var imageLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(Constants.currentButtonNumber) + " of " + String(Constants.officialPhotoArray.count)
        navigationController?.hidesBarsOnTap = true
        
        bigImage.image = Constants.officialPhotoArray[Constants.currentButtonNumber - 1]
        imageLink = Constants.officialLinksArray[Constants.currentButtonNumber - 1]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false

    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    @IBAction func clickedShare(_ sender: Any) {
        let shareSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        shareSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            UIImageWriteToSavedPhotosAlbum(Constants.officialPhotoArray[Constants.currentButtonNumber-1], nil, nil, nil)
            
            
        }))
        
        shareSheet.addAction(UIAlertAction(title: "Set as Album Cover", style: .default, handler: { (action: UIAlertAction) in
            let databaseTemp = Database.database();
            let databaseTempRef = databaseTemp.reference()
            let linksRef = databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links/CoverPhotos")
            let coverPhoto = linksRef.child(Constants.currentAlbumTitle)
            coverPhoto.setValue(self.imageLink)
            Constants.needsToReload = true
        }))
        
        
        shareSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(shareSheet, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
