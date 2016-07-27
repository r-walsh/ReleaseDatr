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

	func validateTextField( textField: UITextField ) -> Bool {
		if let text = textField.text {
			if text == "" {
				textField.layer.borderColor = UIColor.redColor().CGColor
				textField.layer.borderWidth = 1

				return false
			} else {
				textField.layer.borderColor = UIColor.blackColor().CGColor
				textField.layer.borderWidth = 0
			}
		} else {
			return false
		}

		return true
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
				userCtrl.handleAuth( self )
			}

			alertController.addAction( loginAction )
			alertController.addAction( UIAlertAction( title: "Cancel", style: .Destructive, handler: nil ) )

			self.presentViewController( alertController, animated: true, completion: nil )
			return
		}

		let nameTextFieldValid = validateTextField( releaseItemNameTextField )
		let sourceTextFieldValid = validateTextField( sourceUrlTextField )

		if !nameTextFieldValid || !sourceTextFieldValid {
			let anim = CAKeyframeAnimation( keyPath: "transform" )
			anim.values = [
					NSValue( CATransform3D: CATransform3DMakeTranslation( -5, 0, 0 ) ),
					NSValue( CATransform3D: CATransform3DMakeTranslation( 5, 0, 0 ) )
			]
			anim.autoreverses = true
			anim.repeatCount = 2
			anim.duration = 7 / 100

			self.view.layer.addAnimation( anim, forKey: nil )
			return
		}

		if let name = releaseItemNameTextField.text, releaseDateSource = sourceUrlTextField.text, mediaType = MediaTypes( rawValue: mediaTypes[ mediaTypePicker.selectedRowInComponent( 0 ) ] ) {
			let releaseItem = ReleaseItemController.sharedController.createReleaseItem( name, mediaType: mediaType, releaseDate: releaseDate.date, releaseDateSources: [ releaseDateSource ] )

			ReleaseItemController.sharedController.postReleaseItem( releaseItem )
			navigationController?.popViewControllerAnimated( true )
		}
	}

}
