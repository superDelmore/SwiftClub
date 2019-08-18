//
//  BookletReqContainers.swift
//  App
//
//  Created by laijihua on 2019/8/14.
//

import Vapor

struct BookletReqContainer: Content {
    var name: String
    var desc: String?
    var userId: User.ID
}
