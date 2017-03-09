//
//  FriendCell.swift
//  fbMessenger
//
//  Created by Ihar Tsimafeichyk on 3/1/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

class FriendCell : BaseCell {
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? UIColor(red:0, green: 134/255, blue: 249/255, alpha: 1) : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            messageLabel.textColor = isHighlighted ? .white : .black
            timelabel.textColor = isHighlighted ? .white : .black
        }
    }
    
    var message: Message? {
        didSet{
            if let imageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: imageName)
            }
            nameLabel.text = message?.friend?.name
            messageLabel.text = message?.text
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                
                let elapsedTimeInSelector = NSDate().timeIntervalSince(date as Date)
                
                let secondsInDays : TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSelector > 7 * secondsInDays {
                    dateFormatter.dateFormat = "MM/dd/yy"
                } else if elapsedTimeInSelector > secondsInDays {
                    dateFormatter.dateFormat = "EEE"
                } else {
                    timelabel.text = dateFormatter.string(from: date as Date)
                }
                
            }
           
            if let isReaded = message?.hasReaded {
                hasReadImageView.image = isReaded ? profileImageView.image : nil
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addSubview(dividerLine)
        addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLine)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLine)
        
        addSubview(containerView)
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(60)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        containerView.addSubview(timelabel)
        containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: timelabel)
        
        containerView.addSubview(hasReadImageView)
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
        
        containerView.addSubview(nameLabel)
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLabel, timelabel)
        
        containerView.addSubview(messageLabel)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        
        
    }
    
}

