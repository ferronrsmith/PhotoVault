//
//  ViewController.swift
//  ImagePicker
//
//  Created by Hugo Zhang on 10/14/17.
//  Copyright © 2017 Hugo Zhang. All rights reserved.
//

import UIKit

struct Constants {
    static var currentButtonNumber = 0
    static var officialPhotoArray = [UIImage]()
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var getStartedLabel: UILabel!
    
    var photoArray = [UIImage]()
    var buttonArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //
        //SETS THE SPACING OF 3 CELLS PER ROW SOSO SEXY
        //
        if Constants.officialPhotoArray.count != 0 {
            getStartedLabel.isHidden = true
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let widthScreen = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5) //TOP AND BOTTOM ARE ONLY AT THE TOP AND BOTTOM OF CONTAINERRRRRR NOT EACH INDIVIDUAL PHOTO OHHHHHHHHHH
        layout.itemSize = CGSize(width: (widthScreen - 10) / 3, height: (widthScreen - 10) / 3 )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2.5 //Y SPACING BETWEEN EACH INDIVIDUAL PHOTO
        collectionView!.collectionViewLayout = layout
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.hidesBarsOnTap = false
    }
    

    
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else {
                print("Camera access denied")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoArray.append(image)
        Constants.officialPhotoArray = photoArray
        buttonArray.append(photoArray.count)
        picker.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //
    //UPDATES AND SETS THE CELL PROPERTIES
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath) as UICollectionViewCell
        
        let cellImage = photo.viewWithTag(1) as! UIImageView
        cellImage.image = photoArray[indexPath.row]
        
        let cellButton = photo.viewWithTag(2) as! UIButton
        cellButton.setTitle(String(buttonArray[indexPath.row]), for: UIControlState.normal)
        cellButton.setTitleColor(UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.0), for: .normal)
        
        if Constants.officialPhotoArray.count != 0 {
            getStartedLabel.isHidden = true
        }
        
        return photo
    }
    
    //
    //OPEN BIG IMAGE WHEN BUTTON IS CLICKED IN GALLERY
    //
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        print(sender.currentTitle!)
        let buttonNum = Int(sender.currentTitle!)
        Constants.currentButtonNumber = buttonNum!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

