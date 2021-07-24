//
//  UsersListViewController.swift
//  ChatSDK
//
//  Created by ben3 on 24/07/2021.
//

import Foundation
import UIKit
import CollectionKit

public enum Tabs: Int {
    case contacts = 0
    case conversations = 1
}

@objc open class ForwardViewController: UIViewController {
    
    open var contactsCollectionView: CollectionView?
    open var conversationsCollectionView: CollectionView?

    open var segmentedControl: UISegmentedControl?
    
    open var contactsProvider: BasicProvider<PUser, BUserCell>?
    open var conversationsProvider: BasicProvider<PThread, BThreadCell>?
    
    open var message: PMessage?

    @objc open override func viewDidLoad() {
        super.viewDidLoad()
                
        title = Bundle.t(bForwardMessage)
        
        view.backgroundColor = Colors.get(name: Colors.background)

        segmentedControl = UISegmentedControl()
        view.addSubview(segmentedControl!)

        segmentedControl?.keepTopInset.equal = 5
        segmentedControl?.keepLeftInset.equal = 5
        segmentedControl?.keepRightInset.equal = 5

        contactsCollectionView = CollectionView()
        setup(collectionView: contactsCollectionView!)

        conversationsCollectionView = CollectionView()
        setup(collectionView: conversationsCollectionView!)

        if #available(iOS 13.0, *) {
//            contactsCollectionView?.automaticallyAdjustsScrollIndicatorInsets = true
//            conversationsCollectionView?.automaticallyAdjustsScrollIndicatorInsets = true
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Bundle.t(bBack), style: .plain, target: self, action: #selector(back))
//            automaticallyAdjustsScrollViewInsets = true
        }
        
        edgesForExtendedLayout = []
        
        segmentedControl?.addTarget(self, action: #selector(segmentControlValueChanged(sender:)), for: .valueChanged)
        segmentedControl?.insertSegment(withTitle: Bundle.t(bContacts), at: Tabs.contacts.rawValue, animated: false)
        segmentedControl?.insertSegment(withTitle: Bundle.t(bConversations), at: Tabs.conversations.rawValue, animated: false)

        setupContactsProvider()
        setupConversationsProvider()
        
        segmentedControl?.selectedSegmentIndex = Tabs.contacts.rawValue

        contactsCollectionView?.provider = contactsProvider
        conversationsCollectionView?.provider = conversationsProvider
        
        conversationsCollectionView?.isHidden = true
    }
    
    open func setup(collectionView: CollectionView) {
        view.addSubview(collectionView)
        
        collectionView.keepTopOffsetTo(segmentedControl!)?.equal = 5
        collectionView.keepRightInset.equal = 0
        collectionView.keepLeftInset.equal = 0
        collectionView.keepBottomInset.equal = 0
        
//        collectionView.contentInsetAdjustmentBehavior = .always

    }
    
    @objc open func back() {
        dismiss(animated: true, completion: nil)
    }
    
    open func setupContactsProvider() {
        
        let ss = { (index: Int, data: PUser, collectionSize: CGSize) -> CGSize in
            return CGSize(width: self.view.frame.width, height: 60)
        }
        
        contactsProvider = BasicProvider(
            dataSource: ArrayDataSource(data: contacts()),
            viewSource: contactsViewSource(),
            sizeSource: ss,
            tapHandler: { [weak self] context in
                self?.forwardMessage(toUser: context.data)
            }
        )
        
    }
    
    open func forwardMessage(toUser: PUser) {
        BChatSDK.thread().createThread(withUsers: [toUser], threadCreated: { [weak self] error, thread in
            if let thread = thread, let message = self?.message {
                _ = BChatSDK.thread().forwardMessage(message, toThreadWithID: thread.entityID()).thenOnMain({ success in
                    self?.success()
                    return success
                }, { error in
                    self?.error(error: error)
                    return error
                })
            }
            self?.error(error: error)
        })
    }

    open func forwardMessage(toThread: PThread) {
        _ = BChatSDK.thread().forwardMessage(message, toThreadWithID: toThread.entityID()).thenOnMain({ [weak self] success in
            self?.success()
            return success
        }, { [weak self] error in
            self?.error(error: error)
            return error
        })
    }
    
    open func success() {
        view.makeToast(Bundle.t(bSuccess))
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] timer in
            timer.invalidate()
            self?.back()
        })
    }

    open func error(error: Error?) {
        if let error = error {
            view.makeToast(error.localizedDescription)
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] timer in
            timer.invalidate()
            self?.back()
        })
    }

    open func contactsViewSource() -> ViewSource<PUser, BUserCell> {
        return ClosureViewSource(viewGenerator: { data, index in
            let cell: BUserCell = .fromNib()
            return cell
        }, viewUpdater: { cell, user, index in
            cell.setUser(user)
            cell.statusImageView.isHidden = true
            cell.stateLabel.isHidden = true
        })
    }
    
    open func contacts() -> [PUser] {
        var contacts = [PUser]()
        if let connections = BChatSDK.contact().contacts() {
            for connection in connections {
                if let conn = connection as? PUserConnection {
                    contacts.append(conn.user())
                }
            }
        }
        return contacts
    }

    open func setupConversationsProvider() {

        let ss = { (index: Int, data: PThread, collectionSize: CGSize) -> CGSize in
            return CGSize(width: self.view.frame.width, height: 60)
        }

        conversationsProvider = BasicProvider(
            dataSource: ArrayDataSource(data: threads()),
            viewSource: conversationsViewSource(),
            sizeSource: ss,
            tapHandler: { [weak self] context in
                self?.forwardMessage(toThread: context.data)
            }
       )
    }

    open func conversationsViewSource() -> ViewSource<PThread, BThreadCell> {
        return ClosureViewSource(viewGenerator: { thread, index in
            let cell: BThreadCell = .fromNib()
            return cell
        }, viewUpdater: { cell, thread, index in
            cell.bind(thread)
            cell.unreadView.isHidden = true
//            cell.dateLabel.isHidden = true
            cell.unreadMessagesLabel.isHidden = true
        })
    }

    open func threads() -> [PThread] {
        return BChatSDK.thread().threads(with: bThreadFilterPrivate) as! [PThread]
    }

    @objc open func segmentControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == Tabs.contacts.rawValue {
            contactsCollectionView?.isHidden = false
            conversationsCollectionView?.isHidden = true
//            collectionView?.provider = contactsProvider
        }
        if sender.selectedSegmentIndex == Tabs.conversations.rawValue {
            contactsCollectionView?.isHidden = true
            conversationsCollectionView?.isHidden = false
//            collectionView?.provider = conversationsProvider
        }
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.ui().loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
}
