//
//  JsonParser.swift
//  DiscogsBrowser
//
//  Created by Peter Großmann on 02.04.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import Foundation

protocol JsonParserDelegate {
    func didParseReleases(releases: Array<Release>)
}

class JsonParser {
    
    init(delegate: JsonParserDelegate) {
        self.delegate = delegate
    }
    var delegate : JsonParserDelegate?
    let userAgent = "BrowserForDiscogs/0.1 +https://github.com/pgro/browser-for-discogs"
    

    func retrieveRelease() {
        let url = "https://api.discogs.com/artists/3857/releases?sort=year&sort_order=desc" // releases by NIN
        
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
                self.parseArtistReleasesJson(json)
            } catch {
                NSLog("couldn't parse json :(")
            }
        }
        task.resume()
    }
    
    
    /** Parses releases from an artist, queried via https://api.discogs.com/artists/{id}/releases */
    func parseArtistReleasesJson(json: NSDictionary) {
        var releases = Array<Release>()
        
        let releasesJson = json["releases"] as! NSArray
        for releaseJson in releasesJson {
            let type = releaseJson["type"] as? String
            if type != nil && type == "master" {
                let release = self.parseArtistReleaseJson(releaseJson as! NSDictionary)
                releases.append(release)
            }
        }
        
        self.delegate?.didParseReleases(releases)
    }
    
    
    private func parseArtistReleaseJson(json: NSDictionary) -> Release {
        let release = Release()
        release.title = json["title"] as? String
        release.artist = json["artist"] as? String
        release.releaseYear = json["year"] as? String
        release.thumbnailUrl = json["thumb"] as? String
        return release
    }
    
    /** Parses a release, queried via https://api.discogs.com/releases/{id} */
    func parseReleaseJson(json: NSDictionary) -> Release {
        let release = Release()
        release.title = json["title"] as? String
        release.artist = self.extractFirstArtist(json)
        release.releaseYear = self.extractYear(json)
        release.thumbnailUrl = json["thumb"] as? String
        return release
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

