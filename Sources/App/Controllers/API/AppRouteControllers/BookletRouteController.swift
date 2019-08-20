//
//  BookletRouteController.swift
//  App
//
//  Created by laijihua on 2019/8/14.
//

import Vapor

final class BookletRouteController: RouteCollection {
    private let menuService = MenuService()

    func boot(router: Router) throws {
        let group = router.grouped("booklet")

        let guardAuthMiddleware = User.guardAuthMiddleware()
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let tokenAuthGroup = group.grouped([tokenAuthMiddleware, guardAuthMiddleware])

        // 小册列表
        group.get("list", use: bookletList)

        // 小册目录树
        group.get("catalog", use: catalogDetail)

        // 小册添加
        tokenAuthGroup.post(BookletReqContainer.self, at: "add",  use: bookletAdd)

        // 小册更新
        tokenAuthGroup.post(BookletReqContainer.self, at: "update", use: bookletUpdate)

        // 小册删除
        tokenAuthGroup.post("delete", use: bookletDelete)

        // 目录更新
        tokenAuthGroup.post(CatalogReqContainer.self, at:"catalog", "update", use: catalogUpdate)

        // 目录添加
        tokenAuthGroup.post(CatalogReqContainer.self, at: "catalog", "add", use: catalogAdd)

        // 目录删除
        tokenAuthGroup.post("catalog", "delete", use: catalogDelete)

    }
}

extension BookletRouteController {

    func catalogAdd(request: Request, container: CatalogReqContainer) throws -> Future<Response> {
        return try request.makeJson()
    }

    func catalogDelete(request: Request) throws -> Future<Response> {
        return try request.makeJson()
    }

    func catalogUpdate(request: Request, container: CatalogReqContainer) throws -> Future<Response> {
        return try request.makeJson()
    }

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

    func bookletUpdate(request: Request, container: BookletReqContainer) throws -> Future<Response> {
         return try request.makeJson()
    }

    func bookletDelete(request: Request) throws -> Future<Response> {
        return try request.makeJson()
    }



}
