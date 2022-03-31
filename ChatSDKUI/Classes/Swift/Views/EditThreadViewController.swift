//
//  EditThreadViewController.swift
//  ChatSDK
//
//  Created by Ben on 24/03/2022.
//

import Foundation
import ZLImageEditor

@objc public class EditThreadViewController: UIViewController {
     
    open var thread: PThread
    open var tapRecognizer: UITapGestureRecognizer?
    open var imageTapRecognizer: UITapGestureRecognizer?
    open var action: BSelectMediaAction?
    open var image: UIImage?
    open var didSave: (() -> Void)?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @objc public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, thread: PThread) {
        let nib = nibNameOrNil ?? "EditThreadViewController"
        let bundle = nibBundleOrNil ?? Bundle.ui()
        self.thread = thread
        super.init(nibName: nib, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc open override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        title = Bundle.t(bEdit)
                
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapRecognizer!)

        imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateImage))
        avatarImageView.addGestureRecognizer(imageTapRecognizer!)
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 75
        
        let version = ProcessInfo.processInfo.operatingSystemVersion;
        if (version.majorVersion < 13 || BChatSDK.config().alwaysShowBackButtonOnModalViews) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: Bundle.t(bBack), style: .done, target: self, action: #selector(back));
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: Bundle.t(bSave), style: .done, target: self, action: #selector(save));
        
        action = BSelectMediaAction(type: bPictureTypeAlbumImage, viewController: self, squareCrop: true)

    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        image = nil
        avatarImageView.loadThreadImage(thread)
        textField.text = thread.name()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= 80
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += 80
    }
    
    @objc open func viewTapped() {
        textField.resignFirstResponder()
    }
    
    @objc open func save() {
        var updated = false
        if let name = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
            thread.setName(name)
            updated = true
        }
        if let image = image {
            updated = true
        }
        if updated {
            
            var promise: RXPromise?
            
            showProgressView()
            if let image = image {
                promise = BChatSDK.upload()?.uploadImage(image).thenOnMain({ [weak self] success in
                    if let dict = success as? [String: String], let url = dict[bImagePath] {
                        self?.thread.setMetaValue(url, forKey: bImageURL)
                    }
                    return self?.pushThread() ?? success
                }, nil)
            } else {
                promise = pushThread()
            }
                        
            promise?.thenOnMain({ [weak self] success in
                self?.hideProgressView()
                self?.threadDidSave()
                return success
            }, { [weak self] error in
                self?.hideProgressView()
                return error
            })
        }
        
    }
    
    open func threadDidSave() {
        didSave?()
        BHookNotification.notificationThreadUpdated(thread)
        back()
    }
    
    open func showProgressView() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    open func hideProgressView() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    open func pushThread() -> RXPromise? {
        return BChatSDK.thread().pushThreadMeta(thread.entityID()).thenOnMain({ [weak self] success in
            self?.hideProgressView()
            return success
        }, nil)
    }
    
    @objc open func updateImage() {
        _ = action?.execute()?.thenOnMain({ [weak self] success in
            if let photo = self?.action?.photo, let vc = self {
                
                
                self?.image = photo
                self?.avatarImageView.image = photo
                
//                ZLEditImageViewController.showEditImageVC(parentVC: vc, animate: false, image: photo, editModel: nil) { (resImage, editModel) in
//                    self?.image = resImage
//                    self?.avatarImageView.image = resImage
//                }
            }
            return success
        }, nil)
    }
    
    @objc open func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc open func setDidSaveCallback(callback: @escaping (() -> Void)) {
        didSave = callback
    }
    
}
