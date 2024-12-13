//
//  ViewController.swift
//  ImageML
//
//  Created by app on 2024/11/27.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textL: UILabel!
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        // 添加选择图片按钮
        let selectButton = UIButton(frame: CGRect(x: 20, y: view.frame.height - 100, width: view.frame.width - 40, height: 50))
        selectButton.setTitle("选择图片", for: .normal)
        selectButton.backgroundColor = .systemBlue
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        view.addSubview(selectButton)
    }
    @objc func selectButtonTapped() {
        present(imagePicker, animated: true)
    }
    // 处理选中的图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
            classifyImage(selectedImage)
        }
        picker.dismiss(animated: true)
    }
        
    // 图像分类函数
    func classifyImage(_ image: UIImage) {
        // 确保图片有效
        guard let ciImage = CIImage(image: image) else {
            textL.text = "无法处理该图片"
            return
        }
        
        // 加载Core ML模型
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            textL.text = "无法加载模型"
            return
        }
        
        // 创建图像分类请求
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self?.textL.text = "分类失败"
                return
            }
            
            // 在主线程更新UI
            DispatchQueue.main.async {
                // 显示最可能的分类结果和置信度
                let confidence = Int(topResult.confidence * 100)
                let identifier = topResult.identifier.components(separatedBy: ",")[0]
    
                self?.textL.text = "识别结果: \(identifier)\n置信度: \(confidence)%"
            }
        }
        
        // 执行请求
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            textL.text = "分析失败: \(error.localizedDescription)"
        }
    }
}
