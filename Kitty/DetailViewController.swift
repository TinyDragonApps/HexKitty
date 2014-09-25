//
//  DetailViewController.swift
//  Kitty
//
//  Created by Joseph Pintozzi on 9/24/14.
//  Copyright (c) 2014 Tiny Dragon Apps. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: OCTNotification? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: OCTNotification = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.lastUpdatedDate.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

