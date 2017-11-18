//
//  AlbumViewController.swift
//  ImagePicker
//
//  Created by Hugo Zhang on 11/10/17.
//  Copyright © 2017 Hugo Zhang. All rights reserved.
//

import UIKit
import Firebase

class AlbumViewController : UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var albumArray = [String]()
    var imageName = "";
    var loadedImage = UIImage();
    var albumCovers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let databaseTemp = Database.database();
        let databaseTempRef = databaseTemp.reference()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            //do nothing
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            let linksRef = databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links")
            let albumNumbers = linksRef.child("Albums")
            let linkRef = albumNumbers.child("Photos")
            let coverPhoto = linksRef.child("CoverPhotos")
            let coverPhotoChild = coverPhoto.child("Photos")
            linkRef.setValue("Photos")
            coverPhotoChild.setValue("default")
        }
        
        //NEED TO ADD FOLDER VALUES FROM STORAGE TO ARRAY AND RELOAD DATA
        print("okonwko lolol")
        print(String(describing: databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links/Albums")))
        databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links/Albums").observeSingleEvent(of: .value, with: { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                print(rest)
                let folderName = String(describing: rest.value!)
                //print("ehyoooo " + downloadURL)
                print("so stupid " + folderName)
                self.albumArray.append(folderName)
                
            }
            self.collectionView.reloadData()
        })
        
       
        databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links/CoverPhotos").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
//                print("Rest key: " + rest.key + ", CellLabel Text: " + cellLabel.text!)
//                if rest.key == cellLabel.text! {
                    let downloadURL = String(describing: rest.value!)
                    //sets albumImage to coverphoto value link
                self.albumCovers.append(downloadURL)

//                }
            }
        })
        print("hey   " + String(describing: self.albumCovers))

        
        
        //
        //SETS THE SPACING OF 2 CELLS PER ROW SOSO SEXY
        //
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let widthScreen = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25) //TOP AND BOTTOM ARE ONLY AT THE TOP AND BOTTOM OF CONTAINERRRRRR NOT EACH INDIVIDUAL PHOTO OHHHHHHHHHH
        layout.itemSize = CGSize(width: (widthScreen - 75) / 2, height: ((widthScreen - 75) / 2 ) + 30)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 25 //Y SPACING BETWEEN EACH INDIVIDUAL PHOTO
        collectionView!.collectionViewLayout = layout
    }
    
    func getDatafromDatabase(completion: @escaping () -> ()) {
        // Code for getTheSearchLocationAndRange()
        let databaseTemp = Database.database();
        let databaseTempRef = databaseTemp.reference()
        databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links/CoverPhotos").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                //                print("Rest key: " + rest.key + ", CellLabel Text: " + cellLabel.text!)
                //                if rest.key == cellLabel.text! {
                let downloadURL = String(describing: rest.value!)
                //sets albumImage to coverphoto value link
                self.albumCovers.append(downloadURL)
                //self.collectionView!.reloadData()
                //                }
            }
            completion()
        })
        //loadDataFromDatabase()
    }
    
    func loadDataFromDatabase(){
        // Code for loadDataFromDatabase()
        Constants.needsToReload = false
    }
    
    
    // NEED TO FIGURE OUT HOW TO CALL COLLECTION VIEW AFETR ASYNC METHOD
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("appearing")
        if Constants.needsToReload == true {
            
            self.albumCovers = []
            getDatafromDatabase() {
                self.collectionView.reloadData()
                Constants.needsToReload = false
                //print("dick in my mouth")
            }
        }
        //self.collectionView!.reloadData()
    }
    
    //
    //UPDATES AND SETS THE CELL PROPERTIES
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let album = collectionView.dequeueReusableCell(withReuseIdentifier: "album", for: indexPath) as UICollectionViewCell
//        print("eeeee")
//        let databaseTemp = Database.database();
//        let databaseTempRef = databaseTemp.reference()
//        print("hoessterfour")
//        databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links/" + albumArray[indexPath.row] + "_links").observeSingleEvent(of: .value, with: { (snapshot) in
//            for rest in snapshot.children.allObjects as! [DataSnapshot] {
//                
//                self.imageName = String(describing: rest.value!)
//                //print("ehyoooo " + downloadURL)
//                print("gigger " + self.imageName)
//                break;
//                
//            }
//        })
//        
//        let storage = Storage.storage().reference(forURL: self.imageName)
//        
//        print("qwertyuiop" + self.imageName)
//
//        // Download the data, assuming a max size of 1MB (you can change this as necessary)
//        storage.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
//            // Create a UIImage, add it to the array
//            print("cuzcuz")
//            if let error = error {
//                print(error)
//            } else {
//                //print(self.imageCount)
//                self.loadedImage = UIImage(data: data!)!
//                //print(self.photoArray)
//                print("what the fuck")
//            }
//            
//        }
//        
//        print(self.imageName + "yimyyum")
//        
//        let cellImage = album.viewWithTag(1) as! UIImageView
//        cellImage.image = self.loadedImage
        let cellImage = album.viewWithTag(1) as! UIImageView
        
        
        let cellLabel = album.viewWithTag(2) as! UILabel
        cellLabel.text = albumArray[indexPath.row]
    
        
//        let pleaseWork = Database.database().reference().child("images_" + (Auth.auth().currentUser?.uid)! + "_links/Albums")
//        pleaseWork.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            for rest in snapshot.children.allObjects as! [DataSnapshot] {
//                print("Rest key: " + rest.key + ", CellLabel Text: " + cellLabel.text!)
//                if rest.key == cellLabel.text! {
//                      let downloadURL = String(describing: rest.value!)
//                      //sets albumImage to coverphoto value link
//                      print("yarpoooooo")
//                      albumImage = downloadURL
//                      print("gucci gang " + albumImage)
//                  }
//            }
//        })
        
        let albumImage = self.albumCovers[indexPath.row]
        
        if albumImage == "default" {
            print("goddam")
            cellImage.image = #imageLiteral(resourceName: "default.png")
        }
        else {
            //set album image to cover photo value from link in database at cover photo child
            
            let imageURL = albumImage

            
            let storage = Storage.storage().reference(forURL: imageURL)
            
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storage.getData(maxSize: 10 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                if let error = error {
                    print(error)
                } else {
                    let loadedImage = UIImage(data: data!)
                    cellImage.image = loadedImage
                }
                
            }
            
        }
        return album
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = self.collectionView?.cellForItem(at: indexPath)
        print(String(describing: indexPath))
        print("mutiny")
        let cellLabel = cell?.viewWithTag(2) as! UILabel
        
        print(cellLabel.text!)
        Constants.currentAlbumTitle = cellLabel.text!

    }
    
    @IBAction func newAlbum(_ sender: Any) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "New Album", message: "Enter a name for this album.", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (action) -> Void in
            let textField = alert!.textFields![0]
            print("Text field: \(String(describing: textField.text!))")
            self.albumArray.append(textField.text!)
            
            //add album folders to database
            let databaseTemp = Database.database();
            let databaseTempRef = databaseTemp.reference()
            let linksRef = databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links")
            let albumNumbers = linksRef.child("Albums")
            let coverPhoto = linksRef.child("CoverPhotos")
            let coverPhotoChild = coverPhoto.child(textField.text!)
            let linkRef = albumNumbers.child(textField.text!)
            linkRef.setValue(textField.text!)
            coverPhotoChild.setValue("default")
            self.albumCovers.append("default")
            
            self.collectionView.reloadData()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
