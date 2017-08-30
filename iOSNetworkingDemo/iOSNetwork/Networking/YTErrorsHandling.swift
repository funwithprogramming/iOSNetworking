//
//  YTErrorsHandling.swift
//  
//
//  Created by Alekh on 17/06/16.
//  Copyright © 2016 . All rights reserved.
//

import Foundation
//import UIKit

protocol LoadingViewRenderer {
  func presentLoadingView()
  func dismissLoadingView()
  //func presentLoadingViewAndHideView(view:UIView)
  //func dismissLoadingViewandShowView(view:UIView)

}
protocol ErrorPopoverRenderer {
  //Error presentation using UIAlerController
  func presenGeneralError( buttonText:String?,message: String)
}

//extension ErrorPopoverRenderer where Self: UIViewController {
//  
//  func presenGeneralError( buttonText:String?,message: String) {
//    let actionSheetController = UIAlertController(title: "Error", message:message, preferredStyle: UIAlertControllerStyle.Alert)
//    //Create and add the Cancel action
//    var bTnText = "Cancel"
//    if let _ = buttonText {
//      bTnText = "OK"
//    }
//    let cancelAction: UIAlertAction = UIAlertAction(title: bTnText, style: .Cancel) { action -> Void in
//    }
//    actionSheetController.addAction(cancelAction)
//    presentViewController(actionSheetController, animated: true, completion: nil)
//  }
//}

////Used for UIViewController
//extension LoadingViewRenderer where Self: UIViewController {
//  
//  func presentLoadingView() {
//    //Add default implementation
//  }
//  func dismissLoadingView() {
//    //Add default implementation
//  }
//  func presentLoadingViewAndHideView(view:UIView) {
//    //Add default implementation
//   // MBProgressHUD.showHUDAddedTo(view, animated: true)
//    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//    myActivityIndicator.center = view.center
//    //TODO:Change this tag.It should be another logic
//    myActivityIndicator.tag = 1000
//    myActivityIndicator.startAnimating()
//    self.view.addSubview(myActivityIndicator)
//    view.hidden = true
//  }
//  func dismissLoadingViewandShowView(view:UIView) {
//    //Add default implementation
//    let activityIndicator = self.view.viewWithTag(1000) as? UIActivityIndicatorView
//    activityIndicator?.stopAnimating()
//    activityIndicator?.hidden = true
//    activityIndicator?.removeFromSuperview()
//    view.hidden = false
//  }
//}
//
////Used for UIViews
//extension LoadingViewRenderer where Self: UIView {
//  
//  func presentLoadingView() {
//    //Add default implementation
//  }
//}


