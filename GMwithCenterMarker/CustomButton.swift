//
//  CustomButton.swift
//  GMwithCenterMarker
//
//  Created by Hamza on 18/07/2022.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

       setup()
    }
    
    
    
    func setup(){
        self.layer.cornerRadius = 10 * appConstant.heightRatio
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1 * appConstant.heightRatio
        self.layer.shadowOpacity = 0.20
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.setTitleColor(UIColor.white, for: .normal)
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = false
        self.backgroundColor =  primaryColor()
    }
}
