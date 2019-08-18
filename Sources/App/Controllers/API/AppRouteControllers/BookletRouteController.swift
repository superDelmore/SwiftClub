//
//  BookletRouteController.swift
//  App
//
//  Created by laijihua on 2019/8/14.
//

import Vapor

final class BookletRouteController: RouteCollection {
    func boot(router: Router) throws {
        let group = router.grouped("booklet")

        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let tokenAuthGroup = group.grouped([tokenAuthMiddleware, guardAuthMiddleware])
        // 小册列表
        group.get("list", use: bookletList)
        // 添加
        tokenAuthGroup.post(BookletReqContainer.self, at:"add", use: bookletAdd)

        /// 目录
        group.get("catalog", use: catalogDetail)

    }
}

extension BookletRouteController {

    func catalogDetail(request: Request) throws -> Future<Response> {
        

        return try request.makeJson()
    }

    /// 获取小册列表
    func bookletList(request: Request) throws -> Future<Response>  {
        return try Booklet.query(on: request).all().makeJson(on: request)
    }

    func bookletAdd(request: Request, container: BookletReqContainer) throws -> Future<Response> {
        /// 生成小册，首先会判断用户是否登录,然后权限是否足够,
        let _ = try request.requireAuthenticated(User.self) // 获取到当前用户
        let catalog = Catalog(title: container.name)
        return catalog
            .create(on: request)
            .flatMap { catelog  in

            let catelogId = catelog.id!
            let booklet = Booklet(name: container.name,
                                  desc: container.desc,
                                  catalogId: catelogId,
                                  userId: container.userId)
            return try booklet.create(on:request).makeJson(on: request)
        }
    }

}
