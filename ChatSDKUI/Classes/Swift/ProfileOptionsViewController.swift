//
//  BProfileOptionsViewController.swift
//  AFNetworking
//
//  Created by ben3 on 13/07/2020.
//

import Foundation
import UIKit

@objc public class ProfileOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let identifier = "Cell"
    var user: PUser?
    
    @objc public init(user: PUser) {
        super.init(nibName: "ProfileOptionsViewController", bundle: Bundle.ui())
        self.user = user
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let version = ProcessInfo.processInfo.operatingSystemVersion;
        if (version.majorVersion < 13) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Bundle.t(bBack), style: .plain, target: self, action: #selector(back))
        }
        
        

    }
    
    @objc public func back() {
        dismiss(animated: true, completion: nil)
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return ChatSDKUI.shared().getProfileSections(user: user).count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatSDKUI.shared().getProfileSections(user: user)[section].getItems(user: user).count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ChatSDKUI.shared().getProfileSections(user: user)[section].getName()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell()

        let item = ChatSDKUI.shared().getProfileSections(user: user)[indexPath.section].getItems(user: user)[indexPath.row]
        cell.textLabel?.text = item.getName()
        if let icon = item.getIcon() {
            cell.imageView?.image = Icons.get(name: icon)
        }

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = ChatSDKUI.shared().getProfileSections(user: user)[indexPath.section].getItems(user: user)[indexPath.row]
        item.execute(viewController: self, user: user ?? BChatSDK.currentUser())
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }

}
