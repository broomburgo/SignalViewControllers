import UIKit

class NavigationHandler {
  let pageFactory: PageFactory
  let navigationController: UINavigationController
  init(pageFactory: PageFactory, navigationController: UINavigationController) {
    self.pageFactory = pageFactory
    self.navigationController = navigationController

    pageFactory.signalMakeMainPage
      .flatMap { $0.signalLeaveFeedback }
      .onReception § always § inAnyCase § presentSelectionPage

    pageFactory.signalMakeSelectionPage
      .flatMap { $0.signalSelection }
      .onReception § always § inAnyCase § popTopPage
  }

  private let transitionEndEmitter = Emitter<()>()
  private var currentTransitionEndSignal: Signal<()>?

  func startAppWithWindow(window: UIWindow) {
    navigationController.viewControllers = [pageFactory.makeMainPage()]
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }

  func presentAlertController(alertController: UIAlertController, completionSignal: Signal<()>) {
    wrapInTransition(completionSignal: completionSignal) { [weak self] in
      guard let this = self else { return }
      this.navigationController.presentViewController(alertController, animated: true, completion: nil)
    }
  }

  private func presentSelectionPage() {
    let completionEmitter = Emitter<()>()
    wrapInTransition(completionSignal: completionEmitter.signal) { [weak self] in
      guard let this = self else { return }
      this.navigationController.pushViewController(this.pageFactory.makeSelectionPage(), animated: true)
      this.navigationController.transitionCoordinator()?.animateAlongsideTransition(nil) { _ in
        completionEmitter.emit()
      }
    }
  }

  private func popTopPage() {
    let completionEmitter = Emitter<()>()
    wrapInTransition(completionSignal: completionEmitter.signal) { [weak self] in
      guard let this = self else { return }
      this.navigationController.popViewControllerAnimated(true)
      this.navigationController.transitionCoordinator()?.animateAlongsideTransition(nil) { _ in
        completionEmitter.emit()
      }
    }
  }

  private func wrapInTransition(completionSignal completionSignal: Signal<()>, action: () -> ()) {
    if let currentTransitionEndSignal = currentTransitionEndSignal {
      currentTransitionEndSignal.onReception § once § { [weak self] in
        guard let this = self else { return }
        this.wrapInTransition(completionSignal: completionSignal, action: action)
      }
      return
    }

    currentTransitionEndSignal = transitionEndEmitter.signal
    action()

    completionSignal.onReception § once § { [weak self] in
      self?.currentTransitionEndSignal = nil
      self?.transitionEndEmitter.emit()
    }
  }
}
