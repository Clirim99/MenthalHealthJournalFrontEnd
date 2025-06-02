//
//  ViewController.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 28.5.25.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        let nextController = storyboard.instantiateViewController(withIdentifier: "Profile") as! HomePage
//        navigationController.pushViewController(myProfileController, animated: true)
    }

    @IBAction func startTheApp(_ sender: Any) {
//        let swiftUI = HomePage()
//        let toAddContentController = UIHostingController(rootView: swiftUI)
//        self.navigationController?.pushViewController(toAddContentController, animated: true)
        let storyboard = UIStoryboard(name: "ContactsList", bundle: nil) // Replace "Main" with your actual storyboard name
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "ContactsList") as! ContactListController
        navigationController?.pushViewController(nextViewController, animated: true)
        print("moving...")
    }
    
}

