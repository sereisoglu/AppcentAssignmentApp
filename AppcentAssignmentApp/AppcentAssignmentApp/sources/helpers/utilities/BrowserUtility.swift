//
//  BrowserUtility.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 30.08.2021.
//

import UIKit
import SafariServices

final class BrowserUtility {
    class func openInsideOfApp(urlString: String, delegate: UIViewController?) {
        guard let url = URL(string: urlString),
              let delegate = delegate else {
            return
        }
        
        let safariController = SFSafariViewController(url: url)
        delegate.present(safariController, animated: true, completion: nil)
    }
}
