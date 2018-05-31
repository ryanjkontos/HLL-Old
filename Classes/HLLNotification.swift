//
//  Notification.swift
//  How Long Left?
//
//  Created by Ryan Kontos on 3/5/18.
//  Copyright © 2018 Ryan Kontos. All rights reserved.
//
//  Manages notification output.

import Foundation

class HLLNotification {
    
    var firstLine = ""
    var secondLine = ""
    func send() {
    let notification = NSUserNotification()
    notification.title = firstLine
    notification.informativeText = secondLine
    NSUserNotificationCenter.default.deliver(notification)
    }
}
