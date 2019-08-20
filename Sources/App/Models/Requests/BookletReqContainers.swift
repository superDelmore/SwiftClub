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

struct CatalogReqContainer: Content {
    var id: Int?
    var pid: Catalog.ID  // 一级菜单，默认为0；如果是二级菜单，则为一级菜单id
    var title: String
    var path: String? // 表示父级id列表
    var level: Int // 层级, 辅助字段，记录该菜单是第几级
    var order: Int // 权重，用于同一等级的菜单之间的排序, 数字越大，越靠前
    var topicId: Topic.ID? // 文章 id
}
