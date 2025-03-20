//
//  EditorView.swift
//  AuthFirebaseUser
//
//  Created by Николай Гринько on 19.03.2025.
//

import UIKit
import PencilKit

/// Добавил экран редактирования изображения.
class EditorView: UIViewController {
    
    private var imageView: UIImageView!
    private var drawingView: PKCanvasView!
    private var currentImage: UIImage
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Применить фильтр", for: .normal)
        button.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        return button
    }()
    
    init(image: UIImage) {
        self.currentImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) не реализован") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupImageView()
        setupDrawingView()
        setupButtons()
    }
    
    /// Констреенты imageView
    private func setupImageView() {
        imageView = UIImageView(image: currentImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    /// Метод который фиксирует ввод Apple Pencil и отображает отображенные результаты
    private func setupDrawingView() {
        drawingView = PKCanvasView()
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        drawingView.isOpaque = false
        view.addSubview(drawingView)
        
        NSLayoutConstraint.activate([
            drawingView.topAnchor.constraint(equalTo: imageView.topAnchor),
            drawingView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            drawingView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            drawingView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
    }
    
    /// Создает stack и устанавливает констреенты для кнопок вызова методов
    private func setupButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        
        stackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(saveButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// 📌 Применяет фильтр к изображению
    @objc private func applyFilter() {
        print("🎨 Применяем фильтр...")
        if let filteredImage = FilterManager.applyFilter(to: currentImage, filterName: "CIPhotoEffectNoir") {
            imageView.image = filteredImage
            currentImage = filteredImage
        } else {
            print("❌ Ошибка применения фильтра")
        }
    }
    
    /// 📌 Сохраняет изображение
    @objc private func saveImage() {
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let editedImage = renderer.image { _ in
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
            drawingView.drawHierarchy(in: drawingView.bounds, afterScreenUpdates: true)
        }
        
        UIImageWriteToSavedPhotosAlbum(editedImage, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /// 📌 Показывает уведомление и возвращает пользователя на главный экран после сохранения
    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("❌ Ошибка сохранения: \(error.localizedDescription)")
            return
        }
        
        let alert = UIAlertController(title: "Готово!", message: "Изображение сохранено в Фотоальбом.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

