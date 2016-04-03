//
//  MainViewController.swift
//  DiscogsBrowser
//
//  Created by Peter Großmann on 03.04.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    var releasesController: ReleasesCollectionViewController?
    var releases = Array<Release>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.loadIndicator?.startAnimating()
        let parser = JsonParser(delegate: self)
        parser.retrieveRelease()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.releasesController = segue.destinationViewController as? ReleasesCollectionViewController
    }

}


// MARK: - JsonParserDelegate

extension MainViewController: JsonParserDelegate {
    func didParseRelease(release: Release) {
        releases.append(release)
        dispatch_async(dispatch_get_main_queue()) {
            self.releasesController?.releases = self.releases
            self.releasesController?.collectionView?.reloadData()
            self.loadIndicator?.stopAnimating()
        }
    }
}
