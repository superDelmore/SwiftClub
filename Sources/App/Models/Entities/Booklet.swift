//
//  Booklet.swift
//  App
//
//  Created by laijihua on 2019/8/14.
//

import Vapor
import FluentPostgreSQL
import Pagination

/// 小册
struct Booklet: Content {
    var id: Int?
    var name: String // 小册名称
    var desc: String? // 简介
    var catalogId: Catalog.ID // 目录id
    var userId: User.ID

    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?

    static var createdAtKey: TimestampKey? { return \.createdAt }
    static var updatedAtKey: TimestampKey? { return \.updatedAt }
    static var deletedAtKey: TimestampKey? { return \.deletedAt }

    init(name: String, desc: String?, catalogId: Catalog.ID, userId: User.ID) {
        self.name = name
        self.desc = desc
        self.catalogId = catalogId
        self.userId = userId
    }
}

extension Booklet: Parameter {}
extension Booklet: Paginatable {}
extension Booklet: Migration {}
extension Booklet: PostgreSQLModel {}
