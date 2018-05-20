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
    
    @IBOutlet weak var autoAlert10: NSButton!
    @IBOutlet weak var autoAlert5: NSButton!
    @IBOutlet weak var autoAlert1: NSButton!
    @IBOutlet weak var autoAlert0: NSButton!
    
    @IBOutlet weak var optionWbutton: NSButton!
    @IBOutlet weak var commandTButton: NSButton!
    
    
    override func viewWillAppear() {
        
        let hotKeySetValue = (defaults.string(forKey: "setHotKey")!)
        if hotKeySetValue == "0" {
            optionWbutton.setNextState()
        } else {
            commandTButton.setNextState()
        }
        
        let tensetting = Int(defaults.string(forKey: "autoAlert10")!)!
        
        let fivesetting = Int(defaults.string(forKey: "autoAlert5")!)!
        
        let onesetting = Int(defaults.string(forKey: "autoAlert1")!)!
        
        let zerosetting = Int(defaults.string(forKey: "autoAlert0")!)!
        
        if tensetting == 0 {
            if autoAlert10.state.rawValue == 1 {
             autoAlert10.setNextState()
            }
        }
        
        if fivesetting == 0 {
            if autoAlert5.state.rawValue == 1 {
                autoAlert5.setNextState()
            }
        }
        
        if onesetting == 0 {
            if autoAlert1.state.rawValue == 1 {
                autoAlert1.setNextState()
            }
        }
        
        if zerosetting == 0 {
            if autoAlert0.state.rawValue == 1 {
                autoAlert0.setNextState()
            }
        }
        
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
    
    @IBAction func hotkeychange(_ sender: NSButton) {
        defaults.set(sender.identifier!, forKey: "setHotKey")
        print(sender.identifier!)
        NotificationCenter.default.post(name: Notification.Name("settingChanged"), object: nil)
        
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
    
    
    @IBAction func tenminbuttonclicked(_ sender: NSButton) {
        if sender.state.rawValue == 0 {
            print("Turning off:")
            switch sender.title {
            case "Has 10 minutes left":
             print("Has 10 minutes left")
            defaults.set(0, forKey: "autoAlert10")
            case "Has 5 minutes left":
              print("Has 5 minutes left")
                defaults.set(0, forKey: "autoAlert5")
            case "Has 1 minute left":
                print("Has 1 minute left")
                defaults.set(0, forKey: "autoAlert1")
            case "Finishes":
                print("Finishes")
                defaults.set(0, forKey: "autoAlert0")
            default:
                print("Not found")
            }
        } else {
            print("Turning on:")
            switch sender.title {
            case "Has 10 minutes left":
                print("Has 10 minutes left")
                defaults.set(1, forKey: "autoAlert10")
            case "Has 5 minutes left":
                print("Has 5 minutes left")
                defaults.set(1, forKey: "autoAlert5")
            case "Has 1 minute left":
                print("Has 1 minute left")
                defaults.set(1, forKey: "autoAlert1")
            case "Finishes":
                print("Finishes")
                defaults.set(1, forKey: "autoAlert0")
            default:
                print("Not found")
            }
        }
    }
}
