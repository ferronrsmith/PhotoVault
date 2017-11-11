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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        let databaseTemp = Database.database();
        let databaseTempRef = databaseTemp.reference()
        let linksRef = databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links")
        let albumNumbers = linksRef.child("Albums")
        let linkRef = albumNumbers.child("Photos")
        linkRef.setValue("Photos")
        
        //NEED TO ADD FOLDER VALUES FROM STORAGE TO ARRAY AND RELOAD DATA

        databaseTempRef.child("images_" + (Auth.auth().currentUser?.uid)! + "_links/Albums").observeSingleEvent(of: .value, with: { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {

                let folderName = String(describing: rest.value!)
                //print("ehyoooo " + downloadURL)
                print(folderName)
                self.albumArray.append(folderName)
                
            }
            self.collectionView.reloadData()
        })
        
        //
        //SETS THE SPACING OF 2 CELLS PER ROW SOSO SEXY
        //
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let widthScreen = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25) //TOP AND BOTTOM ARE ONLY AT THE TOP AND BOTTOM OF CONTAINERRRRRR NOT EACH INDIVIDUAL PHOTO OHHHHHHHHHH
        layout.itemSize = CGSize(width: (widthScreen - 75) / 2, height: ((widthScreen - 75) / 2 ) + 50)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 25 //Y SPACING BETWEEN EACH INDIVIDUAL PHOTO
        collectionView!.collectionViewLayout = layout
    }
    
    //
    //UPDATES AND SETS THE CELL PROPERTIES
    //
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let album = collectionView.dequeueReusableCell(withReuseIdentifier: "album", for: indexPath) as UICollectionViewCell
        
        let cellLabel = album.viewWithTag(2) as! UILabel
        cellLabel.text = albumArray[indexPath.row]
        
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
            let linkRef = albumNumbers.child(textField.text!)
            linkRef.setValue(textField.text!)
            
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
