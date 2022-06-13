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
import WPMediaPicker
import AVKit

public enum PreviewMode {
    case image, video
}

open class PreviewItem: NSObject {
    
    open var id: String
    open var image: UIImage?
    open var asset: AVURLAsset?
    open var duration: TimeInterval = 0
    
    public init(identifier: String, image: UIImage?) {
        id = identifier
        self.image = image
        super.init()
    }

    public init(identifier: String, asset: AVURLAsset?, duration: TimeInterval) {
        id = identifier
        self.duration = duration
        super.init()
        setAsset(asset)
    }
    
    public func setAsset(_ asset: AVURLAsset?) {
        self.asset = asset
        if let asset = asset {
            image = AssetHelper.thumbnailFor(asset: asset, time: 0)
        }
    }
    
    public static func == (lhs: PreviewItem, rhs: PreviewItem) -> Bool {
        return lhs.id == rhs.id
//        if let i1 = lhs.image, let i2 = rhs.image {
//            return i1.isEqual(i2)
//        }
//        if let a1 = lhs.asset, let a2 = rhs.asset {
//            return a1.isEqual(a2)
//        }
//        return false
    }
        
}

open class PreviewViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WPMediaPickerViewControllerDelegate {
    
    open var imageView = UIImageView()
    
    @IBOutlet open weak var editButton: UIButton!
    @IBOutlet open weak var deleteButton: UIButton!
//    @IBOutlet weak var captionTextView: NextGrowingTextView!
    @IBOutlet open weak var scrollView: UIScrollView!
    
    @IBOutlet open weak var pageIndicator: UILabel!
    
    open var didFinishPickingImages: (([UIImage]) -> Void)?
    open var didFinishPickingVideos: (([AVURLAsset]) -> Void)?

    public let mode: PreviewMode
    open var fake: WPNavigationMediaPickerViewController?

    open var items = [PreviewItem]()
    open var views = [PreviewItem: PreviewView]()
    
    public init(mode: PreviewMode, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.mode = mode

        super.init(nibName: nibNameOrNil ?? String(describing: PreviewViewController.self), bundle: nibBundleOrNil ?? Bundle(for: PreviewViewController.self))
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        scrollView.addSubview(imageView)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        
//        scrollView.minimumZoomScale = 1.0;
//        scrollView.maximumZoomScale = 6.0;
//        center(scrollView: scrollView)
        
//        editButton.isHidden = !ChatKit.config().imageEditorEnabled
        
//        captionTextView.isHidden = true

        let options = WPMediaPickerOptions()
        options.showMostRecentFirst = true
        options.allowCaptureOfMedia = true
        options.allowMultipleSelection = true
        options.showSearchBar = false
        options.showActionBar = false

        if mode == .image {
            options.filter = WPMediaType.image
        }
        // Video
        if mode == .video {
            options.filter = WPMediaType.video
        }
//        picker = WPNavigationMediaPickerViewController(options: options)
//        picker?.delegate = self
        
        // We use a fake picker so as this view is showing modally, it can
        // show the picker UI. at the
        fake = WPNavigationMediaPickerViewController(options: options)
        fake?.delegate = self
        
        if let fake = fake {
            addChild(fake)
            view.addSubview(fake.view)
            
            fake.view.keepInsets.equal = 0
            
            fake.didMove(toParent: self)
            fake.delegate = self;
        }
        
    }
    
//    public func centerImage() {
//        if let image = image {
//            let iw = image.size.width
//            let ih = image.size.height
//
//            let sw = UIScreen.main.bounds.width
//            let sh = UIScreen.main.bounds.height
//
//            // Get the AR of the image
//            let imageAR = iw / ih
//            let screenAR = sw / sh
//
//            var w = sw
//            var h = sh
//
//            if imageAR > screenAR {
//                h = w / imageAR
//            } else {
//                w = h * imageAR
//            }
//
//            imageView.keepWidth.equal = w
//            imageView.keepHeight.equal = h
//
//            // Get the dimensions of the image
//            scrollView.contentSize = CGSize(width: w, height: h)
//        }
//    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        centerImage()
//        center(scrollView: scrollView)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//
//    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        center(scrollView: scrollView)
//    }
    
//    public func center(scrollView: UIScrollView) {
//        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
//        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
//        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
//    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
//        if let image = image {
//            ZLEditImageViewController.showEditImageVC(parentVC: self, animate: false, image: image, editModel: nil) { [weak self] (resImage, editModel) in
//                self?.setImage(resImage)
//            }
//        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        // Get the current page
        let index = currentPage()
        if index >= 0 && index < items.count {
            items.remove(at: index)
        }
        if items.isEmpty {
            dismiss(animated: true)
        }
        updateScrollView()
    }
    
    public func addOrUpdate(id: String, image: UIImage) {
        let item = item(for: id) ?? PreviewItem(identifier: id, image: image)
        item.image = image
        addItem(item: item)
    }

    public func addOrUpdate(id: String, asset: AVURLAsset?, image: UIImage? = nil, duration: TimeInterval) {
        let item = item(for: id) ?? PreviewItem(identifier: id, asset: asset, duration: duration)
        item.setAsset(asset)
        item.duration = duration
        addItem(item: item)
    }

    public func item(for id: String) -> PreviewItem? {
        for item in items {
            if item.id == id {
                return item
            }
        }
        return nil
    }
    
    public func addItem(item: PreviewItem) {
        var scrollTo = false
        if !items.contains(item) {
            items.append(item)
            scrollTo = true
        }
        updateScrollView(scrollTo: scrollTo)
    }
    
    public func updateScrollView(scrollTo:Bool = false) {
        var i = 0
        let width = Float(scrollView.frame.width)
        let height = Float(scrollView.frame.height)
        for item in items {
            
            var view = views[item]
            if view == nil {
                view = .fromNib()
                views[item] = view
                scrollView.addSubview(view!)
            }
            
            view?.play = { [weak self] in
                self?.playVideo(item: item)
            }
            
            view?.setViewFrameX(Float(i) * width)
            view?.setViewFrameY(0)
            view?.setViewFrameHeight(height)
            view?.setViewFrameWidth(width)

            view?.bind(item: item)
            i += 1
        }
        scrollView.contentSize = CGSize(width: CGFloat(width) * CGFloat(i), height: scrollView.frame.height)
        if scrollTo {
            scrollView.setContentOffset(CGPoint(x: CGFloat(width) * CGFloat(i - 1), y: 0), animated: false)
        }
        updateTextPosition()
    }
    
    open func playVideo(item: PreviewItem) {
        if let asset = item.asset {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                let fileURL = URL(fileURLWithPath: asset.url.path)
                
                let player = AVPlayer(url: fileURL.absoluteURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                present(playerController, animated: true, completion: nil)
            } catch {
                showError(error: error)
            }
        }
    }
        
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
//        present(picker, animated: true, completion: nil)
//        fake?.view.isHidden = false
        showPicker(duration: 0.5)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if mode == .image {
            var images = [UIImage]()
            for item in items {
                if let image = item.image {
                    images.append(image)
                }
            }
            didFinishPickingImages?(images)
        }
        if mode == .video {
            var assets = [AVURLAsset]()
            for item in items {
                if let asset = item.asset {
                    assets.append(asset)
                }
            }
            didFinishPickingVideos?(assets)
        }
        dismiss(animated: true)
    }
    
    func fixImageOrientation(_ image: UIImage)->UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fake?.viewDidLayoutSubviews()
    }
    
    public func setDidFinishPicking(images callback: @escaping (([UIImage]) -> Void)) {
        didFinishPickingImages = callback
    }

    public func setDidFinishPicking(videos callback: @escaping (([AVURLAsset]) -> Void)) {
        didFinishPickingVideos = callback
    }

    public func thumbnail(_ url: URL) {
        let asset = AVURLAsset(url: url)
        
//        let ig = ALAssetImage
        
        
    }
    
    public func mediaPickerControllerDidCancel(_ picker: WPMediaPickerViewController) {
        if items.isEmpty {
            dismiss(animated: true)
        } else {
            hidePicker(duration: 0.5)
        }
    }
    
    public func mediaPickerController(_ picker: WPMediaPickerViewController, didFinishPicking assets: [WPMediaAsset]) {
        for asset in assets {
            if asset.assetType() == .image {
                // TODO: Check this... is it too small?
                asset.image(with: scrollView.contentSize, completionHandler: { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let image = image {
                            self?.addOrUpdate(id: asset.identifier(), image: image)
                        }
                        if let error = error {
                            self?.showError(message: error.localizedDescription)
                        }
                    }
                })
            }
            if asset.assetType() == .video {
                
                asset.image(with: scrollView.contentSize, completionHandler: { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let image = image {
                            self?.addOrUpdate(id: asset.identifier(), asset: nil, image: image, duration: asset.duration())
                        }
                        if let error = error {
                            self?.showError(message: error.localizedDescription)
                        }
                    }
                })
                asset.videoAsset(completionHandler: { [weak self] video, error in
                    DispatchQueue.main.async {
                        if let assetURL = video as? AVURLAsset {
                            self?.addOrUpdate(id: asset.identifier(), asset: assetURL, duration: asset.duration())
                        }
                        if let error = error {
                            self?.showError(message: error.localizedDescription)
                        }
                    }
                })
            }
        }
        picker.clearSelectedAssets(false)
//        picker.dismiss(animated: true)
//        fake?.view.isHidden = true
        hidePicker(duration: 0.5)
  }
    
    public func hidePicker(duration: CGFloat = 0) {
        UIView.animate(withDuration: duration, delay: 0, animations: { [weak self] in
            self?.fake?.view.alpha = 0
        })
    }

    public func showPicker(duration: CGFloat = 0) {
        UIView.animate(withDuration: duration, delay: 0, animations: { [weak self] in
            self?.fake?.view.alpha = 1
        })
    }

//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        if items.isEmpty {
//            dismiss(animated: true)
////
////            view.isHidden = true
////            picker.dismiss(animated: true, completion: { [weak self] in
////                self?.dismiss(animated: true)
////            })
//        } else {
////            picker.dismiss(animated: true)
//            hidePicker(duration: 0.5)
//        }
//    }
    
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let type = info[.mediaType] as? String, type == "public.image" {
//            if let image = info[.editedImage] as? UIImage {
//                setImage(image)
//            }
//            if let image = info[.originalImage] as? UIImage {
//                setImage(image)
//            }
//        } else {
//            if let videoURL = info[.mediaURL] as? URL {
////                let coverImage =
//            }
//        }
//
//        hidePicker(duration: 0.5)
////        fake?.view.isHidden = true
//
////        picker.dismiss(animated: true)
//    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTextPosition()
    }
    
    public func updateTextPosition() {
        let count = items.count
        // Work out the page
        let page = currentPage() + 1
        
        if count == 0 {
            pageIndicator.text = ""
        } else {
            pageIndicator.text = String(format: "%i/%i", page, count)
        }
        
    }
    
    public func currentPage() -> Int {
        return Int(round(scrollView.contentOffset.x / scrollView.frame.width))
    }

}
