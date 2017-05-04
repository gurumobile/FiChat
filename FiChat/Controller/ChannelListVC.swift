//
//  ChannelListVC.swift
//  FiChat
//
//  Created by sambo on 5/3/17.
//  Copyright © 2017 sambo. All rights reserved.
//

import UIKit
import Firebase

enum Section: Int {
    case CreateNewChannelSection = 0
    case currentChannelSection
}

class ChannelListVC: UITableViewController {
    
    var senderDisplayName: String?
    var newChannelTextField: UITextField?
    private var channels: [Channel] = []
    
    private lazy var channelRef : FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    private var channelRefHandle : FIRDatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "FiChat"
        
        observeChannels()
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Firebase related methods
    
    private func observeChannels() {
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            
            if let name = channelData["name"] as! String!, name.characters.count > 0 {
                self.channels.append(Channel(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .CreateNewChannelSection:
                return 1
            case .currentChannelSection:
                return channels.count
            }
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.CreateNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        if (indexPath as NSIndexPath).section == Section.CreateNewChannelSection.rawValue {
            if let createNewChannelCell = cell as? CreateChannelCell {
                newChannelTextField = createNewChannelCell.newChannelNameField
            }
        } else if (indexPath as NSIndexPath).section == Section.currentChannelSection.rawValue {
            cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.currentChannelSection.rawValue {
            let channel = channels[(indexPath as NSIndexPath).row]
            
            senderDisplayName = channels[(indexPath as NSIndexPath).row].name
            
            self.performSegue(withIdentifier: "ShowChannel", sender: channel)
        }
    }
    
    @IBAction func createChannel(_ sender: Any) {
        if let name = newChannelTextField?.text {
            let newChannelRef = channelRef.childByAutoId()
            let channelItem = ["name": name]
            
            newChannelRef.setValue(channelItem)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            let chatVC = segue.destination as! ChatVC
            
            chatVC.senderDisplayName = senderDisplayName
            chatVC.channel = channel
            chatVC.channelRef = channelRef.child(channel.id)
        }
    }
}
