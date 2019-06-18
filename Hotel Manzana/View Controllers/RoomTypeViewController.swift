//
//  RoomTypeViewController.swift
//  Hotel Manzana
//
//  Created by Denis Bystruev on 18/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class RoomTypeViewController: UITableViewController {
    
    var selectedRoom: RoomType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = "Room Selection"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let roomType = RoomType.all[indexPath.row]
        cell.accessoryType = roomType == selectedRoom ? .checkmark : .none
        cell.textLabel?.text = roomType.name
        cell.detailTextLabel?.text = "$ \(roomType.price)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRoom = RoomType.all[indexPath.row]
        tableView.reloadData()
    }

    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
        guard let registrationViewController = navigationController.viewControllers.last as? RegistrationViewController else { return }
        registrationViewController.selectedRoom = selectedRoom
    }
}
