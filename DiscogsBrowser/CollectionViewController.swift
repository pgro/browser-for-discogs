//
//  CollectionViewController.swift
//  DiscogsBrowser
//
//  Created by Peter Großmann on 02.04.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import UIKit

private let reuseIdentifier = "releaseCell"

class CollectionViewController: UICollectionViewController, JsonParserDelegate {
    var releases = Array<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.collectionView!.registerClass(ReleaseCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let parser = JsonParser(delegate: self)
        parser.retrieveRelease()
    }
    }
    

    // MARK: - JsonParserDelegate
    
    func didParseRelease(title: String?) {
        releases.append(title!)
        dispatch_async(dispatch_get_main_queue()) { 
            self.collectionView?.reloadData()
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.releases.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ReleaseCollectionViewCell
    
        cell.nameLabel.text = self.releases[indexPath.item]
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    }

}
