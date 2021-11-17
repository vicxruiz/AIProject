//
//  UIImage+Extensions.swift
//  AIProject
//
//  Created by Victor Ruiz on 11/10/21.
//

import Foundation
import UIKit

extension UIImage {
  static func localImage(_ name: String, template: Bool = false) -> UIImage {
	var image = UIImage(named: name)!
	if template {
	  image = image.withRenderingMode(.alwaysTemplate)
	}
	return image
  }
}
