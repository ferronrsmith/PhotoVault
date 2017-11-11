//
//  BigImageViewController.swift
//  ImagePicker
//
//  Created by Hugo Zhang on 10/15/17.
//  Copyright © 2017 Hugo Zhang. All rights reserved.
//

import UIKit

class BigImageViewController : UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var bigImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(Constants.currentButtonNumber) + " of " + String(Constants.officialPhotoArray.count)
        navigationController?.hidesBarsOnTap = true
        
        bigImage.image = Constants.officialPhotoArray[Constants.currentButtonNumber - 1]
        
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
        
        shareSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
            
            //if let index = Constants.officialPhotoArray.index(of:Constants.officialPhotoArray[Constants.currentButtonNumber-1]) {
            //    Constants.officialPhotoArray.remove(at: index)
            //}
            
            
        }))
        
        shareSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(shareSheet, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
