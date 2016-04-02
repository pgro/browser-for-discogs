//
//  JsonParser.swift
//  DiscogsBrowser
//
//  Created by Peter Großmann on 02.04.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import Foundation

protocol JsonParserDelegate {
    func didParseRelease(title: String?)
}

class JsonParser {
    
    init(delegate: JsonParserDelegate) {
        self.delegate = delegate
    }
    var delegate : JsonParserDelegate?
    

    func retrieveRelease() {
        let url = "https://api.discogs.com/releases/249504"
        let userAgent = "FooBarApp/3.0"
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                NSLog("no request for you :(")
                return
            }
            
            do {
                let object = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                guard let json = object as? NSDictionary else {
                    NSLog("couldn't parse json :(")
                    return
                }
                self.parseJson(json)
            } catch {
                NSLog("couldn't parse json :(")
            }
        }
        task.resume()
    }
    
    func parseJson(json: NSDictionary) {
        self.delegate?.didParseRelease(json["title"] as? String)
    }

}

