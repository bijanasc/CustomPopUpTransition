//
//  CustomPopUpController.swift
//  CustomPopUpTransition
//
//  Created by Bijan Cronin on 6/28/18.
//  Copyright © 2018 Bijan Cronin. All rights reserved.
//

import UIKit

class CustomPopUpController: UIViewController {
    
    private var popUpViewCenterYAnchor: NSLayoutConstraint?
    
    let popUpView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 9
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 6
        return view
    }()
    
    let dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.isUserInteractionEnabled = true
        view.alpha = 0
        return view
    }()
    
    let dismissPopUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.setTitle("Dismiss!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        button.showsTouchWhenHighlighted = true
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.layer.cornerRadius = 25
        return button
    }()
    
    @objc func dismissVC() {
        popUpViewCenterYAnchor?.isActive = false
        popUpViewCenterYAnchor = popUpView.topAnchor.constraint(equalTo: view.bottomAnchor)
        popUpViewCenterYAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.dimView.alpha = 0
        })
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        })
    }
    
    func setupViews() {
        let width = view.frame.width
        let height = view.frame.height
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.addSubview(dimView)
        dimView.addSubview(blurView)
        dimView.frame = self.view.frame
        blurView.frame = dimView.bounds
        view.addSubview(popUpView)
        popUpView.addSubview(dismissPopUpButton)
        popUpView.widthAnchor.constraint(equalToConstant: width * 0.75).isActive = true
        popUpView.heightAnchor.constraint(equalToConstant: height * 0.5).isActive = true
        popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpViewCenterYAnchor = popUpView.topAnchor.constraint(equalTo: view.bottomAnchor)
        popUpViewCenterYAnchor?.isActive = true
        dismissPopUpButton.centerYAnchor.constraint(equalTo: popUpView.centerYAnchor).isActive = true
        dismissPopUpButton.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        dismissPopUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dismissPopUpButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        popUpViewCenterYAnchor?.isActive = false
        popUpViewCenterYAnchor = popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25)
        popUpViewCenterYAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dimView.alpha = 1
        })
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
}
