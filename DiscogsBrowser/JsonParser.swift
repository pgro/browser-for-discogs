//
//  JsonParser.swift
//  DiscogsBrowser
//
//  Created by Peter Großmann on 02.04.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import Foundation

protocol JsonParserDelegate {
    func didParseRelease(release: Release)
}

class JsonParser {
    
    init(delegate: JsonParserDelegate) {
        self.delegate = delegate
    }
    var delegate : JsonParserDelegate?
    

    func retrieveRelease() {
        let url = "https://api.discogs.com/releases/249504"
        let userAgent = "BrowserForDiscogs/0.1 +https://github.com/pgro/browser-for-discogs"
        
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
        let release = Release()
        release.title = json["title"] as? String
        release.artist = self.extractFirstArtist(json)
        release.releaseYear = self.extractYear(json)
        release.thumbnailUrl = json["thumb"] as? String
        self.delegate?.didParseRelease(release)
    }

    private func extractFirstArtist(json: NSDictionary) -> String? {
        let artists = json["artists"] as? NSArray
        let artist = artists?.firstObject as? NSDictionary
        let name = artist?["name"] as? String
        return name
    }
    
    private func extractYear(json: NSDictionary) -> String? {
        var year = json["released"] as? String
        let index = year?.startIndex.advancedBy(4)
        year = year?.substringToIndex(index!)
        return year
    }
}

