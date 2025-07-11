//
//  HistoryController.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 2.6.25.
//

import UIKit
import SwiftUI

class HistoryController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
   // let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(collectionView)
//
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HistoryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCellIdentifier", for: indexPath) as! HistoryCell
        
  
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set your desired item size
        let width = collectionView.bounds.width - 20
        let height = 80.0  // example calculation
        return CGSize(width: width, height: height)
    }
}


struct UIKitHistoryView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HistoryController {
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "historyID") as! HistoryController
    }

    func updateUIViewController(_ uiViewController: HistoryController, context: Context) {}
}
