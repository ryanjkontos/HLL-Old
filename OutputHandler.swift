//
//  OutputHandler.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 10/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//
//  Generates output (Menu bar text, Triggered notifications). This file mostly just formats the text based on the raw data from functions in the Calendar class.
//

import Foundation

let calendar = Calendar()
let notify = HLLNotification()
var autoNoto = automaticNotifcation()
var menuText = ""
var menuTextMin = ""
var finalMenuText = ""
let autoNotify = automaticNotifcation()
var firstLine = ""
var secondLine = ""

class OutputHandler {

    
    func multiLineOutput() -> [String] {
        

        if calendar.getCalendarAccess() == true {
            let currentEventTitle = calendar.titleOfEvent(which: "Current")
            
            if currentEventTitle != nil {
              let minutesRemainingOfCurrentEvent = calendar.minutesRemainingOfCurrentEvent(formatForDisplay: true)
               firstLine = "\(currentEventTitle!) ends in \(minutesRemainingOfCurrentEvent!)."
                
               let minRNF = calendar.minutesRemainingOfCurrentEvent(formatForDisplay: false)!
            
                if minRNF == "1" {
                  menuText = "1 min"
                } else {
                    menuText = "\(minRNF) mins"
                }
                let nextName = calendar.titleOfEvent(which: "Next")
                if nextName == nil {
                  secondLine = "You have no more upcoming events."
                } else {
                  secondLine = "You have \(nextName!) next."
                }
            } else {
               firstLine = "No running event found in your calendar."
                secondLine = ""
                 menuText = ""
            }
        } else {
            // No calendar access
            firstLine = "How Long Left does not have calendar access."
             menuText = "No cal access"
            
        }
        return [firstLine, secondLine]
    }
    
    
    func outputMenuBar(isStartMin: Bool) -> String {
        
        
        if isStartMin == true {
            let date = Date()
            let calendar = NSCalendar.current
            let seconds = calendar.component(.second, from: date)
            print("Sec6: \(seconds)")
        }
        
        var finalNum = ""
        var currentE = ""
        
        if calendar.getCalendarAccess() == true {
            
            
            let currentEventTitle = calendar.titleOfEvent(which: "Current")
            if currentEventTitle != nil {
                let minRNF = calendar.minutesRemainingOfCurrentEvent(formatForDisplay: false)!
                finalNum = minRNF
                currentE = currentEventTitle!
                
                 let menuBarFormat = defaults.string(forKey: "menuBarFormat")
                
                if isStartMin == true {
                    if autoNoto.countdownNotification(timeRemaining: Int(minRNF)!) == true {
                        
                      NotificationCenter.default.post(name: Notification.Name("autoNotify"), object: nil)
                    }
                }
                
                if minRNF == "1" {
                    menuTextMin = "<1 min"
                    menuText = "<1 minute"
                    
                } else {
                    menuText = "\(minRNF) minutes"
                    menuTextMin = "\(minRNF) mins"
                }
                let nextName = calendar.titleOfEvent(which: "Current")
                
                switch menuBarFormat {
                case "10 mins":
                    finalMenuText = menuTextMin
                case "10 mins left":
                    finalMenuText = "\(menuTextMin) left"
                case "10 minutes left":
                    finalMenuText = "\(menuText) left"
                case "Name: 10 mins left":
                    finalMenuText = "\(nextName!): \(menuTextMin) left"
                default:
                    finalMenuText = menuTextMin
                }
                
            } else {
                finalMenuText = ""
                menuText = ""
                finalNum = ""
                outputArchive.eventName = ""
            }
        } else {
            menuText = "No cal access"
            
        }
        
        if outputArchive.currentMenuText == "1", isStartMin == true {
            finalMenuText = "Done"
            
            
            autoNotify.sendDoneNotification()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
             NotificationCenter.default.post(name: Notification.Name("settingChanged"), object: nil)
            }
        }
        
    outputArchive.currentMenuText = finalNum
    outputArchive.eventName = currentE
     
        if isStartMin == true {
            print("")
        }
        
        
    return finalMenuText
    }
    
    
    struct outputArchive {
        static var currentMenuText = ""
        static var eventName = ""
    }
}
