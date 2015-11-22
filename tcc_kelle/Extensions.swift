//
//  Extensions.swift
//  tcc_kelle
//
//  Created by Dayane Kelly Rodrigues da Silva on 21/11/15.
//  Copyright © 2015 LadyDay. All rights reserved.
//

import Foundation

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
}
