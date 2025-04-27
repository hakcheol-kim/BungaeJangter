//
//  RequestModels.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import Foundation
extension Encodable {
    var dictionary: [String:Any] {
        return ((try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: .mutableContainers)) as?  [String : Any]) ?? [:]
    }
}
struct RequestModel {
    struct UserList: Encodable {
        var skip: Int
        var gender: String
    }
}
