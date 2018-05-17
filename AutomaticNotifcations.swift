//
//  AutomaticNotifcations.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 15/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//

import Foundation


class automaticNotifcation {
   
    func countdownNotification(timeRemaining: Int) -> Bool {
        var returnVal = false
        
        let autoNotifyTimes = [15, 5, 10, 1]
        
        for autoTime in autoNotifyTimes {
            if autoTime == timeRemaining {
              returnVal = true
            }
        }
        return returnVal
    }
    
    func sendDoneNotification() {
    
        // This function is called by the output handler to prepare and deliver a notification when an event has finished.
        
            notify.firstLine = "\(calendar.titleOfEvent(which: "Previous")!) is done."
        
        if calendar.titleOfEvent(which: "Current") == nil {
            notify.secondLine = "There are no events on now."
        } else {
            notify.secondLine = "\(calendar.titleOfEvent(which: "Current")!) is on now."
        }
        
        notify.send()
        
    }
    
    
}
