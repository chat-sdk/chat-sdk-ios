//
//  ModerationViewController2.swift
//  ChatSDK
//
//  Created by ben3 on 09/01/2021.
//

import Foundation
import UIKit

@objc public class ModerationViewController: DynamicTableViewController, PModerationViewController {
    
    let thread: PThread
    let user: PUser
    var currentRole: String?
    var progressView = UIProgressView()
    
    public weak var delegate: ModerationViewControllerDelegate?

    @objc public init(thread: PThread, user: PUser, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.thread = thread
        self.user = user
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Bundle.t(bSettings)
        
        if #available(iOS 13.0, *) {} else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Bundle.t(bBack), style: .plain, target: self, action: #selector(backPressed))
        }

        currentRole = BChatSDK.thread().role(thread.entityID(), forUser: user.entityID())
        
        BChatSDK.hook().add(BHook(onMain: { [weak self] dict in
            if let user = dict?[bHook_PUser] as? PUser, let thread = dict?[bHook_PThread] as? PThread, let currentThread = self?.thread, let currentUser = self?.user {
                if thread.isEqual(to: currentThread) && (user.isEqual(to: currentUser) || user.isMe()) {
                    // Reload this view
                    self?.refresh()
                }
            }
        }), withName: bHookThreadUserRoleUpdated)
        
        syncAndUpdate()
    }
    
    public func syncAndUpdate(showHUD: Bool = true) {
        if showHUD {
            showProgressHUD()
        }
        BChatSDK.thread().refreshRoles?(thread.entityID()).thenOnMain({ [weak self] success in
            self?.hideProgressHUD()
            self?.refresh()
            return success
        }, { [weak self] error in
            self?.hideProgressHUD()
            self?.dismiss(animated: true, completion: nil)
            return error
        })
    }
    
    @objc public func backPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    public func refresh() {
        
        var contents = [DSection]()

        contents.append(DSection(title: Bundle.t(bProfile), rows: [
            DNavigationRow(title: Bundle.t(bViewProfile), onClick: { [weak self] in
                    if let user = self?.user, let vc = BChatSDK.ui().profileViewController(with: user) {
                        self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
                    }
                })
        ]))

        let th = BChatSDK.thread()

        if th.canChangeRole(thread.entityID(), forUser: user.entityID()) {

            var roleRows = [DRow]()

            let roles = th.availableRoles(thread.entityID(), forUser: user.entityID())

            for role in roles {
                roleRows.append(DRadioRow(title: Bundle.t(role), selected: currentRole == role, onClick: { [weak self] in
                    if let thread = self?.thread, let user = self?.user {
                        self?.showProgressHUD()
                        BChatSDK.thread().setRole(role, forThread: thread.entityID(), forUser: user.entityID()).thenOnMain({ [weak self] success in
//                            self?.hideProgress()
                            self?.currentRole = role
                            self?.syncAndUpdate(showHUD: false)
                            return success
                        }, { [weak self] error in
                            self?.hideProgressHUD()
                            self?.view.makeToast(error?.localizedDescription)
                            return error
                        })
                    }
                }))
            }

            if !roleRows.isEmpty {
                contents.append(DRadioSection(title: Bundle.t(bRole), rows: roleRows))
            }
        }

        var moderation = [DRow]()

        if th.canChangeModerator(thread.entityID(), forUser: user.entityID()) {
            let isModerator = th.isModerator(thread.entityID(), forUser: user.entityID())
            moderation.append(DSwitchRow(title: Bundle.t(bModerator), selected: isModerator, onChange: { [weak self] value in
                if let thread = self?.thread, let user = self?.user {
                    if value == true {
                        BChatSDK.thread().grantModerator(thread.entityID(), forUser: user.entityID()).thenOnMain(nil, { [weak self] error in
                            self?.view.makeToast(error?.localizedDescription)
                            return error
                        })
                    } else {
                        BChatSDK.thread().revokeModerator(thread.entityID(), forUser: user.entityID()).thenOnMain(nil, { [weak self] error in
                            self?.view.makeToast(error?.localizedDescription)
                            return error
                        })
                    }
                }
            }))
        }

        if th.canChangeVoice(thread.entityID(), forUser: user.entityID()) {
            let hasVoice = th.hasVoice(thread.entityID(), forUser: user.entityID())
            moderation.append(DSwitchRow(title: Bundle.t(bSilence), selected: !hasVoice, onChange: { [weak self] value in
                if let thread = self?.thread, let user = self?.user {
                    if value == true {
                        BChatSDK.thread().revokeVoice(thread.entityID(), forUser: user.entityID()).thenOnMain(nil, { [weak self] error in
                            self?.view.makeToast(error?.localizedDescription)
                            return error
                        })
                    } else {
                        BChatSDK.thread().grantVoice(thread.entityID(), forUser: user.entityID()).thenOnMain(nil, { [weak self] error in
                            self?.view.makeToast(error?.localizedDescription)
                            return error
                        })
                    }
                }
            }))
        }

        if !moderation.isEmpty {
            contents.append(DSection(title: Bundle.t(bModeration), rows: moderation))
        }

        if th.canRemoveUser(user.entityID(), fromThread: thread.entityID()) {

            var color = UIColor.red
            if #available(iOS 13.0, *) {
                color = UIColor.systemRed
            }
            
            contents.append(DSection(rows: [
                DButtonRow(title: Bundle.t(bRemoveFromGroup), color: color, onClick: { [weak self] in
                    if let thread = self?.thread, let user = self?.user {
                        self?.showProgressHUD()
                        BChatSDK.thread().removeUsers([user.entityID()], fromThread: thread.entityID())?.thenOnMain({ [weak self] success in
                            self?.hideProgressHUD()
                            self?.dismiss(animated: true, completion: nil)
                            return success
                        }, { [weak self] error in
                            self?.hideProgressHUD()
                            self?.view.makeToast(error?.localizedDescription)
                            return error
                        })
                    }
                })
            ]))
        }

//        tableContents = contents
        
//        sections = [
//            DSection(title: "Test", rows: [
//                DNavigationRow(title: "Test1", onClick: {
//
//                }),
//                DButtonRow(title: "Test", color: .red, onClick: {
//
//                }),
//                DSwitchRow(title: "Ok", selected: true, onChange: { value in
//
//                })
//            ]),
//            DRadioSection(title: "Radio", rows: [
//                DRadioRow(title: "1", onClick: {
//
//                }),
//                DRadioRow(title: "2", onClick: {
//
//                })
//            ])
//
//        ]
        
        setSections(sections: contents)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.moderationViewWillDisappear()
    }
    
    public func showProgressHUD() {
        MBProgressHUD.showAdded(to: view, animated: true)
    }

    public func hideProgressHUD() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    public func showProgress() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressView)
    }
    
    public func hideProgress() {
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc public func setDelegate(_ delegate: ModerationViewControllerDelegate) {
        self.delegate = delegate
    }

}
