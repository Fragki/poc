//
//  ViewController.swift
//  NibView
//
//  Created by fragi on 08/03/2021.
//

import UIKit

class ViewController: UIViewController {

    var nibFileView: NibFileView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addNibFileView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateNibFileView()
    }
    
    func addNibFileView() {
        nibFileView = NibFileView(frame: CGRect.zero)
        
        view.addSubview(nibFileView)
        nibFileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nibFileView.topAnchor.constraint(equalTo: view.topAnchor),
            nibFileView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            nibFileView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    func populateNibFileView() {
        nibFileView.nameLabel.text = "FK"
    }

}
