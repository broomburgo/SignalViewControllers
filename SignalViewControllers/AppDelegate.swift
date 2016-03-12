import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    let page = ViewController()
    page.selectionControllerFactory = SelectionControllerFactory()
    page.title = "Leave a feedback for the movie"
    let navController = UINavigationController(rootViewController: page)
    navController.navigationBar.translucent = false
    window?.rootViewController = navController
    window?.makeKeyAndVisible()
    return true
  }
}

