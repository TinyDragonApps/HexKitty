//
//  MasterViewController.swift
//  Kitty
//
//  Created by Joseph Pintozzi on 9/24/14.
//  Copyright (c) 2014 Tiny Dragon Apps. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = NSMutableArray()
    var client: OCTClient? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.client == nil {
            OCTClient.signInToServerUsingWebBrowser(OCTServer.dotComServer(), scopes: OCTClientAuthorizationScopesNotifications).subscribeNext({ (authenticatedClient) -> Void in
                    self.client = authenticatedClient as? OCTClient
                    self.loadNotifications()
                }, error: { (error) -> Void in
                    
                }) { () -> Void in
                    
            }
        } else {
            self.loadNotifications()
        }
    }
    
    func loadNotifications() {
        self.client?.fetchNotificationsNotMatchingEtag(nil, includeReadNotifications: true, updatedSince: nil).subscribeNext({ (notification) -> Void in
            
            if let resp = notification as? OCTResponse {
                let n = resp.parsedResult as OCTNotification
                self.objects.addObject(n)
                self.tableView.reloadData()
            }
            
            }, error: { (error) -> Void in
            
            }, completed: { () -> Void in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.objects[indexPath.row] as OCTNotification
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = self.objects[indexPath.row] as OCTNotification
        cell.textLabel?.text = object.title
        cell.detailTextLabel?.text = object.repository.name
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


}

