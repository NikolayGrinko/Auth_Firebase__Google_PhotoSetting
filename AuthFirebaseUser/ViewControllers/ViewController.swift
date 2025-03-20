//
//  ViewController.swift
//  AuthFirebaseUser
//
//  Created by Николай Гринько on 19.03.2025.
//

import UIKit
import FirebaseAuth

/// Создал главный экран с кнопками для выбора изображения.
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// Создание обьектов
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LogOut", for: .normal)
        return button
    }()
    
    /// Кнопка выбора изображения
    lazy var selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выбрать изображение", for: .normal)
        button.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(logOutButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(signOutTapButton))
        setupLayout()
    }
    
    /// Установка констреентов - selectImageButton (кнопка выбора фото)
    private func setupLayout() {
        view.addSubview(selectImageButton)
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectImageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func selectImageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    /// Выбрано фото и переход в редактор
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            print("✅ Изображение выбрано, переходим в EditorView")
            let editorVC = EditorView(image: selectedImage)
            navigationController?.pushViewController(editorVC, animated: true)
        } else {
            print("❌ Ошибка: изображение не выбрано")
        }
    }
    
    @objc private func signOutTapButton() {
        print("signOutTapButton")
        
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            let vc = LoginViewController()
            // Оборачиваем его в UINavigationController
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen // Для полноэкранного отображения
            self.present(navigationController, animated: true, completion: nil)
        } catch {
            print("An error occurred")
        }
    }
    
}
