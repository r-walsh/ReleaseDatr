//
//  ButtonBorder.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/22/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation
import UIKit

public enum UIButtonBorderSide {
	case Top, Bottom, Left, Right
}

extension UIButton {

	public func addBorder( side: UIButtonBorderSide, color: UIColor, width: CGFloat ) {
		let border = CALayer()
		border.backgroundColor = color.CGColor

		switch side {
			case .Top:
				border.frame = CGRect( x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 60, height: width )
			case .Bottom:
				border.frame = CGRect( x: 0, y: self.frame.size.height - width, width: UIScreen.mainScreen().bounds.width - 60, height: width )
			case .Left:
				border.frame = CGRect( x: 0, y: 0, width: width, height: self.frame.size.height )
			case .Right:
				border.frame = CGRect( x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height )
		}

		self.layer.addSublayer( border )
	}
}