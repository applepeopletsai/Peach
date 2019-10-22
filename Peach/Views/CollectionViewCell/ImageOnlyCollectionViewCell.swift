//
//  ImageOnlyCollectionViewCell.swift
//  Peach
//
//  Created by dean on 2019/10/8.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class ImageOnlyCollectionViewCell: CoreCollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var avaterImageView: UIImageView!
    
    var shouldSelect = false
    
    override var item: RowItemProtocol? {
        didSet {
            if let item = item {
                setViewBy(item: item)
            }
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if shouldSelect {
                    layer.borderColor = UIColor.customColor(.color_text_5).cgColor
                    layer.borderWidth = 2
                } else {
                    layer.borderColor = UIColor.clear.cgColor
                    layer.borderWidth = 0
                }
            } else {
                layer.borderColor = UIColor.clear.cgColor
                layer.borderWidth = 0
            }
        }
    }
    func setViewBy(item: RowItemProtocol) {
        if let value = item.value as? UIImage {
            avaterImageView.image = value
        } else if let value = item.value as? [String : Any] {
            if let image = value["image"] as? UIImage {
                avaterImageView.image = image
            }
            if let shouldSelect = value["shouldSelect"] as? Bool {
                self.shouldSelect = shouldSelect
            }
            if let shouldShowNumber = value["shouldShowNumber"] as? Bool {
                self.numberLabel.isHidden = !shouldShowNumber
            }
        }
    }
    func shouldShowNumberLabel(shouldShow:Bool, number:String,totalCount:String) {
        if shouldShow {
            numberLabel.backgroundColor = UIColor.customColor(.color_text_2)
            numberLabel.layer.setRoundWith(radius: 4)
            numberLabel.text = "\(number)/\(totalCount)"
        } else {
            numberLabel.text = ""
            numberLabel.backgroundColor = UIColor.clear
        }
    }
    
}
