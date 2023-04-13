//
//  UserInfoViewController.swift
//  AuthorizationApp
//
//  Created by Grigore on 09.04.2023.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    private let firstNameLabel: UILabel = {
       let label = UILabel()
        
        label.text = "first Name"
        label.backgroundColor = .red
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastNAmeLabel: UILabel = {
       let label = UILabel()
        label.text = "second Name"
        label.backgroundColor = .red
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageLabel: UILabel = {
       let label = UILabel()
        label.text = "age"
        label.backgroundColor = .red
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneLabel: UILabel = {
       let label = UILabel()
        label.text = "phone nr"
        label.backgroundColor = .red
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mailLabel: UILabel = {
       let label = UILabel()
        label.text = "Email"
        label.backgroundColor = .red
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordLabel: UILabel = {
       let label = UILabel()
        label.text = "password"
        label.backgroundColor = .red
        label.clipsToBounds = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        setUpView()
        setConstraints()
        setModel()
    }
    
    func setUpView() {
        
        stackView = UIStackView(arangedSubViews: [firstNameLabel, lastNAmeLabel,ageLabel,phoneLabel,mailLabel,passwordLabel], axis: .vertical, spacing: 10, distribution: .fillProportionally)
        
        view.addSubview(stackView)
    }
    
    
    private func setModel() {
        guard let activeUser = DataBase.shared.activeUser else { return }
        
        //pentru ca date' e in formatul Date(),
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM,yyyy"
        let dateString = dateFormatter.string(from: activeUser.age)
        
        firstNameLabel.text = activeUser.firstName
        lastNAmeLabel.text = activeUser.lastName
        phoneLabel.text = activeUser.phone
        mailLabel.text = activeUser.mail
        passwordLabel.text = activeUser.password
        ageLabel.text = dateString
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
}
