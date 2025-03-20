//
//  LoginViewController.swift
//  AuthFirebaseUser
//
//  Created by Николай Гринько on 19.03.2025.
//

// https://github.com/firebase/firebase-ios-sdk - подключение библиотеки(либы)

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase

/// Создаем экран входа через Firebase Google
/// Авторизованный пользователь в Firebase - (login - grinya37@yandex.ru, password - 2580grinyA2580 )
class LoginViewController: UIViewController {
    
    /// Создание обьектов
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let emailFields: UITextField = {
        let emaiField = UITextField()
        emaiField.placeholder = "Email Adress"
        emaiField.layer.borderWidth = 1
        emaiField.autocapitalizationType = .none
        emaiField.layer.borderColor = UIColor.black.cgColor
        emaiField.backgroundColor = .white
        emaiField.leftViewMode = .always
        emaiField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emaiField
    }()
    
    private let passwordField: UITextField = {
        let passField = UITextField()
        passField.placeholder = "Password"
        passField.layer.borderWidth = 1
        passField.autocapitalizationType = .none
        passField.isSecureTextEntry = true
        passField.layer.borderColor = UIColor.black.cgColor
        passField.backgroundColor = .white
        passField.leftViewMode = .always
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return passField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LogOut", for: .normal)
        return button
    }()
    
    private let entranceSystemButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .systemGreen
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitle("LogOut", for: .normal)
        return button
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "google"), for: .normal)
        // button.setTitle("Войти через Google", for: .normal)
        // button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(label)
        view.addSubview(emailFields)
        view.addSubview(passwordField)
        view.addSubview(button)
        view.addSubview(entranceSystemButton)
        
        setupLayouts()
        entranceSystemButton.frame = CGRect(x: 20,
                                            y: 400,
                                            width: view.frame.size.width-40,
                                            height: 52)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        entranceSystemButton.addTarget(self, action: #selector(tapExtranceButton), for: .touchUpInside)
        signOutButton.layer.cornerRadius = 8
        
        viewFraneObject()
        tapButtonSignOut()
    }
    
    
    @objc private func signInTapped() {
        print("tap Googleeee")
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("❌ Ошибка входа: \(error.localizedDescription)")
                return
            }
            guard let result = signInResult else {
                print("❌ signInResult = nil")
                return
            }
            print("✅ Авторизация успешна!")
            
            let user = result.user
            let userProfile = UserProfile(name: user.profile?.name ?? "Нет имени",
                                          email: user.profile?.email ?? "Нет email",
                                          imageURL: user.profile?.imageURL(withDimension: 100))
            let profileVC = ProfileViewController(user: userProfile)
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    // Оборачиваем его в UINavigationController и переходим после авторизации во ViewController
    @objc private func tapExtranceButton() {
        let vc = ViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen // Для полноэкранного отображения
        self.present(navigationController, animated: true, completion: nil)
    }
    
    /// Установка констреентов для кнопки
    private func setupLayouts() {
        view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 50),
            signInButton.widthAnchor.constraint(equalToConstant: 80),
            signInButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    /// Авторизация пользователя и сокрытие окон ввода данных
    private func tapButtonSignOut() {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            label.isHidden = true
            button.isHidden = true
            emailFields.isHidden = true
            passwordField.isHidden = true
            
            view.addSubview(signOutButton)
            
            signOutButton.frame = CGRect(x: 20,
                                         y: 150,
                                         width: view.frame.size.width-40,
                                         height: 52)
            signOutButton.layer.cornerRadius = 8
            signOutButton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        }
    }
    
    @objc private func logOutTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            label.isHidden = false
            button.isHidden = false
            emailFields.isHidden = false
            passwordField.isHidden = false
            
            signOutButton.removeFromSuperview()
        } catch {
            print("An error occurred")
        }
    }
    
    /// Установка Frame обьектам ввода данных
    private func viewFraneObject() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0,
                             y: 100,
                             width: view.frame.size.width,
                             height: 80)
        emailFields.frame = CGRect(x: 20,
                                   y: label.frame.origin.y+label.frame.size.height+10,
                                   width: view.frame.size.width-40,
                                   height: 50)
        passwordField.frame = CGRect(x: 20,
                                     y: emailFields.frame.origin.y+emailFields.frame.size.height+10,
                                     width: view.frame.size.width-40,
                                     height: 50)
        button.frame = CGRect(x: 20,
                              y: passwordField.frame.origin.y+passwordField.frame.size.height+30,
                              width: view.frame.size.width-40,
                              height: 52)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            emailFields.becomeFirstResponder()
        }
    }
    
    @objc private func didTapButton() {
        print("Continue button tapped")
        guard let email = emailFields.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("Missing field data")
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            print("You have signed in")
            strongSelf.label.isHidden = true
            strongSelf.emailFields.isHidden = true
            strongSelf.passwordField.isHidden = true
            strongSelf.button.isHidden = true
            
            strongSelf.entranceSystemButton.isHidden = true
            
            strongSelf.emailFields.resignFirstResponder()
            strongSelf.passwordField.resignFirstResponder()
            
            let vc = ViewController()
            
            // Оборачиваем его в UINavigationController
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen // Для полноэкранного отображения
            self?.present(navigationController, animated: true, completion: nil)
        }
    }
    
    /// Метод проверки данных нового пользователя и выводения Alert разрешения на авторизацию
    private func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    print("Account creation failed")
                    return
                }
                print("You have signed ")
                strongSelf.label.isHidden = true
                strongSelf.emailFields.isHidden = true
                strongSelf.passwordField.isHidden = true
                strongSelf.button.isHidden = true
                
                strongSelf.emailFields.resignFirstResponder()
                strongSelf.passwordField.resignFirstResponder()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        present(alert, animated: true)
    }
}

