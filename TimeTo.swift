//
//  TimeTo.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 2/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//
//  Calculates time remaining till end of event based on provided time, and handles output notifcation strings.
//

import Foundation
import EventKit
import Cocoa

var Notify = HLLNotification()

class TimeTo: NSObject {
var timeTo = 0
var output = ""
var name = ""
var endTime = NSDate()
    var upNextName: String?
var eventOn = false
let calendar = Calendar()
var L1 = ""
var L2 = ""
    
    
   
    func run() {
        if calAccess == true {
        
        if eventOn == true {
            let now = Date()

            let dif = CFDateGetTimeIntervalSinceDate(endTime as CFDate, now as CFDate)
            timeTo = Int(dif) / 60
            timeTo += 1
            
            print(timeTo)
            
        if timeTo == 1 {
            L1 = "\(name) ends in 1 minute."
        } else {
            L1 = "\(name) ends in \(timeTo) minutes."
        }
            
            if upNextName == nil {
              L2 = "You have no more upcoming events today."
            } else {
                L2 = "You have \(upNextName!) next."
            }
        
    
        } else {
            L1 = "No running event found in your calendar."
            L2 = ""
        }
        
        } else {
            L2 = "Enable it in System Preferences."
            L1 = "How Long Left does not have calendar access."
        }
        Notify.sendNotification(firstLine: L1, secondLine: L2)
        
        }
    
        
}
