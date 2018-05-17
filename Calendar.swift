//
//  Calendar.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 2/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//
// Reads the calendar, figures out which event today is the closest to finishing and outputs info to the calData struct. Also contains functions that return the data. (This file is a mess and I hate dealing with it.)
//

import Foundation
import EventKit

class Calendar {
    
   private struct calData {
        static var titleOfCurrentEvent: String?
        static var titleOfPreviousEvent: String?
        static var titleOfNextEvent: String?
        static var minutesRemainingOfCurrentEvent: Int?
        static var endTimeOfCurrentEvent: NSDate?
        static var appHasCalendarAccess = false
    
    }
    
    
    let MCHSData = MCHS()
    let returnString = ""
    var eventStore = EKEventStore()
    var selectedCalendar: [EKCalendar?] = []
    var calendarAccess = false
    var timesArray = [CFTimeInterval]()
    var namesArray = [String]()
    var eventsArray = [EKEvent]()
    var endTimesArray = [CFDate]()
    var events = [EKEvent]()
    
    func getCalendars() -> [EKCalendar?] {
        eventStore = EKEventStore()
        return eventStore.calendars(for: .event)
    }
    var appHasCalendarAccessVar = true
    
    func getCalendarAccess() -> Bool? {
        
       
        eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
            if granted == true {
                self.appHasCalendarAccessVar = true
            } else {
                self.appHasCalendarAccessVar = false
                print("Calendar access denied")
            }
            })
        calData.appHasCalendarAccess = self.appHasCalendarAccessVar
        return self.appHasCalendarAccessVar
        }
    
    func updateCalendarData() -> Bool {
        
        var returnVal = false
        
        eventStore = EKEventStore()
        eventsArray.removeAll()
        namesArray.removeAll()
        endTimesArray.removeAll()
        events.removeAll()
        timesArray.removeAll()
        eventStore = EKEventStore()
        

        let calendars = eventStore.calendars(for: .event)
        
        let defaults = UserDefaults.standard
        let cal = defaults.string(forKey: "Calendar")
        
        selectedCalendar.removeAll()
        
        if cal == "HLL_AllCals" {
            for item in calendars {
                selectedCalendar.append(item)
            }
        } else {
            for item in calendars {
                if item.title == cal {
                    selectedCalendar.append(item)
                }
            }
        }
        
        
        
        var comp: DateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: Date())
        comp.timeZone = TimeZone.current
        let startDate = NSCalendar.current.date(from: comp)!
        let endDate = startDate.addingTimeInterval(86400)
        
        let now = Date()
        
        let predicate = eventStore.predicateForEvents(withStart: startDate , end: endDate , calendars: selectedCalendar as? [EKCalendar])
        
        events = eventStore.events(matching: predicate)
        
        for item in events {
            let dif = CFDateGetTimeIntervalSinceDate(item.endDate! as CFDate, now as CFDate)
            if Int(dif) > 0, item.isAllDay == false {
            
            let dif2 = CFDateGetTimeIntervalSinceDate(item.startDate! as CFDate, now as CFDate)
                timesArray.append(dif)
                namesArray.append(item.title)
                eventsArray.append(item)
                endTimesArray.append(item.endDate! as CFDate)
                if Int(dif2) < 0 {
                }
                
            
            }
        }
        
        
        if timesArray.min() == nil {
            calData.titleOfPreviousEvent = calData.titleOfCurrentEvent
            calData.titleOfCurrentEvent = nil
            calData.endTimeOfCurrentEvent = nil
            calData.titleOfNextEvent = nil
           returnVal = false
        } else {
            
       let timeToSec = timesArray.min()!
        

        
        let timesIndex = timesArray.index(of: timeToSec)
            let nextIndex = timesIndex! + 1
            let currentEKEvent = eventsArray[timesIndex!]
            
            let difFromStart = Int(CFDateGetTimeIntervalSinceDate(currentEKEvent.startDate as CFDate, now as CFDate))
            
            print("DFS: \(difFromStart)")
            
            
            if difFromStart > 0 {
                print("Not started yet I guess?")
                calData.titleOfPreviousEvent = calData.titleOfCurrentEvent
                calData.titleOfCurrentEvent = nil
                calData.endTimeOfCurrentEvent = nil
                calData.titleOfNextEvent = nil
                returnVal = false
            } else {
            
            calData.endTimeOfCurrentEvent = endTimesArray[timesIndex!]
            
            
            let tempName = namesArray[timesIndex!]
            calData.titleOfPreviousEvent = calData.titleOfCurrentEvent
           calData.titleOfCurrentEvent = MCHSData.convertMagdaleneName(inputName: tempName)
            
            
            if namesArray.count-1 >= nextIndex {
              
                let tempNextName = namesArray[nextIndex]
                calData.titleOfNextEvent = MCHSData.convertMagdaleneName(inputName: tempNextName)
                
                if calData.titleOfCurrentEvent == calData.titleOfNextEvent {
                    calData.endTimeOfCurrentEvent = endTimesArray[nextIndex]
                    }
                    returnVal = true
                }
            }
        }
        
        return returnVal
    }
    
    func calAccessTrue() {
        Calendar.calData.appHasCalendarAccess = true
}
    
    // MARK: Return APIs which I kinda just tacked onto the old method of retreiving calendar data with the calData struct. Basically just functions that read calData and return the results.
    
    func titleOfEvent(which: String) -> String? {
        switch which {
        case "Current":
            return calData.titleOfCurrentEvent
        case "Next":
            return calData.titleOfNextEvent
        case "Previous":
            return calData.titleOfPreviousEvent
        default:
            return calData.titleOfCurrentEvent
        }
        
    }
    
    func minutesRemainingOfCurrentEvent(formatForDisplay: Bool) -> String? {
        var difstring: String?
        var dif: Int?
        let endTime = calData.endTimeOfCurrentEvent
        if endTime != nil {
            let now = Date()
            dif = Int(CFDateGetTimeIntervalSinceDate(endTime, now as CFDate?))
            dif = dif!/60
            dif = dif! + 1
            difstring = String(dif!)
            
            
            if formatForDisplay == true {
                if difstring == "1" {
                    difstring = "1 minute"
                } else {
                  difstring = "\(difstring!) minutes"
                }
            } else {
            }
            
        }

        
        return difstring
        
    }
    
    
    
  func isMenuBarInSync() -> Bool {
     let endTime = calData.endTimeOfCurrentEvent
    var returnVal: Bool
    var dif: Int?
    var difstring = ""
        if endTime != nil {
            let now = Date()
           dif = Int(CFDateGetTimeIntervalSinceDate(endTime, now as CFDate?))
            dif = dif!/60
            dif = dif! + 1
            difstring = String(dif!)
            
        }
    
    let currentMBT = OutputHandler.outputArchive.currentMenuText
    
        if difstring == currentMBT {
            returnVal = true
        } else {
            returnVal = false
            print("Menu Bar not in sync, correcting")
            
        }
    
    print("Calced: \(difstring)")
        print("Gotten: \(currentMBT)")
    
       return returnVal
    }
        func appHasCalendarAccess() -> Bool? {
            let _ = getCalendarAccess()
            return Calendar.calData.appHasCalendarAccess
        }
    
}
