//
//  customTextField.swift
//  ImagePicker
//
//  Created by Hugo Zhang on 12/30/17.
//  Copyright © 2017 Hugo Zhang. All rights reserved.
//

import UIKit

class customTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
