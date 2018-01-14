//
//  AlbumViewController.swift
//  ImagePicker
//
//  Created by Hugo Zhang on 11/10/17.
//  Copyright © 2017 Hugo Zhang. All rights reserved.
//

import UIKit
import Firebase
import StoreKit

class AlbumViewController : UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var albumArray = [String]()
    var imageName = "";
    var loadedImage = UIImage();
    var albumCovers = [String]()
    
    let PREMIUM_PRODUCT_ID   = "com.photolockr.premium"
    let UNLIMITED_PRODUCT_ID = "com.photolockr.unlimited"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Fetch IAP Products available
        fetchAvailableProducts()
        
        let databaseTemp = Database.database();
        let databaseTempRef = databaseTemp.reference()
        
//        let customImageBarButton = UIBarButtonItem(image: UIImage(named: "icons8-menu-filled-50.png")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(goToSettings))
//        navigationItem.leftBarButtonItem = customImageBarButton
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            //do nothing
            //nsuserdefaults already set before
            
            let plan = UserDefaults.standard.string(forKey: "plan")
            Constants.currentPlan = plan!
            print("BABU:  " + plan!)
            
            if plan == "free" {
                UserDefaults.standard.set("free", forKey: "plan") //setObject
                Constants.currentPlan = "free"
                
            }
            else if plan == "premium"
            {
                UserDefaults.standard.set("premium", forKey: "plan") //setObject
                Constants.currentPlan = "premium"
            }
            else if plan == "unlimited"
            {
                UserDefaults.standard.set("unlimited", forKey: "plan") //setObject
                Constants.currentPlan = "unlimited"
            }
            else
            {
                let userID = Auth.auth().currentUser?.uid
                var ref: DatabaseReference!
                ref = Database.database().reference()
                ref.child("users/" + userID! + "/plan").setValue("free")
                
                UserDefaults.standard.set("free", forKey: "plan") //setObject
                Constants.currentPlan = "free"
                
            }
            
        }
        else
        {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            let userID = Auth.auth().currentUser?.uid
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            

            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let plan = value?["plan"] as? String ?? ""
                
                if plan == "free" {
                    UserDefaults.standard.set("free", forKey: "plan") //setObject
                    Constants.currentPlan = "free"

                }
                else if plan == "premium"
                {
                    UserDefaults.standard.set("premium", forKey: "plan") //setObject
                    Constants.currentPlan = "premium"
                }
                else if plan == "unlimited"
                {
                    UserDefaults.standard.set("unlimited", forKey: "plan") //setObject
                    Constants.currentPlan = "unlimited"
                }
                else
                {
                    ref.child("users/" + userID! + "/plan").setValue("free")
                    UserDefaults.standard.set("free", forKey: "plan") //setObject
                    Constants.currentPlan = "free"

                }
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
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
        Constants.officialPhotoArray = []
        Constants.officialLinksArray = []
        Constants.currentAlbumTitle = cellLabel.text!

    }
    
    @IBAction func newAlbum(_ sender: Any) {
        if Constants.currentPlan == "free" {
            if albumArray.count >= 1 {
                // Need to upgrade plan for premium or unlimited data
                IAPBothOptions()
            }
            else {
                createAlbum()
            }
        }
        else if Constants.currentPlan == "premium" {
            if albumArray.count >= 3 {
                // Need to upgrade plan for unlimited data
                IAPUnlimitedOptionOnly()
            }
            else {
                createAlbum()
            }
        }
        else if Constants.currentPlan == "unlimited" {
            createAlbum()
        }
    }
    
    func createAlbum() {
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

    func IAPBothOptions() {
        let alert = UIAlertController(title: "Upgrade Plan Required", message: "You've run out of available albums! To continue creating new albums, please choose a plan upgrade. Premium offers a total of 3 albums and 25 photos per album. Unlimited offers unlimited albums and photos.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "$0.99 Premium Plan", style: .default, handler: { (action) in
            self.purchaseMyProduct(product: self.iapProducts[0])
        }))
        
        alert.addAction(UIAlertAction(title: "$1.99 Unlimited Plan", style: .default, handler: { (action) in
            self.purchaseMyProduct(product: self.iapProducts[1])
        }))
        
        alert.addAction(UIAlertAction(title: "Keep Using Free Plan", style: .destructive, handler: { (action) -> Void in }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func IAPUnlimitedOptionOnly() {
        let alert = UIAlertController(title: "Upgrade Plan Required", message: "You've run out of available albums! To continue creating new albums, please choose a plan upgrade or switch albums. Unlimited offers unlimited albums and photos.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "$1.99 Unlimited Plan", style: .default, handler: { (action) in
            self.purchaseMyProduct(product: self.iapProducts[1])
        }))
        
        alert.addAction(UIAlertAction(title: "Keep Using Premium Plan", style: .destructive, handler: { (action) -> Void in }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts()  {
        
        // Put here your IAP Products ID's
        var productIdentifiers = Set<String>()
        productIdentifiers.insert(PREMIUM_PRODUCT_ID)
        productIdentifiers.insert(UNLIMITED_PRODUCT_ID)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            
            print(iapProducts)
            
            for p in iapProducts {
                print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
            }
            
        }
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
            
            
            // IAP Purchases dsabled on the Device
        } else {
            
            let alert = UIAlertController(title: "Purchases Disabled", message: "Purchases are disabled on your device. Please enable in-app purchases and retry.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in })
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    // The Consumable product (10 coins) has been purchased -> gain 10 extra coins!
                    if productID == PREMIUM_PRODUCT_ID {
                        
                        let userID = Auth.auth().currentUser?.uid
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        ref.child("users/" + userID! + "/plan").setValue("premium")
                        
                        UserDefaults.standard.set("premium", forKey: "plan") //setObject
                        Constants.currentPlan = "premium"
                        
                        let alert = UIAlertController(title: "Purchase Successful", message: "You've successfully unlocked the Premium version! You now have access to 3 total albums and 25 photos per album. Thank you for supporting the developer.", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
                        alert.addAction(cancel)
                        present(alert, animated: true, completion: nil)
                        
                        // The Non-Consumable product (Premium) has been purchased!
                    } else if productID == UNLIMITED_PRODUCT_ID {
                        
                        let userID = Auth.auth().currentUser?.uid
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        ref.child("users/" + userID! + "/plan").setValue("unlimited")
                        
                        UserDefaults.standard.set("unlimited", forKey: "plan") //setObject
                        Constants.currentPlan = "unlimited"
                        
                        let alert = UIAlertController(title: "Purchase Successful", message: "You've successfully unlocked the Unlimited version! You now have access to unlimited albums and unlimited photos per album. Thank you for supporting the developer.", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
                        alert.addAction(cancel)
                        present(alert, animated: true, completion: nil)
                        
                    }
                    
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
