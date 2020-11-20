//
//  PhotoSourceActionSheet.swift
//  ChatSDK
//
//  Created by ben3 on 18/11/2020.
//

import Foundation
import UIKit

@objc public class PhotoSourceActionSheet: NSObject {
    
    @objc public func get(onPick: @escaping ((UIImagePickerController.SourceType) -> Void), sourceView: UIView? = nil) -> UIAlertController {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.modalPresentationStyle = .popover
        if let presentation = optionMenu.popoverPresentationController {
            presentation.sourceView = sourceView
        }

        let cameraAction = UIAlertAction(title: Bundle.t(bTakePhoto), style: .default, handler: { alert in
            onPick(.camera)
        })

        let photoLibraryAction = UIAlertAction(title: Bundle.t(bPhotoLibrary), style: .default, handler: { alert in
            onPick(.photoLibrary)
        })

        let SavedPhotosAction = UIAlertAction(title: Bundle.t(bPhotoAlbum), style: .default, handler: { alert in
            onPick(.savedPhotosAlbum)
        })

        let cancelAction = UIAlertAction(title: Bundle.t(bCancel), style: .cancel, handler: { alert in
            optionMenu.dismiss(animated: true, completion: nil)
        })

        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(SavedPhotosAction)
        optionMenu.addAction(cancelAction)
        
        return optionMenu
    }
    
}
