//
//  NewReleaseItemViewController.swift
//  datr-ios
//
//  Created by Ryan Walsh on 7/5/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class NewReleaseItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

	@IBOutlet weak var releaseItemNameTextField: UITextField!
	@IBOutlet weak var mediaTypePicker: UIPickerView!
	@IBOutlet weak var releaseDate: UIDatePicker!
	@IBOutlet weak var sourceUrlTextField: UITextField!

	private let mediaTypes = MediaTypes.mediaTypesArray

	override func viewDidLoad() {
		super.viewDidLoad()

		mediaTypePicker.delegate = self
		mediaTypePicker.dataSource = self
		releaseItemNameTextField.delegate = self
		sourceUrlTextField.delegate = self

		releaseDate.minimumDate = NSDate( timeIntervalSinceNow: 0 )
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - PickerView DataSource

	func numberOfComponentsInPickerView( pickerView: UIPickerView ) -> Int {
		return 1
	}

	func pickerView( pickerView: UIPickerView, numberOfRowsInComponent component: Int ) -> Int {
		return mediaTypes.count
	}

	func pickerView( pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String? {
		return mediaTypes[ row ]
	}

	// MARK: - Text Field Delegate

	func textFieldShouldReturn( textField: UITextField ) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	// MARK: - Actions

	@IBAction func saveReleaseItemButtonPressed( sender: UIButton ) {
		let userCtrl = UserController.sharedController

		if userCtrl.user == nil {
			let alertController = UIAlertController( title: "Login", message: "You must be logged add a release item", preferredStyle: .Alert )
			let loginAction = UIAlertAction( title: "Login", style: .Default ) {
				UIAlertAction -> Void in
				userCtrl.presentLoginView( self )
			}

			alertController.addAction( loginAction )
			alertController.addAction( UIAlertAction( title: "Cancel", style: .Destructive, handler: nil ) )

			self.presentViewController( alertController, animated: true, completion: nil )
			return
		}

		if let name = releaseItemNameTextField.text, releaseDateSource = sourceUrlTextField.text, mediaType = MediaTypes( rawValue: mediaTypes[ mediaTypePicker.selectedRowInComponent( 0 ) ] ) {
			let releaseItem = ReleaseItemController.sharedController.createReleaseItem( name, mediaType: mediaType, releaseDate: releaseDate.date, releaseDateSources: [ releaseDateSource ] )

			ReleaseItemController.sharedController.postReleaseItem( releaseItem )
			navigationController?.popViewControllerAnimated( true )
		}
	}

}
