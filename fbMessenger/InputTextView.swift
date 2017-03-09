//
//  InputTextView.swift
//  fbMessenger
//
//  Created by Ihar Tsimafeichyk on 3/9/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit



class InputTextView: UIView {
    
    
    var friend : Friend?
    
    let messageTextInputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type message here.."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let topBorderLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.80, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.init(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(self.sendButtonHandler), for: .touchUpInside)
        return button
    }()
    
    func sendButtonHandler() {
        if messageTextInputField.text != "" {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            FriendsController.createOwnMessageWithText(messageText: messageTextInputField.text!, friend: friend!, minutesAgo: 0, isReaded: true, context: context)
            
            do {
                try context.save()
                messageTextInputField.text = nil
            } catch let err {
                print(err)
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(messageTextInputField)
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: messageTextInputField)
        addConstraintsWithFormat(format: "V:[v0(60)]|", views: messageTextInputField)
        
        addSubview(topBorderLine)
        addSubview(sendButton)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderLine)
        addConstraintsWithFormat(format: "V:|[v0(1)]", views: topBorderLine)
        
        addConstraintsWithFormat(format: "H:[v0(80)]|", views: sendButton)
        addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

