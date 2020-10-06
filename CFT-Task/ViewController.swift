import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadDataFromFile()
  }

  @IBOutlet private var nameField: UITextField!
  @IBOutlet private var surnameField: UITextField!
  @IBOutlet private var dateOfBirthField: UITextField!
  @IBOutlet private var passwordField: UITextField!
  @IBOutlet private var passCheckField: UITextField!
  
  private var hasSavedData: Bool = false
  private var savedName: String = ""
  private var savedSurname: String = ""
  
  @IBAction func registerButton(_ sender: Any) {
    hasSavedData = false
    guard let name = nameField.text, let surname = surnameField.text, let date = dateOfBirthField.text, let password = passwordField.text, let passwordCheck = passCheckField.text else {
      return
    }
    
    if password != passwordCheck {
      showIncorrectPasswordError(errorMessage: "Passwords are different")
      return
    }
    if password.count < 5 {
      showIncorrectPasswordError(errorMessage: "Password must be longer than 4 characters")
      return
    }
    if checkDate(date: date) {
      showIncorrectPasswordError(errorMessage: "Date of birth is wrong")
    }
    if name.count == 0 || surname.count == 0 {
      showIncorrectPasswordError(errorMessage: "Name and surname are required fields")
      return
    }
    saveDataToFile()
    
    performSegue(withIdentifier: "showGreeting", sender: self)
  }
  
  private func loadDataFromFile() {
    if let dataDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
      let dataURL = dataDir.appendingPathComponent("data.txt")
      if let st = try? String(contentsOf: dataURL) {
        let dataArray = st.components(separatedBy: "\n")
        if(dataArray.count >= 2) {
          savedName = dataArray[0]
          savedSurname = dataArray[1]
          hasSavedData = true
          performSegue(withIdentifier: "showGreeting", sender: self)
        }
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let greetingVC = segue.destination as? GreetingViewController {
      if hasSavedData {
        greetingVC.name = savedName
        greetingVC.surname = savedSurname
      }
      else {
        greetingVC.name = nameField.text ?? ""
        greetingVC.surname = surnameField.text ?? ""
      }
    }
    
  }
  
  private func showIncorrectPasswordError(errorMessage: String) {
    let alertController = UIAlertController(
      title: "Error",
      message: errorMessage,
      preferredStyle: .alert)
    
    alertController.addAction(UIAlertAction(
      title: "Close",
      style: .default,
      handler: {_ in alertController.dismiss(animated: true, completion: nil)}))
    
    present(alertController, animated: true, completion: nil)
  }
  
  private func saveDataToFile() {
    if let dataDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
      let dataURL = dataDir.appendingPathComponent("data.txt")
      let nameToSave = nameField.text ?? ""
      let surnameToSave = surnameField.text ?? ""
      let dataToSave = nameToSave + "\n" + surnameToSave
      try? dataToSave.write(to: dataURL, atomically: false, encoding: .utf8)
    }
  }
  private func checkDate(date: String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    if dateFormatter.date(from: date) == nil {
      return true
    }
    return false
  }
}

