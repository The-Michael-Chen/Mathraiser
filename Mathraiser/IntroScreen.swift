//
//  IntroScreen.swift
//  Mathraiser
//
//  Created by Michael Chen on 6/13/20.
//  Copyright © 2020 ChenOutOfTen. All rights reserved.
//

import UIKit
import Firebase

var selectedCharity = String()
var selectedDifficulty = String()
var startTime: Date?

class IntroScreen: UIViewController {
    
    var header = UILabel()
    var details = UILabel()
    var upArrow = UIImageView()
    var logo = UIImageView()
    var arrowLabel = UILabel()
    var charityNames = [String]()
    var charityTableView = UITableView()
    var easyButton = UIButton()
    var medButton = UIButton()
    var hardButton = UIButton()
//
//    let charityTableView: UITableView = {
//        let ctv = UITableView()
//        ctv.translatesAutoresizingMaskIntoConstraints = false
//        ctv.register(CharityCell.self, forCellReuseIdentifier: "cellId")
//        return ctv
//    }()

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemPink.cgColor, UIColor.systemBlue.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        super.viewDidLoad()
    
        inputCharityNames()
        
        
        charityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        header.text = "MATHRAISER"
        header.translatesAutoresizingMaskIntoConstraints = false
        header.textColor = .black
        header.font = UIFont(name: "Comfortaa-Bold", size: 40.0)
        header.textAlignment = .center
        view.addSubview(header)
        
        
        details.text = """
        A simple & fun math game
        Select level of difficulty:
        """
        details.translatesAutoresizingMaskIntoConstraints = false
        details.textColor = .black
        details.numberOfLines = 0
        details.lineBreakMode = .byWordWrapping
        details.font = UIFont(name: "Comfortaa-Regular", size: 18)
        details.textAlignment = .center
        view.addSubview(details)
        
        easyButton.setTitle("Easy", for: .normal)
        easyButton.setTitleColor(.black, for: .normal)
        easyButton.titleLabel?.font = UIFont(name: "Comfortaa-Regular", size: 15)
        easyButton.layer.borderColor = UIColor.black.cgColor
        easyButton.layer.borderWidth = 2
        easyButton.addTarget(self, action: #selector(pulseButtonTapped), for: .touchUpInside)
        easyButton.addTarget(self, action: #selector(tappedEasyButton), for: .touchUpInside)
        easyButton.layer.cornerRadius = 6
        easyButton.translatesAutoresizingMaskIntoConstraints = false
        easyButton.layer.backgroundColor = UIColor.clear.cgColor
        view.addSubview(easyButton)
        
        medButton.setTitle("Medium", for: .normal)
        medButton.setTitleColor(.black, for: .normal)
        medButton.titleLabel?.font = UIFont(name: "Comfortaa-Regular", size: 15)
        medButton.layer.borderColor = UIColor.black.cgColor
        medButton.layer.borderWidth = 2
        medButton.addTarget(self, action: #selector(pulseButtonTapped), for: .touchUpInside)
        medButton.addTarget(self, action: #selector(tappedMedButton), for: .touchUpInside)
        medButton.layer.cornerRadius = 6
        medButton.translatesAutoresizingMaskIntoConstraints = false
        medButton.layer.backgroundColor = UIColor.clear.cgColor
        view.addSubview(medButton)
        
        hardButton.setTitle("Insane", for: .normal)
        hardButton.setTitleColor(.black, for: .normal)
        hardButton.titleLabel?.font = UIFont(name: "Comfortaa-Regular", size: 15)
        hardButton.layer.borderColor = UIColor.black.cgColor
        hardButton.layer.borderWidth = 2
        hardButton.addTarget(self, action: #selector(pulseButtonTapped), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(tappedHardButton), for: .touchUpInside)
        hardButton.layer.cornerRadius = 6
        hardButton.translatesAutoresizingMaskIntoConstraints = false
        hardButton.layer.backgroundColor = UIColor.clear.cgColor
        view.addSubview(hardButton)
        
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
        
        logo.image = UIImage(named: "mathRaiserLogo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.clipsToBounds = true
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)
        
        arrowLabel.text = "Begin"
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.font = UIFont(name: "Comfortaa-Light", size: 15)
        arrowLabel.textColor = .black
        arrowLabel.textAlignment = .center
        view.addSubview(arrowLabel)
        
        charityTableView.backgroundColor = .clear
        charityTableView.layer.borderColor = UIColor.clear.cgColor
        charityTableView.layer.borderWidth = 3
        charityTableView.layer.cornerRadius = 10
        charityTableView.translatesAutoresizingMaskIntoConstraints = false
        charityTableView.separatorColor = .black
        charityTableView.dataSource = self
        charityTableView.delegate = self
//        charityTableView.dataSource = self
        view.addSubview(charityTableView)
        
        setUpConstraints()
        DispatchQueue.main.async {
            self.charityTableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func tappedEasyButton() {
        easyButton.backgroundColor = .systemGray4
        medButton.backgroundColor = .clear
        hardButton.backgroundColor = .clear
        selectedDifficulty = "Easy"
    }
    
    @objc func tappedMedButton() {
        easyButton.backgroundColor = .clear
        medButton.backgroundColor = .systemGray4
        hardButton.backgroundColor = .clear
        selectedDifficulty = "Medium"
    }
    
    @objc func tappedHardButton() {
        easyButton.backgroundColor = .clear
        medButton.backgroundColor = .clear
        hardButton.backgroundColor = .systemGray4
        selectedDifficulty = "Insane"
    }
    
    @IBAction func pulseButtonTapped(_ sender: UIButton) {
        sender.pulsate()
    }
    
    func inputCharityNames() {
        Database.database().reference().child("charities").observe( .value, with: { (snapshot) in
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                let charityName = dataSnapshot.value
                self.charityNames.insert(charityName as! String, at: 0)
                self.charityTableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    @objc func changeScreens(){
        for view in view.subviews {
            view.removeFromSuperview()
        }
        let mathPage = ViewController()
        mathPage.modalPresentationStyle = .fullScreen
        self.present(mathPage, animated: true, completion: nil)
        if selectedCharity == "" {
            if self.charityNames.count > 0{
                selectedCharity = self.charityNames[0]
            } else {
                selectedCharity = "National Police Accountability Project"
            }
        }
        if selectedDifficulty == "" {
            selectedDifficulty = "Easy"
        }
        startTime = Date()
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            logo.bottomAnchor.constraint(equalTo: header.topAnchor, constant: -27),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 80),
            logo.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalToConstant: 305),
            header.heightAnchor.constraint(equalToConstant: 43),
            header.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            details.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            details.widthAnchor.constraint(equalToConstant: 274),
            details.heightAnchor.constraint(equalToConstant: 50),
            details.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            medButton.topAnchor.constraint(equalTo: details.bottomAnchor, constant: 10),
            medButton.widthAnchor.constraint(equalToConstant: 75),
            medButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            medButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            easyButton.topAnchor.constraint(equalTo: details.bottomAnchor, constant: 10),
            easyButton.widthAnchor.constraint(equalToConstant: 75),
            easyButton.trailingAnchor.constraint(equalTo: medButton.leadingAnchor, constant: -10),
            easyButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            hardButton.topAnchor.constraint(equalTo: details.bottomAnchor, constant: 10),
            hardButton.widthAnchor.constraint(equalToConstant: 75),
            hardButton.leadingAnchor.constraint(equalTo: medButton.trailingAnchor, constant: 10),
            hardButton.heightAnchor.constraint(equalToConstant: 30)
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
            arrowLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            charityTableView.topAnchor.constraint(equalTo: easyButton.bottomAnchor, constant: 10),
            charityTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            charityTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            charityTableView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
}

extension IntroScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charityNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//        let charity = charities[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.text = charityNames[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "Comfortaa-Regular", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCharity = charityNames[indexPath.row]
    }
}
