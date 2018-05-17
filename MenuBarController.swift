//
//  MenuBarController.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 2/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//
//  Manages the App Launch, Menu Bar, Triggering of output events, Responding to settings changes, Timers, and Launching windows... basically just too much stuff.
//
import Cocoa
import HotKey
import Carbon
//import Sparkle

class StatusMenuController: NSObject {
    
    var fastTimer: Timer!
    var timer = Timer()
    let outputhandler = OutputHandler()
    
    @IBOutlet weak var menuOutput1: NSMenuItem!
    
    
    @IBOutlet weak var menuOutput2: NSMenuItem!
    
    struct menuLines {
        static var menuLine1 = ""
        static var menuLine2 = ""
    }
    
    
    var hotKeyValue = String()
    var prefs = Preferences()
    
    private var hotKey: HotKey? {
        didSet {
            guard let hotKey = hotKey else {
                return
            }
            
            
            hotKey.keyDownHandler = { [weak self] in
                let _ = calendar.updateCalendarData()
                self?.doTimeToNotification()
                self?.routineMenuBarUpdate(isStart: false)
            }
        }
    }
    
    let calendardata = Calendar()
    var calAccess = false

    @IBOutlet weak var statusMenu: NSMenu!

    @IBAction func welcomeViewTest(_ sender: Any) {
        
        var welcomeWindowController : NSWindowController!
        let welcomeStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Welcome"), bundle: nil)
        welcomeWindowController = welcomeStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Welcome")) as! NSWindowController
        // make initial settings before showing the window
        welcomeWindowController.showWindow(self)
    }
    
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBAction func welcomeTest(_ sender: NSMenuItem) {
        var welcomeWindowController : NSWindowController!
        
        let welcomeStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Welcome"), bundle: nil)
        welcomeWindowController = welcomeStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Welcome")) as! NSWindowController
        // make initial settings before showing the window
        welcomeWindowController.showWindow(self)
    }
    
    
    
    @IBAction func PrefClicked(_ sender: NSMenuItem) {
        
    
        
        var windowController : NSWindowController!
        
        let mainStoryBoard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Preferences"), bundle: nil)
        windowController = mainStoryBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Prefs")) as! NSWindowController
        // make initial settings before showing the window
        windowController.showWindow(self) 
    }
    
    
    override func awakeFromNib() {
        
        let calAccessLaunch = calendardata.getCalendarAccess()
        if calAccessLaunch == false {
            notify.firstLine = "How Long Left does not have calendar access."
            notify.secondLine = "Enable it in System Preferences."
            notify.send()
        }
        
      /*  UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize() */
    
        let latestversion = (defaults.string(forKey: "setupComplete"))
        
        if latestversion == nil {
    
            
            var welcomeWindowController : NSWindowController!
            let welcomeStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Welcome"), bundle: nil)
            welcomeWindowController = welcomeStoryboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Welcome")) as! NSWindowController
            // make initial settings before showing the window
            welcomeWindowController.showWindow(self)
            NotificationCenter.default.addObserver(self, selector: #selector(self.launchApp), name: Notification.Name("setupComplete"), object: nil)
            
            
        } else {
        
            launchApp()
        
        }
    }
    
    
    @objc func launchApp() {
        defaults.set("1.0b1", forKey: "latestVersion")
        
        
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        hotKey = HotKey(keyCombo: KeyCombo(key: .w, modifiers: [.option]))
        
        
        
     /*   let date = Date()
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day, .hour, .minute], from: date)
        guard let minute = components.minute else { return }
        components.second = 0
        components.minute = minute + 1
        guard let nextMinute = calendar.date(from: components) else { return }
        let timer = Timer(fire: nextMinute, interval: 60, repeats: true) { [weak self] timer in
            self?.routineMenuBarUpdateStartMin() }
        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
        
        */
        
        routineMenuBarUpdate(isStart: false)
        
        
        
        fastTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(menuCheck), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSettings), name: Notification.Name("settingChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.autoNotify), name: Notification.Name("autoNotify"), object: nil)
        
    }
    
    @objc func updateMenuItems() {
        menuOutput1.title = menuLines.menuLine1
        menuOutput2.title = menuLines.menuLine2
    }
    
    @objc func autoNotify() {
        // Called by the 
       doTimeToNotification()
    }
    
    @objc func menuCheck() {
      
        let date = Date()
        let calendar = NSCalendar.current
        let seconds = calendar.component(.second, from: date)
        if seconds == 0 {
            routineMenuBarUpdate(isStart: true)
        } else if seconds != 0 {
            let inSync = calendardata.isMenuBarInSync()
            if inSync != true {
              routineMenuBarUpdate(isStart: false)
                
            }
        }
    }
    
    @objc func updateSettings() {
        print("1")
        routineMenuBarUpdate(isStart: false)
    }
    
    @IBAction func FUMB(_ sender: NSMenuItem) {
        routineMenuBarUpdate(isStart: false)
        print("4")
    }
    
    @objc func routineMenuBarUpdate(isStart: Bool) {
        
        if isStart == true {
        
        if OutputHandler.outputArchive.predictedMenuBarText != nil {
            let myString = OutputHandler.outputArchive.predictedMenuBarText!
            let myAttribute = [ NSAttributedStringKey.font: NSFont(name: "Helvetica Neue", size: 13.0)! ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            statusItem.attributedTitle = myAttrString
            
            }
        }
        
        let _ = calendar.updateCalendarData()
        
        let myString = outputhandler.outputMenuBar(isStartMin: isStart)
        
        let myAttribute = [ NSAttributedStringKey.font: NSFont(name: "Helvetica Neue", size: 13.0)! ]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        statusItem.attributedTitle = myAttrString
        menuBarItemUpdate()
    }
    
    @IBAction func run(_ sender: NSMenuItem) {
        routineMenuBarUpdate(isStart: false)
        doTimeToNotification()
    }
    
    func menuBarItemUpdate() {
        let outputArray = outputhandler.multiLineOutput()
        menuOutput1.title = outputArray[0]
        menuOutput2.title = outputArray[1]
        
        if outputArray[1] == "" {
            menuOutput2.isHidden = true
        } else {
            menuOutput2.isHidden = false
        }
        
    }
    
    func doTimeToNotification() {
        let outputArray = outputhandler.multiLineOutput()
        notify.firstLine = outputArray[0]
        notify.secondLine = outputArray[1]
        notify.send()
    }
    
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
