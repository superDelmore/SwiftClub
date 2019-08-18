//
//  Catalog.swift
//  App
//
//  Created by laijihua on 2019/8/14.
//
import Vapor
import FluentPostgreSQL

//// 目录
struct Catalog: Content {
    var id: Int?

    var title: String
    var children: [Catalog.ID]
    var path: String? // parent-path
    var topicId: Topic.ID? // 可能有文章

    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?

    static var createdAtKey: TimestampKey? { return \.createdAt }
    static var updatedAtKey: TimestampKey? { return \.updatedAt }
    static var deletedAtKey: TimestampKey? { return \.deletedAt }

    init(title: String, children: [Catalog.ID] = [], path: String? = nil, topicId: Topic.ID? = nil) {
        self.title = title
        self.children = children
        self.path = path
        self.topicId = topicId
    }
}

extension Catalog: Migration {}
extension Catalog: PostgreSQLModel {}
