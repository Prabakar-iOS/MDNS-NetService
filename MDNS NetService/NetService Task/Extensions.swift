//
//  Extensions.swift
//  MDNS
//
//  Created by Prabakar on 10/10/20.
//  Copyright © 2020 Prabakar. All rights reserved.
//

import Foundation
import Network
import UIKit



extension ViewController: NetServiceDelegate, NetServiceBrowserDelegate{
    
    // MARK:- Net Service Publish Delegates
    func netServiceDidPublish(_ sender: NetService) {
        debugPrint("netServiceDidPublish: \(sender.name)")
        hideActivityIndicator()
    }
    
    func netServiceDidResolveAddress(_ sender: NetService) {
        debugPrint("netServiceDidResolveAddress: \(sender.name)")
        serviceList.append(sender)
        hideActivityIndicator()
        DispatchQueue.main.async {
            self.listTable.reloadData()
        }
        
    }
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        showAlert(message: "\(String(describing: errorDict))")
        hideActivityIndicator()
        
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        showAlert(message: "\(String(describing: errorDict))")
        hideActivityIndicator()
    }
    
    
    // MARK:- Net Service Search Delegates
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        debugPrint("netServiceBrowserWillSearch: \(browser)")
        hideActivityIndicator()
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        debugPrint("netServiceBrowserDidStopSearch")
//        hideActivityIndicator()
        debugPrint(browser)
    }
    
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        debugPrint("Search was not successful. Error code: \(errorDict)")
        showAlert(message: "\(String(describing: errorDict))")
        hideActivityIndicator()
        debugPrint(browser)
        debugPrint(errorDict)
        update()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        dummyServiceList.append(service)
        debugPrint("didFind MoreComing: \(moreComing)")
        if serviceList.isEmpty {
            service.delegate = self
            service.resolve(withTimeout: 1)
            return
        }
        if !moreComing {
            update()
        }
        hideActivityIndicator()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        guard let dupIndex = dummyServiceList.firstIndex(of: service) else { return }
        dummyServiceList.remove(at: dupIndex)
        guard let index = serviceList.firstIndex(of: service) else { return }
        serviceList.remove(at: index)
        showAlert(message: "\(service.name) has been removed.")
        DispatchQueue.main.async {
            self.listTable.reloadData()
            
        }
    }
    
    
    // MARK:- Common Alert
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message,preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


