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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let releaseController = segue.destinationViewController as? CollectionViewController
        releaseController?.loadIndicator = self.loadIndicator
    }

}
