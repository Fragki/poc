//
//  NibFileView.swift
//  NibView
//
//  Created by fragi on 08/03/2021.
//

import UIKit

class NibFileView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var nameLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         initSubviews()
     }

     override init(frame: CGRect) {
         super.init(frame: frame)
         initSubviews()
     }

     func initSubviews() {
        let nib = UINib(nibName: "NibFileView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        nameLabel.backgroundColor = .green
        contentView.backgroundColor = .blue
        contentView.frame = bounds
        addSubview(contentView)

     }
}
