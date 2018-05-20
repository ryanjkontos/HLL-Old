//
//  WelcomeController.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 8/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//
//  Controls the Welcome window.
//

import EventKit
import LaunchAtLogin


let userData = UserDefaults.standard

class WelcomeWindow: NSWindowController {
    override func windowDidLoad() {
        window?.styleMask.remove(.resizable)
        NSApp.activate(ignoringOtherApps: true)
       

    }
    
    
    
    
}


class tabView: NSTabViewController {
    
    @IBOutlet weak var tabViewController: NSTabView!
    
    
    
    override func viewWillAppear() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.nav), name: Notification.Name("welcomeNavigate"), object: nil)
    }
    
    deinit {
    }

        
    @objc func nav(data: Notification) {
        
        let navTo = data.object!
        tabViewController.selectTabViewItem(at: navTo as! Int)
        
        
    }
    
    

   
    
    
}

class welcomeNav: NSViewController {
    
    func navTo(page: Int) {
        NotificationCenter.default.post(name: Notification.Name("welcomeNavigate"), object: page)
    }
    
    
}


class Welcome_Whatsnew: welcomeNav {
   
    @IBAction func back(_ sender: Any) {
        navTo(page: 0)
    }
    
}

class Welcome_WelcometoHowLongLeft: welcomeNav {
    
    @IBAction func whatsnewbutton(_ sender: NSButton) {
        navTo(page: 7)
    }
    
    // 1
    
    @IBAction func next(_ sender: Any) {
        navTo(page: 1)
    }
}

class Welcome_LetsGetStarted: welcomeNav {
    
    // 2
    
    @IBAction func back(_ sender: NSButton) {
        navTo(page: 0)
    }
    
        
    @IBAction func next(_ sender: Any) {
        navTo(page: 3)
    }
}

class Welcome_CalendarAccess: welcomeNav {
    @IBOutlet weak var nextbuttonitem: NSButton!
    
    @IBAction func back(_ sender: Any) {
        navTo(page: 1)
    }
    
    @IBAction func next(_ sender: Any) {
        navTo(page: 4)
    }
    
    @IBAction func shortcut(_ sender: NSButton) {
      nextbuttonitem.isEnabled = true
      defaults.set(sender.identifier!, forKey: "setHotKey")
        print(sender.identifier!)
    }
    
    
}
    
    class Welcome_Calendars: welcomeNav {
        
        @IBAction func back(_ sender: NSButton) {
            navTo(page: 2)
        }
        @IBAction func next(_ sender: Any) {
            navTo(page: 5)
        }
        
        @IBOutlet weak var calendarsUseAll: NSButton!
        @IBOutlet weak var calendarsSelectPopUp: NSPopUpButton!
       
        override func viewWillAppear() {
            
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
        }
        
        
        
        
}

class Welcome_Preferences: welcomeNav {
    
    // 5
    
    @IBAction func back(_ sender: NSButton) {
        navTo(page: 4)
    }
    
    @IBAction func next(_ sender: Any) {
        navTo(page: 6)
    }
    
    @IBOutlet weak var WelcomePrefsLaunchAtLogin: NSButton!
    @IBOutlet weak var WelcomePrefsShowNext: NSButton!
    @IBOutlet weak var WelcomePrefsMenuBar: NSPopUpButton!
    
    override func viewWillAppear() {
        
        defaults.set(WelcomePrefsMenuBar.selectedItem?.title, forKey: "menuBarFormat")
        if LaunchAtLogin.isEnabled == true {
            if WelcomePrefsLaunchAtLogin.state.rawValue == 0 {
                WelcomePrefsLaunchAtLogin.setNextState()
            }
        } else {
            if WelcomePrefsLaunchAtLogin.state.rawValue == 1 {
               WelcomePrefsLaunchAtLogin.setNextState()
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
    
    @IBAction func showNextChanged(_ sender: Any) {
        if WelcomePrefsShowNext.state.rawValue == 1 {
            // Enable next
        } else {
            // Disable next
        }
    }
    
    @IBAction func menuBarFormatChanged(_ sender: NSPopUpButton) {
     defaults.set(WelcomePrefsMenuBar.selectedItem?.title, forKey: "menuBarFormat")
        NotificationCenter.default.post(name: Notification.Name("settingChanged"), object: nil)
    }
    
    
}

class Welcome_YoureAllSet: welcomeNav {
    @IBAction func back(_ sender: NSButton) {
        navTo(page: 5)
    }
    
    @IBAction func Done(_ sender: NSButton) {
        defaults.set("1.0b3", forKey: "setupComplete")
        NotificationCenter.default.post(name: Notification.Name("setupComplete"), object: nil)
      self.view.window?.close()
    }
    
    
    
    
}


