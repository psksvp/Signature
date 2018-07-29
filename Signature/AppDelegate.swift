//
//  AppDelegate.swift
//  Signature
//
//  Created by psksvp on 18/7/18.
//  Copyright © 2018 psksvp.Robotvision2. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var outputTextField: NSTextField!
  @IBOutlet weak var fileDropTextField: FileDropTextField!
  @IBOutlet weak var algorithmsSelector: NSComboBox!
  
  let digests = ["gost-mac","md4",
                  "md5","md_gost94","ripemd160","sha",
                  "sha1",
                  "sha224",
                  "sha256",
                  "sha384",
                  "sha512",
                  "streebog256",
                  "streebog512",
                  "whirlpool"]
  
  func applicationDidFinishLaunching(_ aNotification: Notification)
  {
    // Insert code here to initialize your application
    outputTextField.isEditable = false
    fileDropTextField.stringValue = "Drop a file here"
    algorithmsSelector.removeAllItems()
    algorithmsSelector.addItems(withObjectValues: digests)
    algorithmsSelector.selectItem(at: 8)
  }

  func applicationWillTerminate(_ aNotification: Notification)
  {
    // Insert code here to tear down your application
  }

  @IBAction func algorithmSelected(_ sender: Any)
  {
    NSLog("algorithm selected :")
    NSLog(digests[algorithmsSelector.indexOfSelectedItem])
  }
  
  @IBAction func generateButtonPushed(_ sender: NSButton)
  {
    if self.fileDropTextField.stringValue == "Drop a file here"
    {
      self.outputTextField.stringValue = "No file dropped.."
      return
    }
  
    outputTextField.stringValue = ""
    let d = digests[algorithmsSelector.indexOfSelectedItem]
    do
    {
      try Spawn(args: ["/usr/bin/openssl", d, fileDropTextField.stringValue])
      {
        str in
        if let index = str.index(of:"=")
        {
          let r = d + str[index...]
          self.outputTextField.stringValue = self.outputTextField.stringValue + r
        }
      }
    }
    catch
    {
      self.outputTextField.stringValue = "Error spawning openssl process.."
    }
    
  }
}

