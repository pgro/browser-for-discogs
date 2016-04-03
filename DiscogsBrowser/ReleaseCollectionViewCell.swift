//
//  ReleaseCollectionViewCell.swift
//  DiscogsBrowser
//
//  Created by Peter Großmann on 02.04.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import UIKit

class ReleaseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateText(release: Release?) {
        if release == nil {
            return
        }
        
        var text = ""
        if let artist = release!.artist {
            text += artist + " - "
        }
        if let title = release!.title {
            text += title
        }
        if let year = release!.releaseYear {
            text += " (" + year + ")"
        }
        nameLabel.text = text
    }
}
