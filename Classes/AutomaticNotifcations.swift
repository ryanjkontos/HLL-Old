//
//  AutomaticNotifcations.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 15/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//
//  Figures out if a notification should be sent automatically, and also generates the "Done" notification.
//

import Foundation


class automaticNotifcation {
   
    func countdownNotification(timeRemaining: Int) -> Bool {
        
        
        var returnVal = false
        
        var setTimes = [Int]()
        
        
        if Int(defaults.string(forKey: "autoAlert10")!) == 1 {
            setTimes.append(10)
        }
        
        if Int(defaults.string(forKey: "autoAlert5")!) == 1 {
            setTimes.append(5)
        }
        
        if Int(defaults.string(forKey: "autoAlert1")!) == 1 {
            setTimes.append(1)
        }
        
        
        
        for autoTime in setTimes {
            if autoTime == timeRemaining {
              returnVal = true
            }
        }
        return returnVal
    }
    
    func sendDoneNotification() {
        
        if Int(defaults.string(forKey: "autoAlert0")!) == 1 {


        
    
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
}
