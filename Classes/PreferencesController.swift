//
//  PreferencesController.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 4/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//
//  Controls the Preferences window.
//

import Foundation
import AppKit
import EventKit
import Cocoa
import LaunchAtLogin


let defaults = UserDefaults.standard

var cal = Calendar()
var menuBar = StatusMenuController()

class Preferences: NSWindowController {
    override func windowDidLoad() {
        window?.styleMask.remove(.resizable)
    }
}


class Prefs: NSViewController {
    
    @IBOutlet weak var WelcomePrefsLaunchAtLogin: NSButton!
    @IBOutlet weak var calendarsUseAll: NSButton!
    @IBOutlet weak var calendarsSelectPopUp: NSPopUpButton!
    @IBOutlet weak var WelcomePrefsMenuBar: NSPopUpButton!
    
    override func viewWillAppear() {
        
        let menuBarFormat = defaults.string(forKey: "menuBarFormat")
        
        for items in WelcomePrefsMenuBar.itemArray {
            if items.title == menuBarFormat {
                WelcomePrefsMenuBar.selectItem(withTitle: items.title)
            }
        }
        NSApp.activate(ignoringOtherApps: true)
        
        if LaunchAtLogin.isEnabled == true {
            if WelcomePrefsLaunchAtLogin.state.rawValue == 0 {
                WelcomePrefsLaunchAtLogin.setNextState()
            }
        } else {
            if WelcomePrefsLaunchAtLogin.state.rawValue == 1 {
                WelcomePrefsLaunchAtLogin.setNextState()
            }
        }
        
        
        
        
        let setCal = defaults.string(forKey: "Calendar")
        let calsArray = cal.getCalendars()
    
        for item in calsArray {
            calendarsSelectPopUp.addItem(withTitle: (item?.title)!)
        }
        
        if setCal == nil {
            
            
            calendarsSelectPopUp.isEnabled = false
            defaults.set("HLL_AllCals", forKey: "Calendar")
            if calendarsUseAll.state.rawValue == 0 {
                calendarsUseAll.setNextState()
            }
            
            
        } else {
            
            if setCal! == "HLL_AllCals" {
                calendarsSelectPopUp.isEnabled = false
                if calendarsUseAll.state.rawValue == 0 {
                    calendarsUseAll.setNextState()
                }
            } else {
                if calendarsUseAll.state.rawValue == 1 {
                    calendarsUseAll.setNextState()
                }
                calendarsSelectPopUp.selectItem(withTitle: setCal!)
            }
            
            
            
        }
    }
    
    @IBAction func launchAtLoginChanged(_ sender: NSButton) {
        if WelcomePrefsLaunchAtLogin.state.rawValue == 1 {
            LaunchAtLogin.isEnabled = true
        } else {
            LaunchAtLogin.isEnabled = false
        }
        
    }
    
    @IBAction func calendarsUseAllChanged(_ sender: NSButton) {
        if calendarsUseAll.state.rawValue == 1 {
            calendarsSelectPopUp.isEnabled = false
            defaults.set("HLL_AllCals", forKey: "Calendar")
        } else {
            calendarsSelectPopUp.isEnabled = true
            if calendarsSelectPopUp.selectedItem != nil {
                defaults.set(calendarsSelectPopUp.selectedItem!.title, forKey: "Calendar")
            }
        }
    }
    
    @IBAction func popUpCalSelectChanged(_ sender: NSPopUpButton) {
        defaults.set(calendarsSelectPopUp.selectedItem!.title, forKey: "Calendar")
        NotificationCenter.default.post(name: Notification.Name("settingChanged"), object: nil)
    }
    
    @IBAction func menuBarFormatChanged(_ sender: NSPopUpButton) {
        defaults.set(WelcomePrefsMenuBar.selectedItem?.title, forKey: "menuBarFormat")
        NotificationCenter.default.post(name: Notification.Name("settingChanged"), object: nil)
    }
    
    @IBAction func prefsDone(_ sender: NSButton) {
        self.view.window?.close()
        
    }
    
    
}
