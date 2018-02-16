//
//  member.swift
//  SmartElectricSavingHome
//
//  Created by Kolak Keeratipattarakul on 1/11/18.
//  Copyright © 2018 SESH. All rights reserved.
//

import Foundation
import Firebase

class member{
    let key: String!
    var UserName: String!
    var pass: String!
    var completed: Bool!
    let ref: DatabaseReference!
    
    
    
    init(UserName: String, key: String = ""){
        self.key = key
        self.UserName = UserName
        self.ref = nil
    }
    init(snapshot: DataSnapshot){
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        UserName = snapshotValue["UserName"] as! String
        ref = snapshot.ref
    }
    func toAnyObject()-> Any{
        return[
            "UserName" : UserName
        ]
    }
}
