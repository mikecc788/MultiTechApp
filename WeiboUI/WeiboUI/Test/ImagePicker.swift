//
//  ImagePicker.swift
//  WeiboUI
//
//  Created by app on 2022/12/6.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    class Coordinator :NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
    }
}
