//
//  AppDelegate.swift
//  Signature
//
//  Created by psksvp on 18/7/18.
//  Copyright © 2018 psksvp.Robotvision2. All rights reserved.
//

import Cocoa
import CommonSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var outputTextField: NSTextField!
  @IBOutlet weak var fileDropTextField: FileDropTextField!
  @IBOutlet weak var algorithmsSelector: NSComboBox!
  @IBOutlet weak var matchTextField: NSTextField!
  
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
    generateButtonPushed(sender)
  }
  
  @IBAction func generateButtonPushed(_ sender: Any)
  {
    NSLog("button pushed")
    if self.fileDropTextField.stringValue == "Drop a file here"
    {
      self.outputTextField.stringValue = "No file dropped.."
      return
    }
  
    let d = digests[algorithmsSelector.indexOfSelectedItem]
    let args = ["/usr/bin/openssl", d, fileDropTextField.stringValue]
    outputTextField.stringValue = "Running openssl..\n\(args.debugDescription)"
    OS.spawnAsync(args, nil)
    {
      stdout, stderr in
      DispatchQueue.main.async
      {
        self.outputTextField.stringValue = ""
        if let index = stdout.index(of:"=")
        {
          let r = (d + stdout[index...]).trim()
          let s = self.digests[self.algorithmsSelector.indexOfSelectedItem] + "= " +
          self.matchTextField.stringValue.trim()
          self.outputTextField.stringValue = self.outputTextField.stringValue + r
          if r == s
          {
            self.outputTextField.stringValue = self.outputTextField.stringValue + "\n" + "Match"
          }
          else
          {
            if !self.matchTextField.stringValue.isEmpty
            {
              self.outputTextField.stringValue = self.outputTextField.stringValue + "\n" + "NOT Match"
            }
          }
        }
        
        if false == stderr.trim().isEmpty
        {
          self.outputTextField.stringValue = "Errors:\n\(stderr)"
        }
      }
    }
  
    
//    do
//    {
//      try Spawn(args: ["/usr/bin/openssl", d, fileDropTextField.stringValue])
//      {
//        str in
//        if let index = str.index(of:"=")
//        {
//          let r = (d + str[index...]).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//          let s = self.digests[self.algorithmsSelector.indexOfSelectedItem] + "= " +
//                  self.matchTextField.stringValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//          NSLog(s)
//          NSLog(r)
//          self.outputTextField.stringValue = self.outputTextField.stringValue + r
//          if r == s
//          {
//            self.outputTextField.stringValue = self.outputTextField.stringValue + "\n" + "Match"
//          }
//          else
//          {
//            if !self.matchTextField.stringValue.isEmpty
//            {
//              self.outputTextField.stringValue = self.outputTextField.stringValue + "\n" + "NOT Match"
//            }
//          }
//        }
//      }
//    }
//    catch
//    {
//      self.outputTextField.stringValue = "Error spawning openssl process.."
//    }
    
  }
}

