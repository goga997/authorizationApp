//
//  UIStackView + Extension.swift
//  AuthorizationApp
//
//  Created by Grigore on 09.04.2023.
//

import UIKit

extension UIStackView {
    convenience init(arangedSubViews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: arangedSubViews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
