import UIKit

protocol SelectionController {
  var signalSelection: Signal<Classification> { get }
  var page: UIViewController { get }
}
