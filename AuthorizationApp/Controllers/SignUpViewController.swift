//
//  SignUpViewController.swift
//  AuthorizationApp
//
//  Created by Grigore on 09.04.2023.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let registrationLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Registration"
        label.font = UIFont(name: "Avenir Next Bold", size: 20)
        label.tintColor = .black
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "First Name"
        textField.borderStyle = .roundedRect
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let firstNameValidLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Required Field"
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Last Name"
        textField.borderStyle = .roundedRect
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let lastNameValidLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Required Field"
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageValidLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Required Field"
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Phone"
        textField.borderStyle = .roundedRect
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let phoneValidLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Required Field"
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mailTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "E-mail"
        textField.borderStyle = .roundedRect
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let mailValidLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Required Field"
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordValidLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Required Field"
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 0.8030825151)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var elementsStackView = UIStackView()
    let datePicker = UIDatePicker()
    
    // apelez svoistga me (regex), fac legatura cu extensionu meu creat pentru String
    let nameValidType: String.ValidTypes = .name
    let mailValidType: String.ValidTypes = .mail
    let passwordValidType: String.ValidTypes = .password
    let phoneValidType: String.ValidTypes = .phone
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpDelegates()
        setUpDatePicker()
        setConstraints()
        registerKeyBoardNotification()
    }
    
    deinit {
        removeKeyBoardNotification()
    }
    
    
    //MARK: - Functionalitatea la sign UP Button
    
    @objc func signUpButtonTapped() {
        //mai intai verific daca toate campurile sunt valide, apoi efectuez functionalitatea propriu zisa, adica salvez userul
        let firstNameText = firstNameTextField.text ?? ""
        let lastNameText = lastNameTextField.text ?? ""
        let phoneText = phoneTextField.text ?? ""
        let mailText = mailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        
        if firstNameText.isValid(validType: nameValidType)
            && lastNameText.isValid(validType: nameValidType)
            && phoneText.count == 17
            && mailText.isValid(validType: mailValidType)
            && passwordText.isValid(validType: passwordValidType)
            && ageISValid() == true {
            
            DataBase.shared.saveUser(firstName: firstNameText,
                                     lastName: lastNameText,
                                     phone: phoneText,
                                     mail: mailText,
                                     password: passwordText,
                                     age: datePicker.date)
            
            registrationLabel.text = "Complited"
            alertOk(title: "Complited", message: "You have Signed UP")
        } else {
            registrationLabel.text = "Registration"
            alertOk(title: "Error", message: "Fill in all the fields and your age must be 18+ y.o.")
        }
        
    }
    
    private func setUpViews() {
        elementsStackView = UIStackView(arangedSubViews: [firstNameTextField,firstNameValidLabel,lastNameTextField,lastNameValidLabel,datePicker,ageValidLabel,phoneTextField,phoneValidLabel,mailTextField,mailValidLabel,passwordTextField,passwordValidLabel], axis: .vertical, spacing: 10, distribution: .fillProportionally)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(registrationLabel)
        backgroundView.addSubview(elementsStackView)
        backgroundView.addSubview(signUpButton)
    }
    
    private func setUpDelegates() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneTextField.delegate = self
        mailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setUpDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 0.7987160121)
        datePicker.layer.borderColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        datePicker.layer.borderWidth = 2
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 10
        datePicker.tintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
    }
    
    private func setTextFieldTypeing(textField: UITextField, label: UILabel, validType: String.ValidTypes, validMessage: String, wrogMessage: String, string: String, range: NSRange) {
        
        let text = (textField.text ?? "") + string
        let result: String
        
        //aceasta ,,range,, cand adaug simboluri este egala cu 0, cand sterg simbolurile se face 1, de aceea
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex ..< end])
        } else {
            result = text
        }
        
        textField.text = result
        
        
        if result.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        } else {
            label.text = wrogMessage
            label.textColor = .red
        }
    }
    
    private func setPhoneMask(textField: UITextField, mask: String, string: String, range: NSRange) -> String {
        
        let text = textField.text ?? ""
        
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = number.startIndex
        
        for charcacter in mask where index < number.endIndex {
            if charcacter == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(charcacter)
            }
        }
        
        if result.count == 17 {  //nr la toate simbolurile
            phoneValidLabel.text = "Phone is Valid"
            phoneValidLabel.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        } else {
            phoneValidLabel.text = "Phone is Not Valid"
            phoneValidLabel.textColor = .red
        }
        return result
    }
    
    private func ageISValid() -> Bool {
        //trebuiesa inteleg daca de la data didLoad pana la data cand indica userul a trecut 18 ani sau nu?!
        
        let calendar = NSCalendar.current
        let dateNow = Date()
        let birthDay = datePicker.date
        
        let age = calendar.dateComponents([.year], from: birthDay, to: dateNow)
        let ageYear = age.year
        guard let ageUser = ageYear else { return false }
        
        return (ageUser < 18 ? false : true)
    }
}



//MARK: - setez delegates pentru textFields

extension SignUpViewController: UITextFieldDelegate {
    
    //verifica validarea campurilor la sign up
    
    //aceasta metoda percepe caract noastre ce le intrduc de pe atstatura.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firstNameTextField: setTextFieldTypeing(textField: firstNameTextField,
                                                     label: firstNameValidLabel,
                                                     validType: nameValidType,
                                                     validMessage: "First Name is Valid",
                                                     wrogMessage: "Only A-Z characters, min 1 character",
                                                     string: string,
                                                     range: range)
        case lastNameTextField: setTextFieldTypeing(textField: lastNameTextField,
                                                     label: lastNameValidLabel,
                                                     validType: nameValidType,
                                                     validMessage: "Last Name is Valid",
                                                     wrogMessage: "Only A-Z characters, min 1 character",
                                                     string: string,
                                                     range: range)
        case mailTextField: setTextFieldTypeing(textField: mailTextField,
                                                     label: mailValidLabel,
                                                     validType: mailValidType,
                                                     validMessage: "Email is Valid",
                                                     wrogMessage: "Email is not valid",
                                                     string: string,
                                                     range: range)
        case passwordTextField: setTextFieldTypeing(textField: passwordTextField,
                                                     label: passwordValidLabel,
                                                     validType: passwordValidType,
                                                     validMessage: "Password is Valid",
                                                     wrogMessage: "6 characters,1 symbol,1 UpCas,1 number",
                                                     string: string,
                                                     range: range)
            
        case phoneTextField: phoneTextField.text = setPhoneMask(textField: phoneTextField,
                                                                mask: "+XXX (XX) XXX XXX",
                                                                string: string,
                                                                range: range)
        default:
            break
        }
        
        return false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        mailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}



//MARK: - CONSTRAINTS

extension SignUpViewController {
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
            elementsStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            elementsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            elementsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor,constant: 20),
            elementsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor,constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            registrationLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            registrationLabel.bottomAnchor.constraint(equalTo: elementsStackView.topAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: elementsStackView.bottomAnchor, constant: 30),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.widthAnchor.constraint(equalToConstant: 300)
        ])
        
    }
}

//MARK: - LUCRUL CU TASTATURA:D

extension SignUpViewController {
    
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
