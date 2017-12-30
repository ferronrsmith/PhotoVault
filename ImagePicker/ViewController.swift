//
//  ViewController.swift
//  ImagePicker
//
//  Created by Hugo Zhang on 10/14/17.
//  Copyright © 2017 Hugo Zhang. All rights reserved.
//

import UIKit
import Firebase

struct Constants {
    static var currentButtonNumber = 0
    static var officialPhotoArray = [UIImage]()
    static var officialLinksArray = [String]()
    static var currentAlbumTitle = ""
    static var needsToReload = false
    
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var getStartedLabel: UILabel!
    
    var photoArray = [UIImage]()
    var linksArray = [String]()
    var buttonArray = [Int]()
    
    var imageCount = 0
    var pickers = UIImagePickerController()

    let dispatchQueue = DispatchQueue(label: "FIREBASE_GETDATA")
    let dispatchGroup  = DispatchGroup()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.title = Constants.currentAlbumTitle
//        let databaseTemp = Database.database();
//        let databaseTempRef = databaseTemp.reference()
//
//        databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links/" + Constants.currentAlbumTitle + "_links").observeSingleEvent(of: .value, with: { (snapshot) in
//            self.imageCount = Int(snapshot.childrenCount)
//            for rest in snapshot.children.allObjects as! [DataSnapshot] {
//
//                let downloadURL = String(describing: rest.value!)
//                //print("ehyoooo " + downloadURL)
//                self.linksArray.append(downloadURL)
//                Constants.officialLinksArray = self.linksArray
//                let storage = Storage.storage().reference(forURL: downloadURL)
//
//                // Download the data, assuming a max size of 1MB (you can change this as necessary)
//                storage.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
//                    // Create a UIImage, add it to the array
//                    if let error = error {
//                        print(error)
//                    } else {
//                        //print(self.imageCount)
//                        let loadedImage = UIImage(data: data!)
//                        self.photoArray.append(loadedImage!)
//                        Constants.officialPhotoArray = self.photoArray
//                        self.buttonArray.append(self.photoArray.count)
//                        self.collectionView.reloadData()
//                        //print(self.photoArray)
//
//                    }
//
//                }
//            }
//        })
        

        
        //Update collection view after deleting photo
        
        //self.collectionView.reloadData()
        

        
//        let linksTempRef = databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links")
//        let currentImageCountTempRef = linksTempRef.child("currentImageCount")
//
//        print("DatabaseTempRef Output: " + String(describing: databaseTempRef))
//        print("Output: " + String(describing: linksTempRef))
//        for var i in 0...self.imageCount {
//
//            let databaseTemp = Database.database();
//            let databaseTempRef = databaseTemp.reference()
//            let linksTempRef = databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links")
//            let downloadURL = linksTempRef.child("image" + String(i) + "_link").value
//
//
//            let storage = Storage.storage()
//            let storageRef = storage.reference(forURL: downloadURL)
//
//        }

        
//        while (self.isDownloading == true) {
//            // Get a reference to the storage service using the default Firebase App
//            let storage = Storage.storage()
//            // Create a storage reference from our storage service
//            let storageRef = storage.reference();
//            // Create a child reference
//            // imagesRef now points to "images"
//            // Create a reference to the file you want to download
//            let imageLoadRef = storageRef.child(("images_" + (Auth.auth().currentUser?.email)! + "_" + (Auth.auth().currentUser?.uid)!) + "/image" + String(self.imageCount) + ".png")
//
//
//            //print(String(describing: imageLoadRef))
//            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//            imageLoadRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//                print("test0")
//                if let error = error {
//                    print("test1")
//                    self.isDownloading = false
//                } else {
//                    print("test2")
//                    if data != nil{
//                        print("test3")
//                        let loadedImage = UIImage(data: data!)
//                        self.photoArray.append(loadedImage!)
//                        Constants.officialPhotoArray = self.photoArray
//                        self.buttonArray.append(self.photoArray.count)
//                        self.collectionView.reloadData()
//                        self.imageCount += 1
//                    } else {
//                        self.isDownloading = false
//                        print("test4 " + String(describing: imageLoadRef))
//                    }
//
//                }
//
//            }
//
//        }
        
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
        
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        self.present(alert, animated: true, completion: nil)
        
        loadCellsInOrder() {
            print("dickkkkkkkkkkkkkkkkkkkkkkkk")
    
            for link in Constants.officialLinksArray {
                let storage = Storage.storage().reference(forURL: link)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                self.dispatchQueue.async {
                    self.dispatchGroup.enter()
                    storage.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                        // Create a UIImage, add it to the array
                        if let error = error {
                            print(error)
                        } else {
                            //print(self.imageCount)
                            let loadedImage = UIImage(data: data!)
                            self.photoArray.append(loadedImage!)
                            Constants.officialPhotoArray = self.photoArray
                            self.buttonArray.append(self.photoArray.count)
                            self.collectionView.reloadData()
                            //print(self.photoArray)
                        }
                        self.dispatchGroup.leave()
                    }
                    _ = self.dispatchGroup.wait(timeout: .distantFuture)
                }
            }
            print("done done done")
//            alert.removeFromParentViewController()
        }
        


    }

    func loadCellsInOrder(completion: @escaping () -> ()) {
        
        let databaseTemp = Database.database();
        let databaseTempRef = databaseTemp.reference()
        
        print("kill me now " + Constants.currentAlbumTitle)
        print("ooogaloooooooo " + String(describing: Constants.officialLinksArray))
        print("smoooglooooooo " + String(describing: Constants.officialPhotoArray))

        databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links/" + Constants.currentAlbumTitle + "_links").observeSingleEvent(of: .value, with: { (snapshot) in
            self.imageCount = Int(snapshot.childrenCount)
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let downloadURL = String(describing: rest.value!)
                //print("ehyoooo " + downloadURL)
                self.linksArray.append(downloadURL)
                Constants.officialLinksArray = self.linksArray
                
            }
            completion()
        })
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
        var localPath = NSURL()
        pickers = picker
        if info[UIImagePickerControllerImageURL] != nil {
            let localPathTest = info[UIImagePickerControllerImageURL] as! NSURL
            localPath = localPathTest
        }
        else {            
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            print("1")
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            print("11")
            picker.dismiss(animated: true, completion: nil)
            self.present(imagePickerController, animated: true, completion: nil)
            print("111")
            return;
        }
        
        photoArray.append(image)
        Constants.officialPhotoArray = photoArray
        buttonArray.append(photoArray.count)
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        let database = Database.database()
        // Create a storage reference from our storage service
        let storageRef = storage.reference();
        let databaseRef = database.reference()
        // Create a child reference
        // imagesRef now points to "images"
        let imagesRef = storageRef.child("images_" + (Auth.auth().currentUser?.email)! + "_" + (Auth.auth().currentUser?.uid)!);
        let albumFolder = imagesRef.child(Constants.currentAlbumTitle)
        let linksRef = databaseRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links")
        
        // Create a reference to the file you want to upload
        var imageRef = Storage.storage().reference()
        if self.imageCount <= 9 {
            imageRef = albumFolder.child("image0" + String(imageCount) + ".png")
            
        } else if self.imageCount > 9 {
            
            imageRef = albumFolder.child("image" + String(imageCount) + ".png")
            
        }
        // Upload the file to the path user folder
        _ = imageRef.putFile(from: localPath as URL, metadata: nil) { metadata, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                print("ey")
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL()?.absoluteString
                let albumLinksFolder = linksRef.child(Constants.currentAlbumTitle + "_links")
                var linkRef = Database.database().reference();
                
                if self.imageCount <= 9 {
                    
                    linkRef = albumLinksFolder.child("image0" + String(self.imageCount) + "_link")
                    
                } else if self.imageCount > 9 {
                    
                    linkRef = albumLinksFolder.child("image" + String(self.imageCount) + "_link")
                    
                }
                
                self.imageCount += 1
                linkRef.setValue(downloadURL)
                self.linksArray.append(downloadURL!)
                Constants.officialLinksArray = self.linksArray
                print("yeyos")
                print("please end me");
                self.collectionView.reloadData();
                self.pickers.dismiss(animated: true, completion: nil)
            }
        }
        
        

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

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

