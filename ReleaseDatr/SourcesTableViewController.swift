//
//  SourcesTableViewController.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/25/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class SourcesTableViewController: UITableViewController {

	var sources: [ String ] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sources.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier( "sourceCell", forIndexPath: indexPath ) as! SourceTableViewCell

		cell.sourceLabel.text = sources[ indexPath.row ]

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
    }

}
