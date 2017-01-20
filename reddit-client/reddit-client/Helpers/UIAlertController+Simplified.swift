//
//  UIAlertController+Simplified.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/20/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    static func presentAlert(withError error: Error,
                             overViewController vc: UIViewController) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
//            println(action)
//        }
//        alertController.addAction(cancelAction)
//        
//        let destroyAction = UIAlertAction(title: "Destroy", style: .Destructive) { action in
//            println(action)
//        }
//        alertController.addAction(destroyAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }

}
