//
//  ViewController.swift
//  AuthorizationApp
//
//  Created by Grigore on 09.04.2023.
//

import UIKit



class AuthorizationViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logInLabel: UILabel = {
        let label = UILabel()
        
        label.text = "LogIn"
        label.font = UIFont(name: "Avenir Next Bold", size: 20)
        label.tintColor = .blue
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mailTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Enter your email adress"
        textField.borderStyle = .roundedRect
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Enter password"
        textField.borderStyle = .roundedRect
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
   private  let signInButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .orange
        button.setTitle("SignIn", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
  private  let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = .systemYellow
        button.setTitle("SignUp", for: .normal)
        button.tintColor = .blue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var stackViewTextFields = UIStackView()
    private var stackViewButtons = UIStackView()
    
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpDelegates()
        setConstraints()
        registerKeyBoardNotification()
        
    }
    
    deinit {
        removeKeyBoardNotification()
    }
    
    //MARK: -
    
    private func setUpViews() {
        stackViewTextFields = UIStackView(arangedSubViews: [mailTextField, passwordTextField], axis: .vertical, spacing: 10, distribution: .fillProportionally)
        stackViewButtons = UIStackView(arangedSubViews: [signInButton, signUpButton], axis: .horizontal, spacing: 10, distribution: .fillEqually)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(logInLabel)
        backgroundView.addSubview(stackViewTextFields)
        backgroundView.addSubview(stackViewButtons)
    }
    
    private func setUpDelegates() {
        mailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @objc func signInButtonTapped() {
        
        let mail = mailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let user = findUserDataBase(mail: mail)

        if user == nil {
            logInLabel.text = "User not found"
            logInLabel.textColor = .red
        } else if user?.password == password {
            let navVC = UINavigationController(rootViewController: AlbumsViewController())
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: true)

            guard let activeUser = user else { return }
            DataBase.shared.saveActiveuser(user: activeUser)

        } else {
            logInLabel.text = "Wrong Password"
            logInLabel.textColor = .red
        }
        
    }
    
    //mthod that helps to find user in our custom Database
    private func findUserDataBase(mail: String) -> User? {

        let dataBase = DataBase.shared.users
        print(dataBase)
        
        for user in dataBase {
            if user.mail == mail {
                return user
            }
        }
        return nil
    }
    
    
    @objc func signUpButtonTapped() {
        let signUpVC = SignUpViewController()
        present(signUpVC, animated: true)
    }

}

//MARK: - UI TEXT FIELD DELEGATES
//ca sa pot inchide tastatura prin butonul ,,return,,

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    
}

//MARK: - lucrez cu tastatura, (observer) cand apare tastatura scrollul sa se mute in sus

extension AuthorizationViewController {
    
    private func registerKeyBoardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, //trebuei sa inteleg cand tastatura mea se va ridica
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillDissapear),
                                               name: UIResponder.keyboardWillHideNotification, //trebuei sa inteleg cand tastatura mea se va da in jos
                                               object: nil)
        
        
        //in rezultat cand tastatura mea va aparea(1 metoda sus) sau va disparea(2 metoda sus) ma va pointera in metoda de mai jos
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyBoardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        scrollView.contentOffset = CGPoint(x: 0, y: keyBoardHeight.height / 2)
    }
    
    @objc private func keyboardWillDissapear(notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
    
    private func removeKeyBoardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: - SET CONSTRAINTS

extension AuthorizationViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackViewTextFields.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            stackViewTextFields.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            stackViewButtons.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            stackViewButtons.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            logInLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            logInLabel.bottomAnchor.constraint(equalTo: stackViewTextFields.topAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            stackViewButtons.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            stackViewButtons.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor,constant: -20),
            stackViewButtons.topAnchor.constraint(equalTo: stackViewTextFields.bottomAnchor, constant: 30)
        ])
    }
}

