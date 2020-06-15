//
//  DonePage.swift
//  Mathraiser
//
//  Created by Michael Chen on 6/13/20.
//  Copyright © 2020 ChenOutOfTen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DonePage: UIViewController {
    
    var upArrow = UIImageView()
    var arrowLabel = UILabel()
    var header = UILabel()
    var details = UILabel()
    var logo = UIImageView()
    var fractionRightAnswers = UILabel()
    var findOutMore = UITextView()
    var upload = UIButton()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPink.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        header.text = "CONGRATULATIONS"
        header.translatesAutoresizingMaskIntoConstraints = false
        header.textColor = .black
        header.font = UIFont(name: "Comfortaa-Bold", size: 30.0)
        header.textAlignment = .center
        view.addSubview(header)
        
        
        fractionRightAnswers.text = "Score: \(totalQuestions-numIncorrectAnswers)/\(totalQuestions)"
        fractionRightAnswers.translatesAutoresizingMaskIntoConstraints = false
        fractionRightAnswers.textColor = .black
        fractionRightAnswers.font = UIFont(name: "Comfortaa-Bold", size: 25.0)
        fractionRightAnswers.textAlignment = .center
        view.addSubview(fractionRightAnswers)
        
        details.text = "You have contributed approximately \(0.001 * Double(totalQuestions)) cents to the \(selectedCharity)"
        details.translatesAutoresizingMaskIntoConstraints = false
        details.textColor = .black
        details.numberOfLines = 0
        details.lineBreakMode = .byWordWrapping
        details.font = UIFont(name: "Comfortaa-Regular", size: 18)
        details.textAlignment = .center
        view.addSubview(details)
        
        upArrow.image = UIImage(named: "up-arrow")
        upArrow.contentMode = .scaleAspectFit
        upArrow.clipsToBounds = true
        upArrow.translatesAutoresizingMaskIntoConstraints = false
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(changeScreens))
        swipe.direction = .up
        upArrow.addGestureRecognizer(swipe)
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeScreens))
        upArrow.addGestureRecognizer(tap)
        upArrow.isUserInteractionEnabled = true
        view.addSubview(upArrow)

        arrowLabel.text = "Restart"
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.font = UIFont(name: "Comfortaa-Light", size: 15)
        arrowLabel.textColor = .black
        arrowLabel.textAlignment = .center
        view.addSubview(arrowLabel)
        
        logo.image = UIImage(named: "mathRaiserLogo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.clipsToBounds = true
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)
        
        findOutMore.translatesAutoresizingMaskIntoConstraints = false
        findOutMore.textColor = .black
        findOutMore.font = UIFont(name: "Comfortaa-Regular", size: 18)
        findOutMore.textAlignment = .center
        findOutMore.backgroundColor = .none
        findOutMore.text = "Find Out More at google.com"
        findOutMore.dataDetectorTypes = .link
        findOutMore.isEditable = false
        findOutMore.isUserInteractionEnabled = true
//        let attributedString = NSMutableAttributedString(string: "Click Here to Find Out More")
//        let url = URL(string: "https://www.apple.com")!
//
//        // Set the 'click here' substring to be the link
//        attributedString.setAttributes([.link: url], range: NSMakeRange(5, 10))
//
//        findOutMore.attributedText = attributedString
//        findOutMore.isUserInteractionEnabled = true
//        findOutMore.isEditable = false
//
//        // Set how links should appear: blue and underlined
//        findOutMore.linkTextAttributes = [
//            .foregroundColor: UIColor.blue,
//            .underlineStyle: NSUnderlineStyle.single.rawValue
//        ]
        
        upload.setImage(UIImage(named: "upload"), for: .normal) 
        upload.translatesAutoresizingMaskIntoConstraints = false
        upload.clipsToBounds = true
        upload.contentMode = .scaleAspectFit
        upload.addTarget(self, action: #selector(pulseButtonTapped), for: .touchUpInside)
        upload.addTarget(self, action: #selector(shareScreenshot), for: .touchUpInside)
        view.addSubview(upload)
        
        view.addSubview(findOutMore)
        
        setUpConstraints()
        

//         Do any additional setup after loading the view.
    }
    
    @objc func shareScreenshot() {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        activityViewController.modalPresentationStyle = .popover
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func pulseButtonTapped(_ sender: UIButton) {
        sender.pulsate()
    }
    
    @objc func changeScreens(){
        for view in view.subviews {
            view.removeFromSuperview()
        }
        let introScreen = IntroScreen()
        introScreen.modalPresentationStyle = .fullScreen
        self.present(introScreen, animated: true, completion: nil)
    }

    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            upArrow.bottomAnchor.constraint(equalTo: arrowLabel.topAnchor),
            upArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            upArrow.heightAnchor.constraint(equalToConstant: 60),
            upArrow.widthAnchor.constraint(equalToConstant: 60)
        ])

        NSLayoutConstraint.activate([
            arrowLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10),
            arrowLabel.heightAnchor.constraint(equalToConstant: 17),
            arrowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrowLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            logo.bottomAnchor.constraint(equalTo: header.topAnchor, constant: -27),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 80),
            logo.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalToConstant: 350),
            header.heightAnchor.constraint(equalToConstant: 43),
            header.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fractionRightAnswers.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            fractionRightAnswers.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fractionRightAnswers.heightAnchor.constraint(equalToConstant: 43)
        ])
        
        NSLayoutConstraint.activate([
            details.topAnchor.constraint(equalTo: fractionRightAnswers.bottomAnchor, constant: 10),
            details.widthAnchor.constraint(equalToConstant: 274),
            details.heightAnchor.constraint(equalToConstant: 120),
            details.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            findOutMore.topAnchor.constraint(equalTo: details.bottomAnchor, constant:  5),
            findOutMore.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findOutMore.heightAnchor.constraint(equalToConstant: 30),
            findOutMore.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            upload.topAnchor.constraint(equalTo: findOutMore.bottomAnchor, constant: 10),
            upload.widthAnchor.constraint(equalToConstant: 30),
            upload.heightAnchor.constraint(equalToConstant: 30),
            upload.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }

}
