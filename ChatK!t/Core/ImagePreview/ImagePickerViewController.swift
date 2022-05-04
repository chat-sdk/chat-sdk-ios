//
//  BImagePicker.swift
//  ChatK!t
//
//  Created by Ben on 04/05/2022.
//

import Foundation

public class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addChild(picker)
        view.addSubview(picker.view)
        picker.didMove(toParent: self)
    }
    
}
