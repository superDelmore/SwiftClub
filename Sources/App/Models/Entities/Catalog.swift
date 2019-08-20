//
//  Catalog.swift
//  App
//
//  Created by laijihua on 2019/8/14.
//
import Vapor
import FluentPostgreSQL

//// 目录， 菜单设计
///
//id  title path level  更多
//1   衣服   0     0      ...
//2   上衣   0,1   1      ...
//3   裤子   0,1   1      ...
//4   西裤   0,1,3 2      ...
//


struct Catalog: Content {
    var id: Int?
    var pid: Catalog.ID  // 一级菜单，默认为0；如果是二级菜单，则为一级菜单id
    var title: String
    var path: String? // 表示父级id列表
    var level: Int // 层级, 辅助字段，记录该菜单是第几级
    var order: Int // 权重，用于同一等级的菜单之间的排序, 数字越大，越靠前

    var topicId: Topic.ID? // 可能有文章, 如果存在，则打开，不存在则布局子项的 title
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?

    static var createdAtKey: TimestampKey? { return \.createdAt }
    static var updatedAtKey: TimestampKey? { return \.updatedAt }
    static var deletedAtKey: TimestampKey? { return \.deletedAt }

    init(title: String,
         pid: Catalog.ID = 0,
         path: String? = nil,
         topicId: Topic.ID? = nil,
         level: Int = 0,
         order:Int = 0) {
        self.title = title
        self.path = path
        self.topicId = topicId
        self.level = level
        self.order = order
        self.pid = pid
    }
}

extension Catalog: Migration {}
extension Catalog: PostgreSQLModel {}
