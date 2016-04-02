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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        self.collectionViewLayout.invalidateLayout()
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
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, CGFloat(70))
    }

}
