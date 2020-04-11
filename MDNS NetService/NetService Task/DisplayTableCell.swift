//
//  DisplayTableCell.swift
//  MDNS
//
//  Created by Prabakar on 10/10/20.
//  Copyright © 2020 Prabakar. All rights reserved.
//

import UIKit
import Network

class DisplayTableCell: UITableViewCell {
    
    @IBOutlet var ipLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    lazy var localHost = "127.0.0.1"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(dictServiceList : NetService){
        nameLabel.text = dictServiceList.name
        ipLabel.text = getIpAddress(datas: (dictServiceList.addresses)!)
        typeLabel.text = dictServiceList.type
    }
    
    // MARK:- Fetch IP Address for the NetService Data
    func getIpAddress(datas:[Data]) -> String{
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        for data in datas{
            data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Void in
                let sockaddrPtr = pointer.bindMemory(to: sockaddr.self)
                guard let unsafePtr = sockaddrPtr.baseAddress else { return }
                guard getnameinfo(unsafePtr, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else {
                    return
                }
            }
            let ipAddress = String(cString:hostname)
            if let _ = IPv4Address(ipAddress) {
                debugPrint("\(ipAddress) is valid ipv4 address")
                if ipAddress != localHost{
                    return ipAddress
                }
            }
        }
        return ""
    }
    
}
