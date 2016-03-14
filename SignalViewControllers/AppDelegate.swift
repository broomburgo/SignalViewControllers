import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)
  let feedbackModelController = ModelController(model: FeedbackModel(feedback: .None, polarized: false))
  var pageFactory: PageFactory!
  var navigationHandler: NavigationHandler!
  var feedbackCollector: FeedbackCollector!

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    initialize()
    handleGoodFeedbacksWithAlert()
    navigationHandler.startAppWithWindow(window!)
    return true
  }

  private func initialize() {
    pageFactory = PageFactory(
      mainPageTitle: "Leave a feedback for the movie",
      selectionPageTitle: "The movie was...",
      feedbackModelController: feedbackModelController)

    feedbackCollector = FeedbackCollector(pageFactory: pageFactory)
    feedbackCollector.collectFeedbackModelChange().onReception § eachTime § feedbackModelController.transform

    let navController = UINavigationController()
    navController.navigationBar.translucent = false
    navigationHandler = NavigationHandler(
      pageFactory: pageFactory,
      navigationController: navController)
  }

  private func handleGoodFeedbacksWithAlert() {
    feedbackModelController.deltaSignal
      .filter { $0.feedback.rawValue < $1.feedback.rawValue}
      .filter { $1.feedback == .Good || $1.feedback == .ReallyGood }
      .onReception § eachTime § inAnyCase § showThankYouAlert
  }

  private func showThankYouAlert() {
    let thankYouAlertController = UIAlertController(title: "Thank You!", message: nil, preferredStyle: .Alert)
    let completionEmitter = Emitter<()>()
    thankYouAlertController.addAction § UIAlertAction(title: "OK", style: .Default) { _ in
      completionEmitter.emit()
    }
    navigationHandler.presentAlertController(thankYouAlertController, completionSignal: completionEmitter.signal)
  }
}

