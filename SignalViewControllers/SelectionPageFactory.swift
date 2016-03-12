import Foundation

class SelectionControllerFactory {
  private let makePageEmitter = Emitter<SelectionController>()

  var signalMakePage: Signal<SelectionController> {
    return makePageEmitter.signal
  }

  func makePage(title title: String, polarized: Bool) -> SelectionController {
    let xibName = polarized ? "PolarizedSelectionPage" : "AverageSelectionPage"
    let page = SelectionPage(nibName: xibName, bundle: nil)
    page.title = title
    makePageEmitter.emit(page)
    return page
  }
}
