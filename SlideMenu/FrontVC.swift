//
//  FrontVC.swift
//  SlideMenu
//
//  Created by Prasad Pai on 05/06/16.
//  Copyright © 2016 Prasad Pai. All rights reserved.
//

import UIKit

protocol FrontVCProtocol: class {
    func frontVCMenuBtnTapped()
    
    func frontVCMenuBtnDraggedWithSender(sender: AnyObject, event: UIEvent)
    
    func frontVCOverlayBtnTapped()
}

class FrontVC: UIViewController {
    
    @IBOutlet weak var overlayBtn: UIButton!
    
    weak var frontVCDelegate: FrontVCProtocol?
    
    private let cellsList = ["autumn1", "autumn2", "autumn3", "autumn4", "autumn5", "autumn6", "autumn7", "autumn8"]
    
    // MARK: View Controller Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action and Selector methods
    @IBAction func menuBtnTapped(sender: AnyObject) {
        self.frontVCDelegate?.frontVCMenuBtnTapped()
    }
    
    @IBAction func overlayBtnTapped(sender: AnyObject) {
        self.frontVCDelegate?.frontVCOverlayBtnTapped()
    }
    
    @IBAction func menuBtnDragged(sender: AnyObject, event: UIEvent) {
        self.frontVCDelegate?.frontVCMenuBtnDraggedWithSender(sender, event: event)
    }
}

extension FrontVC: UITableViewDataSource {
    // MARK: TableView Data Source methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId") as! ImageCell
        cell.imgView.image = UIImage(named: self.cellsList[indexPath.row])
        cell.nameLabel.text = self.cellsList[indexPath.row]
        return cell
    }
}
