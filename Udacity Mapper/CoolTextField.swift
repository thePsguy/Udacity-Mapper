//
//  CoolTextField.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 13/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit

class CoolTextField: UITextField {

        
        let padding = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9);
    
        override func textRectForBounds(bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        override func editingRectForBounds(bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
}
