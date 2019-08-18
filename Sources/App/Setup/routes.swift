import Vapor
import Leaf
//import Jobs

public func routes(_ router:Router, _ container:Container) throws {

    // / 用于静态文件
    router.get("welcome") { req in
        return "welcome"
    }

    router.get("/") { req in
        return try req.view().render("index", ["hello": "world"])
    }

    /// 转接第三方接口
    router.get("japi", "toh") { req in
        return try req.client().get("http://api.juheapi.com" + req.http.urlString).map(to: Response.self, { res in
            let response = req.response()
            response.http.status = res.http.status
            response.http.body = res.http.body
            return response
        })
    }

    let group = router.grouped("api")
    
    let authRouteController = AuthenticationRouteController()
    try group.register(collection: authRouteController)
    
    let userRouteController = UserRouteController()
    try group.register(collection: userRouteController)

    let protectedRouteController = ProtectedRoutesController()
    try group.register(collection: protectedRouteController)

    let accountRouteController = AccountRouteController()
    try group.register(collection: accountRouteController)

    let topicRouteController = TopicRouteController()
    try group.register(collection: topicRouteController)

    let bookletRouteController = BookletRouteController()
    try group.register(collection: bookletRouteController)

}

