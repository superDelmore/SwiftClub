//
//  Information.swift
//  App
//
//  Created by laijihua on 2018/12/18.
//

import Vapor
import FluentPostgreSQL
/// 资讯表
struct Infomation: Content {
    var id: Int?
    var title: String
    var desc: String
    var content: String? //
    var url: String // 来源链接
    var creatorId: User.ID
    var createdAt: Date?
    var updatedAt: Date?
    var deletedAt: Date?
    static var createdAtKey: TimestampKey? { return \.createdAt }
    static var updatedAtKey: TimestampKey? { return \.updatedAt }
    static var deletedAtKey: TimestampKey? { return \.deletedAt }
}

extension Infomation {
    // 作者
    var creator: Parent<Infomation, User> {
        return parent(\.creatorId)
    }
}

extension Infomation: PostgreSQLModel {}
extension Infomation: Migration {}

extension Infomation: Parameter {}

