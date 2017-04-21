// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "webParse",
    
    dependencies: [
        .Package(url: "https://github.com/tid-kijyun/Kanna.git", majorVersion: 2),
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4)
    ]
)
