//
//  ViewController.swift
//  iOSNetworkingDemo
//
//  Created by Alekh on 30/08/17.
//
//

import UIKit
import iOSNetwork

class ViewController: UIViewController {

    let networkInterface = NetworkManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        networkInterface.samplePOSTRequest { (test:AnyObject?) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

