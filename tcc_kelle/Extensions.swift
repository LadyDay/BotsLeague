//
//  Extensions.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 21/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import Foundation
import SpriteKit

extension Dictionary {
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            do {
                let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions())
                    do {
                        let dictionary: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data,
                        options: NSJSONReadingOptions())
                        if let dictionary = dictionary as? Dictionary<String, AnyObject> {
                            return dictionary
                        } else {
                            print("Level file '\(filename)' is not valid JSON")
                            return nil
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        return nil
                    }
            } catch let error as NSError {
                print(error.localizedDescription)
                return nil
            }
        } else {
            print("Could not find level file: \(filename)")
            return nil
        }
    }
    
    static func loadGameData(filename: String) -> Dictionary<String, AnyObject>? {
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingString("/" + filename + ".plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource(filename, ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                //print("Bundle " + filename + ".plist file is --> \(resultDictionary?.description)")
                
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch let error as NSError {
                    print("Cannot copy file: \(error.localizedDescription)")
                }
                
                //try! fileManager.copyItemAtPath(bundlePath, toPath: path)
                print("copy")
            } else {
                print(filename + ".plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print(filename + ".plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Loaded " + filename + ".plist file is --> \(resultDictionary?.description)")
        let myDict = NSDictionary(contentsOfFile: path) as! Dictionary<String, AnyObject>
        if let dict: Dictionary<String, AnyObject> = myDict {
            //loading values
            return dict
        } else {
            print("WARNING: Couldn't create dictionary from " + filename + ".plist! Default values will be used!")
            return nil
        }
    }
    
    static func saveGameData(filename:String, key: String, object: AnyObject) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("/" + filename + ".plist")
        var dict: NSMutableDictionary =  NSMutableDictionary()
        
        dict.setDictionary(self.loadGameData(filename)!)
        //saving values
        
        dict.setObject(object, forKey: key)
        
        //writing to GameData.plist
        dict.writeToFile(path, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Saved " + filename + ".plist file is --> \(resultDictionary?.description)")
    }
}

extension SKTexture {
    static func returnNameTexture(texture: SKTexture) -> String {
        var string = texture.description.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        string[1].removeAtIndex(string[1].endIndex.predecessor())
        string[1].removeAtIndex(string[1].startIndex.advancedBy(0))
        print(string[1])
        return string[1]
    }
}

extension String {
    static func returnString(name: String) -> String {
        var string = name.componentsSeparatedByString("")
        //string[0].removeAtIndex(string[0].endIndex.predecessor())
        //string[0].removeAtIndex(string[0].startIndex.advancedBy(0))
        print(string[0])
        return string[0]
    }
}

