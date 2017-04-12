//
//  AppDelegate.swift
//  LyricsX
//
//  Created by 邓翔 on 2017/2/4.
//  Copyright © 2017年 ddddxxx. All rights reserved.
//

import Cocoa
import ServiceManagement
import EasyPreference

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    static var shared: AppDelegate? {
        return NSApplication.shared().delegate as? AppDelegate
    }
    
    var statusItem: NSStatusItem!
    var menuBarLyrics: MenuBarLyrics!

    @IBOutlet weak var lyricsOffsetTextField: NSTextField!
    @IBOutlet weak var lyricsOffsetStepper: NSStepper!
    @IBOutlet weak var statusBarMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
        menuBarLyrics = MenuBarLyrics()
        
        statusItem.button?.image = #imageLiteral(resourceName: "status_bar_icon")
        statusItem.menu = statusBarMenu
        
        NSRunningApplication.runningApplications(withBundleIdentifier: LyricsXHelperIdentifier).forEach() { $0.terminate() }
        
        let controller = AppController.shared
        lyricsOffsetStepper.bind(NSValueBinding, to: controller, withKeyPath: "lyricsOffset", options: [NSContinuouslyUpdatesValueBindingOption: true])
        lyricsOffsetTextField.bind(NSValueBinding, to: controller, withKeyPath: "lyricsOffset", options: [NSContinuouslyUpdatesValueBindingOption: true])
        
        if Preference[LaunchAndQuitWithPlayer] {
            if !SMLoginItemSetEnabled(LyricsXHelperIdentifier as CFString, true) {
                print("Failed to enable login item")
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        UserDefaults.standard.synchronize()
        if Preference[LaunchAndQuitWithPlayer] {
            let url = Bundle.main.bundleURL.appendingPathComponent("Contents/Library/LoginItems/LyricsXHelper.app")
            NSWorkspace.shared().launchApplication(url.path)
        }
    }
    
    @IBAction func checkUpdateAction(_ sender: Any) {
        let url = URL(string: "https://github.com/XQS6LB3A/LyricsX/releases")!
        NSWorkspace.shared().open(url)
    }
    
}

