//
//  ReleaseItemDetailViewController.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/25/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class ReleaseItemDetailViewController: UIViewController {

	let releaseItemCtrl = ReleaseItemController.sharedController
	var releaseItem: ReleaseItem?

	@IBOutlet weak var releaseItemNameAndMediaTypeLabel: UILabel!
	@IBOutlet weak var releaseDateLabel: UILabel!
	@IBOutlet weak var releaseDateConfirmedImage: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()

		if let releaseItem = releaseItem {
			releaseItemNameAndMediaTypeLabel.text = "\( releaseItem.name ) - \( releaseItem.mediaType )"
			releaseDateLabel.text = releaseItemCtrl.formatDateToDisplayString( releaseItem.releaseDate )
			releaseDateConfirmedImage.hidden = !releaseItem.releaseDateConfirmed
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}
