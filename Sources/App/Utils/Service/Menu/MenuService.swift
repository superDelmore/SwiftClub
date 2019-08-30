//
//  MenuService.swift
//  App
//
//  Created by laijihua on 2019/8/19.
//
import Vapor
import Fluent
import FluentPostgreSQL

final class MenuService {

    // 根据菜单Pid获得菜单
    func findBy(menuPid: Catalog.ID, connection: Request) -> EventLoopFuture<[Catalog]> {
        return Catalog
            .query(on: connection)
            .filter(\.pid == menuPid)
            .sort(\.order, PostgreSQLDirection.descending)
            .all()
    }

    // 根据编号查询菜单
    func findBy(menuId: Catalog.ID, connection: Request) -> EventLoopFuture<Catalog?> {
        return Catalog.find(menuId, on: connection)
    }

    // 新增/修改菜单
    func saveBy(menu: Catalog, connection: Request) -> EventLoopFuture<Catalog> {
        var menu = menu
        if menu.pid == 0 {
            menu.level = 1
        } else {
            return Catalog
                .find(menu.pid, on: connection)
                .unwrap(or: ApiError(code: .modelNotExist))
                .flatMap(to: Catalog.self, { parentM in
                    menu.level = parentM.level + 1
                    /// 更新
                    if let _ = menu.id {
                        return menu.update(on: connection)
                    } else {
                        /// 添加
                        return menu.create(on: connection)
                    }
                })
        }
        return menu.save(on: connection)
    }

    // 删除菜单
    func removeBy(menu: Catalog, connection: Request) -> EventLoopFuture<Void> {
        return menu.delete(on: connection)
    }

    func findMenuTree(connection: Request) -> EventLoopFuture<[CatalogTree]> {
        return Catalog
            .query(on: connection)
            .all()
            .map { menus in
                let tree = menus.compactMap { return CatalogTree(catalog: $0)}
                return self.getMenuTree(menusRoot: tree)
            }
    }

    func findMenuTreeAt(catalogId: Catalog.ID, connect: Request) -> EventLoopFuture<[CatalogTree]> {
        return Catalog
            .query(on: connect)
            .all()
            .map { menus in
                let tree = menus.filter({ (catalog) -> Bool in
                    guard let ids = catalog.path?.split(separator: ",") else {
                        return false
                    }
                    return ids.compactMap{String($0)}.filter{$0 == "\(catalogId)"}.count > 0
                }).compactMap { return CatalogTree(catalog: $0)}
            return self.getMenuTree(menusRoot: tree)
        }
    }


    /// 获取组装好的菜单, 以树的形式显示
    func getMenuTree(menusRoot: [CatalogTree]) -> [CatalogTree] {
         return menusRoot
            .filter{$0.pid == 0}
            .compactMap { menu in
                var menu = menu
                menu.child = self.getChildTree(menuId: menu.id!, menusRoot: menusRoot)
                return menu
        }
    }

    // 获取菜单的子菜单
    func getChildTree(menuId: Catalog.ID, menusRoot: [CatalogTree]) ->  [CatalogTree] {
        return menusRoot
            .filter{$0.pid > 0 && $0.pid == menuId}
            .filter{ $0.id! > 0}
            .compactMap { menu in
                var menu = menu
                menu.child = self.getChildTree(menuId: menu.id!, menusRoot: menusRoot)
                return menu
        }

    }

}

struct CatalogTree: Content {
    var id: Int?
    var pid: Catalog.ID  // 一级菜单，默认为0；如果是二级菜单，则为一级菜单id
    var title: String
    var path: String? // 表示父级id列表
    var level: Int // 层级, 辅助字段，记录该菜单是第几级
    var order: Int // 权重，用于同一等级的菜单之间的排序, 数字越大，越靠前
    var topicId: Topic.ID? // 可能有文章, 如果存在，则打开，不存在则布局子项的 title
    var child: [CatalogTree]

    init(catalog: Catalog, child: [CatalogTree] = []) {
        self.id = catalog.id
        self.pid = catalog.pid
        self.title = catalog.title
        self.path = catalog.path
        self.level = catalog.level
        self.order = catalog.order
        self.topicId = catalog.topicId
        self.child = child
    }
}


