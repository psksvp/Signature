//
//  FileDropTextField.swift
//  Signature
//
//  Created by psksvp on 19/7/18.
//  Copyright © 2018 psksvp.Robotvision2. All rights reserved.
//

import Cocoa

class FileDropTextField: NSTextField
{
  override init(frame frameRect: NSRect)
  {
    super.init(frame: frameRect)
    registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
  }
  
  required init?(coder: NSCoder)
  {
    super.init(coder: coder)
    registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
  }
  
  override func draw(_ dirtyRect: NSRect)
  {
    super.draw(dirtyRect)
  }
  
  override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation
  {
    NSLog(sender.description)
    self.stringValue = "Yes...\nDrop it here"
    return .copy
  }
  
  override func draggingExited(_ sender: NSDraggingInfo?)
  {
    self.stringValue = "Drop a file here"
  }
  
  override func performDragOperation(_ sender: NSDraggingInfo) -> Bool
  {
    sender.draggingPasteboard()
          .readObjects(forClasses: [NSURL.self],
                          options: nil)?
          .forEach
          {
            // Do something with the file paths.
            if let url = $0 as? URL
            {
              print(url.path)
              self.stringValue = url.path
            }
          }
    
    return true
  }
   
  
  
    
}
