//
//  UIView + Ext.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 02.11.2021.
//

import UIKit

extension UIView {
    func prepareForAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIViewController {
    func alert(title: String, desc: String) {
        let alert = UIAlertController(
            title: title,
            message: desc,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .cancel
            )
        )
        self.present(alert, animated: true)
    }
}
