//
//  ViewController.swift
//  Mathraiser
//
//  Created by Michael Chen on 6/11/20.
//  Copyright © 2020 ChenOutOfTen. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

var mathPageScrollView: UIScrollView!
let mathPageContentView = UIView()

var totalQuestions = Int()
var numIncorrectAnswers = Int()

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 500)
    let mathPageScrollView = UIScrollView()
    
    var bannerView: GADBannerView!
    var equationComponent1 = UILabel()
    var equationComponent2 = UILabel()
    var equationComponent3 = UILabel()
    var equationComponent4 = UILabel()
    var component1 = Int()
    var component2 = String()
    var component3 = Int()
    var component4 = String()
    var answerBlank = UITextField()
    var separatorView = UIView()
    var gradientLayers = [CAGradientLayer]()
    var colorIncrementer = Int()
    var answer = Int()
    var isScreenRed = Bool()
    var upArrow = UIImageView()
    var arrowLabel = UILabel()
    
    override func viewDidLoad() {
        totalQuestions = 0
        numIncorrectAnswers = 0
        setUpColors()
        colorIncrementer = 0
        isScreenRed = false
        view.layer.insertSublayer(gradientLayers[colorIncrementer], at: 0)
        
        view.addSubview(mathPageScrollView)
        
        
        mathPageScrollView.translatesAutoresizingMaskIntoConstraints = false;
        mathPageScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        mathPageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true;
        mathPageScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true;
        mathPageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        mathPageScrollView.contentSize = contentViewSize
        
        
        mathPageScrollView.addSubview(mathPageContentView)
        mathPageContentView.translatesAutoresizingMaskIntoConstraints = false

        mathPageContentView.centerXAnchor.constraint(equalTo: mathPageScrollView.centerXAnchor).isActive = true;
        mathPageContentView.topAnchor.constraint(equalTo: mathPageScrollView.topAnchor).isActive = true;
        mathPageContentView.widthAnchor.constraint(equalTo: mathPageScrollView.widthAnchor).isActive = true;
        mathPageContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true;
        mathPageContentView.frame.size = contentViewSize
        
        setUpEquation()
        
        answerBlank.translatesAutoresizingMaskIntoConstraints = false
        answerBlank.textColor = .black
        answerBlank.font = UIFont(name: "Comfortaa-Light", size: 36.0)
        answerBlank.textAlignment = .center
        answerBlank.borderStyle = .none
        answerBlank.delegate = self
        
        answerBlank.placeholder = "Answer"
        
        mathPageContentView.addSubview(answerBlank)

        view.backgroundColor = .white
        super.viewDidLoad()
        
        bannerView = GADBannerView()
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
        bannerView.adSize = adSize
        //        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        arrowLabel.text = "All Done?"
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.font = UIFont(name: "Comfortaa-Light", size: 15)
        arrowLabel.textColor = .black
        arrowLabel.textAlignment = .center
        view.addSubview(arrowLabel)
        
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
        
        setUpConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        mathPageScrollView.keyboardDismissMode = .interactive
        
        // Do any additional setup after loading the view.
    }
    
    @objc func changeScreens(){
        for view in mathPageContentView.subviews {
            view.removeFromSuperview()
        }
        let donePage = DonePage()
        donePage.modalPresentationStyle = .fullScreen
        self.present(donePage, animated: true, completion: nil)
    }
    
    func setUpEquation() {
        let randomNumber = Int.random(in: 1 ... 3)
        component1 = Int.random(in: 1 ... 10)
        component3 = Int.random(in: 1 ... 10)
        component4 = "="
        if randomNumber == 1 {
            component2 = "+"
            self.answer = component1 + component3
        } else if randomNumber == 2 {
            component2 = "-"
            self.answer = component1 - component3
        } else {
            component2 = "x"
            self.answer = component1 * component3
        }
        
        equationComponent1.text = "\(component1) \(component2) \(component3) \(component4) ?"
        equationComponent1.translatesAutoresizingMaskIntoConstraints = false
        equationComponent1.font = UIFont(name: "Comfortaa-Regular", size: 48.0)
        equationComponent1.textAlignment = .center
        mathPageContentView.addSubview(equationComponent1)
    }
    
    func setUpColors() {
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.frame = self.view.bounds
        gradientLayer1.colors = [UIColor.systemBlue.cgColor, UIColor.white.cgColor]
        gradientLayers.append(gradientLayer1)
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.frame = self.view.bounds
        gradientLayer2.colors = [UIColor.green.cgColor, UIColor.white.cgColor]
        gradientLayers.append(gradientLayer2)
        let gradientLayer3 = CAGradientLayer()
        gradientLayer3.frame = self.view.bounds
        gradientLayer3.colors = [UIColor.orange.cgColor, UIColor.white.cgColor]
        gradientLayers.append(gradientLayer3)
        let gradientLayer4 = CAGradientLayer()
        gradientLayer4.frame = self.view.bounds
        gradientLayer4.colors = [UIColor.yellow.cgColor, UIColor.white.cgColor]
        gradientLayers.append(gradientLayer4)
        let gradientLayer5 = CAGradientLayer()
        gradientLayer5.frame = self.view.bounds
        gradientLayer5.colors = [UIColor.cyan.cgColor, UIColor.white.cgColor]
        gradientLayers.append(gradientLayer5)
        let gradientLayer6 = CAGradientLayer()
        gradientLayer6.frame = self.view.bounds
        gradientLayer6.colors = [UIColor.purple.cgColor, UIColor.white.cgColor]
        gradientLayers.append(gradientLayer6)
        let gradientLayer7 = CAGradientLayer()
        gradientLayer7.frame = self.view.bounds
        gradientLayer7.colors = [UIColor.magenta.cgColor, UIColor.white.cgColor]
        gradientLayers.append(gradientLayer7)
        let gradientLayer8 = CAGradientLayer()
        gradientLayer8.frame = self.view.bounds
        gradientLayer8.colors = [UIColor.red.cgColor, UIColor.white.cgColor]
        gradientLayers.append(gradientLayer8)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            self.answerBlank.text = ""
        }
        if "\(answer)" == answerBlank.text {
            totalQuestions += 1
            self.answerBlank.placeholder = "Answer"
            colorIncrementer += 1
            var colorIncrementerTracker = colorIncrementer - 1
            if colorIncrementer > 6 {
                colorIncrementer = 0
                colorIncrementerTracker = 6
            }
            if isScreenRed == true {
                view.layer.replaceSublayer(gradientLayers[7], with: gradientLayers[colorIncrementer])
                isScreenRed = false
            } else {
                view.layer.replaceSublayer(gradientLayers[colorIncrementerTracker], with: gradientLayers[colorIncrementer])
            }
            equationComponent1.removeFromSuperview()
            setUpEquation()
            setUpConstraints()
        } else {
            if isScreenRed == false {
                numIncorrectAnswers += 1
                self.answerBlank.placeholder = "Wrong"
                view.layer.replaceSublayer(gradientLayers[colorIncrementer], with: gradientLayers[7])
                isScreenRed = true
                DispatchQueue.main.async {
                    self.answerBlank.placeholder = "Wrong"
                }
            }
        }
        
        self.view.endEditing(true)
        return true
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if answerBlank.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height + view.safeAreaInsets.bottom
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        // do aditional stuff
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            
            equationComponent1.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 30),
            equationComponent1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            equationComponent1.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            answerBlank.topAnchor.constraint(equalTo: equationComponent1.bottomAnchor, constant: 30),
            answerBlank.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerBlank.widthAnchor.constraint(equalToConstant: 200),
            answerBlank.heightAnchor.constraint(equalToConstant: 70)
        ])
        
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
            arrowLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        
//        NSLayoutConstraint.activate([
//            separatorView.heightAnchor.constraint(equalToConstant: 2),
//            separatorView.bottomAnchor.constraint(equalTo: answerBlank.bottomAnchor),
//            separatorView.widthAnchor.constraint(equalToConstant: 200)
//        ])
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView){
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerY,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
    }
    


}

        
//        separatorView = UIView()
//        separatorView.backgroundColor = UIColor.black
//        separatorView.layer.borderWidth = 1.0
//        mathPageContentView.addSubview(separatorView)
        
        
//        equationComponent2.text = component2
//        equationComponent2.translatesAutoresizingMaskIntoConstraints = false
//        equationComponent2.font = UIFont(name: "Comfortaa-Regular", size: 36)
//        equationComponent2.textAlignment = .center
//        view.addSubview(equationComponent2)
//
//        equationComponent3.text = "\(component3)"
//        equationComponent3.translatesAutoresizingMaskIntoConstraints = false
//        equationComponent3.font = UIFont(name: "Comfortaa-Regular", size: 36)
//        equationComponent3.textAlignment = .left
//        view.addSubview(equationComponent3)
//
//        equationComponent4.text = component4
//        equationComponent4.translatesAutoresizingMaskIntoConstraints = false
//        equationComponent4.font = UIFont(name: "Comfortaa-Regular", size: 36)
//        equationComponent4.textAlignment = .left
//        view.addSubview(equationComponent4)
        
        
        
        
