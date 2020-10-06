import UIKit

class GreetingViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  var name: String = ""
  var surname: String = ""
  
  @IBAction func greeting(_ sender: Any) {
    let alertController = UIAlertController(
      title: "Hello",
      message: "Thank you, " + name + " " + surname + ", for testing this app",
      preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(
      title: "Close",
      style: .default,
      handler: {_ in alertController.dismiss(animated: true, completion: nil)}))
    
    present(alertController, animated: true, completion: nil)
  }
  
}

