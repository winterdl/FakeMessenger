//
//  ChatLogMessageCell.swift
//  fbMessenger
//
//  Created by Ihar Tsimafeichyk on 3/7/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    
    var message: Message? {
        didSet {
            if let text = message?.text {
                let estimatedFrame = estimatedRect(text: text)
                if let isSender = message?.isSender {
                    if !isSender {
                        textViewMessage.frame = CGRect(x: 48 + 12, y: 0,
                                                       width:estimatedFrame.width + 14,
                                                       height: estimatedFrame.height + 20)
                        textBubleView.frame = CGRect(x: 48, y: 0,
                                                     width: estimatedFrame.width + 16 + 10,
                                                     height: estimatedFrame.height + 20)
                        profileImageView.isHidden = false
                    } else {
                        
                        let x = frame.width - estimatedFrame.width
                        
                        textViewMessage.frame = CGRect(x: x - 18 - 6, y: 0,
                                                       width:estimatedFrame.width + 16,
                                                       height: estimatedFrame.height + 20)
                        textBubleView.frame = CGRect(x: x - 16 - 8 - 8, y: 0,
                                                     width: estimatedFrame.width + 16 + 8,
                                                     height: estimatedFrame.height + 20)
                        //textBubleView.backgroundColor = UIColor(red:0, green: 134/255, blue: 249/255, alpha: 1)
                        textViewMessage.textColor = .white
                        profileImageView.isHidden = true
                        bubbleImageView.tintColor = UIColor(red:0, green: 134/255, blue: 249/255, alpha: 1)
                        bubbleImageView.image = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
                    }
                }
                textViewMessage.text = text
                
            }
            
            if let imageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    // Countint the size of the cell. Based on text length
    func estimatedRect(text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrameSize = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        return estimatedFrameSize
    }
    
    let textBubleView: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let textViewMessage: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        //textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let bubbleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
        image.tintColor = UIColor(white: 0.9, alpha: 1)
        return image
    }()
    
    override func setupViews() {
        
        addSubview(textBubleView)
        addSubview(textViewMessage)
        
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        
        textBubleView.addSubview(bubbleImageView)
        textBubleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
        
    }
    
    
}
