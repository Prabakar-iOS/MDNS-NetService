//
//  ViewController.swift
//  NetService Task
//
//  Created by Guru on 11/04/20.
//  Copyright © 2020 Prabakar. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet var listTable: UITableView!
    @IBOutlet var publishBtn: UIButton!
    @IBOutlet var scanBtn: UIButton!
    
    lazy var netService = NetService()
    let netServiceBrowser = NetServiceBrowser()
    lazy var serviceList = [NetService]()
    lazy var dummyServiceList = [NetService]()
    var activityView: UIActivityIndicatorView?
    lazy var serviceType = "_http._tcp."
    lazy var domain = "local."
    lazy var port = "80"
    lazy var strTitle = "MDNS"
    lazy var diplayCellIdentifier = "DisplayTableCell"
    
    // MARK:- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strTitle
        /// Remove extra lines in UITableView
        listTable.tableFooterView = UIView()
    }
}
// MARK:- Functionality
extension ViewController{
    
    // MARK:- Resolve the services
    func update() {
        serviceList.removeAll()
        for service in dummyServiceList{
            service.delegate = self
            service.resolve(withTimeout: 1)
        }
    }
    
    // MARK:- Activity Indicator
    func showActivityIndicator() {
        
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        } else {
            // Fallback on earlier versions
            activityView = UIActivityIndicatorView(style: .whiteLarge)
        }
        if #available(iOS 13.0, *) {
            activityView?.color = .link
        } else {
            // Fallback on earlier versions
            activityView?.color = .blue
        }
        activityView?.center = self.view.center
        
        if (activityView != nil){
            activityView?.stopAnimating()
            activityView?.removeFromSuperview()
        }
        self.view.addSubview(activityView!)
        self.view.isUserInteractionEnabled = false

        activityView?.startAnimating()
    }
    
    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
            activityView?.hidesWhenStopped = true
            self.view.isUserInteractionEnabled = true
            activityView?.removeFromSuperview()
        }
    }
}

// MARK:- Button Actions
extension ViewController {
    
    /// Publishand Scan Button Action
    @IBAction func buttonWasTapped(_ sender: UIButton) {
        showActivityIndicator()
        if sender.tag == 1 {
            // Do any additional setup after loading the view.
            netService = NetService(domain: domain,
                                    type: serviceType,
                                    name: "\(UIDevice.current.name)",
                port: Int32(port) ?? 0)
            netService.delegate = self
            netService.publish()
            
        } else {
            netServiceBrowser.stop()
            dummyServiceList.removeAll()
            serviceList.removeAll()
            netServiceBrowser.delegate = self
            netServiceBrowser.searchForServices(ofType: serviceType, inDomain: domain)
        }
    }
    
}



// MARK:- Table View DataSource and Delegates
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: diplayCellIdentifier, for: indexPath) as! DisplayTableCell
        cell.setData(dictServiceList: serviceList[indexPath.row])
        return cell
    }
}


