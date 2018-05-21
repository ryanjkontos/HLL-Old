//
//  MCHS.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 15/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//
//  Magdalene Catholic High School specific functions.
//

import Foundation

class MCHS {
    
    func magdaleneNameOf(inputName: String) -> String {
        var newName = inputName
        
        if inputName.range(of:"Pastoral Care") != nil {
            newName = "Homeroom"
        }
        
        if inputName.range(of:"Information Software Technology") != nil {
           newName = "IST"
        }
        
        if inputName.range(of:"SPORT:") != nil {
            newName = "Sport"
        }
        
        if inputName.range(of:"English") != nil {
            newName = "English"
        }
        
        if inputName.range(of:"Science") != nil {
            newName = "Science"
        }
        
        if inputName.range(of:"HSIE") != nil {
            newName = "History"
        }
        
        if inputName.range(of:"History") != nil {
            newName = "History"
        }
        
        if inputName.range(of:"Music") != nil {
            newName = "Music"
        }
        
        if inputName.range(of:"Design") != nil {
            newName = "DNT"
        }
        
        if inputName.range(of:"Design") != nil {
            newName = "DNT"
        }

        if inputName.range(of:"Maths") != nil {
            newName = "Mathematics"
        }
        
        if inputName.range(of:"PDHPE") != nil {
            newName = "PDHPE"
        }
        
        if inputName.range(of:"Geography Elective") != nil {
            newName = "GEL"
        }
        
        if inputName.range(of:"Religion") != nil {
            newName = "Religion"
        }
        
        return newName
    }
    
}
