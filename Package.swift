import PackageDescription

let package = Package(
    name: "StartAppsKitAlerts",
    dependencies: [
        .Package(url: "https://github.com/StartAppsPe/StartAppsKitExtensions.git", versions: Version(0,1,0)..<Version(1, .max, .max))
    ]
)
