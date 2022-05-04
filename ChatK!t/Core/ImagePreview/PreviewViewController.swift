//
//  PreviewViewController.swift
//  ChatSDK
//
//  Created by Ben on 04/05/2022.
//

import Foundation
import UIKit
import ZLImageEditor
import NextGrowingTextView
import AVFoundation

public class PreviewViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    open var imageView = UIImageView()
    open var image: UIImage?
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var captionTextView: NextGrowingTextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    open var picker = UIImagePickerController()
    
    open var didFinishPicking: ((UIImage?) -> Void)?
    
    // We use a fake picker so as this view is showing modally, it can
    // show the picker UI. at the
    let fake = UIImagePickerController()
    
    public init(image: UIImage? = nil, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.image = image
        super.init(nibName: nibNameOrNil ?? String(describing: PreviewViewController.self), bundle: nibBundleOrNil ?? Bundle(for: PreviewViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image

        scrollView.addSubview(imageView)
        
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 6.0;

        center(scrollView: scrollView)
        
        editButton.isHidden = !ChatKit.config().imageEditorEnabled
        
        captionTextView.isHidden = true
        
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        if image == nil {
            addChild(fake)
            view.addSubview(fake.view)
            fake.didMove(toParent: self)
        }
        
    }
    
    public func centerImage() {
        if let image = image {
            let iw = image.size.width
            let ih = image.size.height
            
            let sw = UIScreen.main.bounds.width
            let sh = UIScreen.main.bounds.height

            // Get the AR of the image
            let imageAR = iw / ih
            let screenAR = sw / sh
            
            var w = sw
            var h = sh
            
            if imageAR > screenAR {
                h = w / imageAR
            } else {
                w = h * imageAR
            }

            imageView.keepWidth.equal = w
            imageView.keepHeight.equal = h
                    
            // Get the dimensions of the image
            scrollView.contentSize = CGSize(width: w, height: h)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerImage()
        center(scrollView: scrollView)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if image == nil {
            present(picker, animated: false, completion: { [weak self] in
                self?.fake.willMove(toParent: nil)
                self?.fake.view.removeFromSuperview()
                self?.fake.removeFromParent()
            })
        }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
        
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        center(scrollView: scrollView)
    }
    
    public func center(scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if let image = image {
            ZLEditImageViewController.showEditImageVC(parentVC: self, animate: false, image: image, editModel: nil) { [weak self] (resImage, editModel) in
                self?.setImage(resImage)
            }
        }
    }
    
    public func setImage(_ image: UIImage) {
        self.image = image
        self.imageView.image = image
        centerImage()
        center(scrollView: scrollView)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        didFinishPicking?(image)
        dismiss(animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if image == nil {
            view.isHidden = true
            picker.dismiss(animated: true, completion: { [weak self] in
                self?.dismiss(animated: true)
            })
        } else {
            picker.dismiss(animated: true)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let type = info[.mediaType] as? String, type == "public.image" {
            if let image = info[.editedImage] as? UIImage {
                setImage(image)
            }
            if let image = info[.originalImage] as? UIImage {
                setImage(image)
            }
        } else {
            if let videoURL = info[.mediaURL] as? URL {
//                let coverImage =
            }
        }
        picker.dismiss(animated: true)
    }
    
    public func setDidFinishPicking(_ callback: @escaping ((UIImage?) -> Void)) {
        didFinishPicking = callback
    }
    
    public func thumbnail(_ url: URL) {
        let asset = AVURLAsset(url: url)
        
//        let ig = ALAssetImage
        
        
    }
}
