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
var PredictedMenuText = ""
var PredictedMenuTextMin = ""
var finalMenuText = ""
let autoNotify = automaticNotifcation()
var firstLine = ""
var secondLine = ""
var predictedNextMenuBarTextFinalString: String?

class OutputHandler {

    
    func multiLineOutput() -> [String] {
        

        if calendar.getCalendarAccess() == true {
            let currentEventTitle = calendar.titleOfEvent(which: "Current")
            
            if currentEventTitle != nil {
              let minutesRemainingOfCurrentEvent = calendar.minutesRemainingOfCurrentEvent(formatForDisplay: true)
               firstLine = "\(currentEventTitle!) ends in \(minutesRemainingOfCurrentEvent!)."
                let nextName = calendar.titleOfEvent(which: "Next")
                if nextName == nil {
                  secondLine = "No upcoming events."
                } else {
                    let nextLocation = calendar.locationOfEvent()
                    
                    if nextLocation != nil {
                      secondLine = "Next: \(nextName!). (\(nextLocation!))"
                    } else {
                      secondLine = "Next: \(nextName!)."
                    }
                }
            } else {
               firstLine = "No events are running right now."
                secondLine = ""
            }
        } else {
            // No calendar access
            firstLine = "How Long Left does not have calendar access."
            secondLine = "Please grant it in System Preferences."
        }
        return [firstLine, secondLine]
    }
    
    
    func outputMenuBar(isStartMin: Bool) -> String {
        
        
        var finalNum = ""
        var currentE = ""
        
        let menuBarFormat = defaults.string(forKey: "menuBarFormat")
        
        if calendar.getCalendarAccess() == true {
            
            
            let currentEventTitle = calendar.titleOfEvent(which: "Current")
            if currentEventTitle != nil {
                let minRNF = calendar.minutesRemainingOfCurrentEvent(formatForDisplay: false)!
                let predictedRemaining = Int(minRNF)! - 1
                finalNum = minRNF
                currentE = currentEventTitle!
                
                
                if isStartMin == true {
                    if autoNoto.countdownNotification(timeRemaining: Int(minRNF)!) == true {
                        
                      NotificationCenter.default.post(name: Notification.Name("autoNotify"), object: nil)
                    }
                }
                
                if minRNF == "1" {
                    menuTextMin = "<1 min"
                    menuText = "<1 minute"
                    
                    predictedNextMenuBarTextFinalString = nil
                    
                } else {
                    menuText = "\(minRNF) minutes"
                    menuTextMin = "\(minRNF) mins"
                    
                    PredictedMenuText = "\(predictedRemaining) minutes"
                    PredictedMenuTextMin = "\(predictedRemaining) mins"
                    
                    
                    
                }
                let nextName = calendar.titleOfEvent(which: "Current")
                
                switch menuBarFormat {
                case "10 mins":
                    finalMenuText = menuTextMin
                    predictedNextMenuBarTextFinalString = PredictedMenuTextMin
                case "10 mins left":
                    finalMenuText = "\(menuTextMin) left"
                    predictedNextMenuBarTextFinalString = "\(PredictedMenuTextMin) left"
                case "10 minutes left":
                    finalMenuText = "\(menuText) left"
                    predictedNextMenuBarTextFinalString = "\(PredictedMenuText) left"
                case "Name: 10 mins left":
                    finalMenuText = "\(nextName!): \(menuTextMin) left"
                case "Off":
                    finalMenuText = ""
                default:
                    finalMenuText = menuTextMin
                    predictedNextMenuBarTextFinalString = PredictedMenuTextMin
                }
                
            } else {
                predictedNextMenuBarTextFinalString = nil
                finalMenuText = ""
                menuText = ""
                finalNum = ""
                outputArchive.eventName = ""
            }
        } else {
            predictedNextMenuBarTextFinalString = nil
            finalMenuText = "No cal access"
            
        }
        
        if outputArchive.currentMenuText == "1", isStartMin == true {
            finalMenuText = "Done"
            autoNotify.sendDoneNotification()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
             NotificationCenter.default.post(name: Notification.Name("settingChanged"), object: nil)
                }
            }
    outputArchive.predictedMenuBarText = predictedNextMenuBarTextFinalString
    outputArchive.currentMenuText = finalNum
    outputArchive.eventName = currentE
     
        if isStartMin == true {
            print("")
        }
        
        if defaults.string(forKey: "menuBarFormat") == "Off", finalMenuText != "No cal access"  {
            finalMenuText = ""
        }
        return finalMenuText
    }
    
    
    struct outputArchive {
        static var currentMenuText = ""
        static var eventName = ""
        static var predictedMenuBarText: String?
    }
}
