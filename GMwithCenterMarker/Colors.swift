//
//  Colors.swift
//  GMwithCenterMarker
//
//  Created by Hamza on 18/07/2022.
//

import Foundation
import UIKit

func primaryColor() -> UIColor{
    return UIColor.init(hex: "#FFB500")
}


extension UIColor {
public convenience init(hex:String) {
var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    if ((cString.count) == 8) {
        r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        g =  CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        b = CGFloat((rgbValue & 0x0000FF)) / 255.0
        a = CGFloat((rgbValue & 0xFF000000)  >> 24) / 255.0
        
    }else if ((cString.count) == 6){
        r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        g =  CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        b = CGFloat((rgbValue & 0x0000FF)) / 255.0
        a =  CGFloat(1.0)
    }
    
    
    self.init(  red: r,
                green: g,
                blue: b,
                alpha: a
    )
} }

