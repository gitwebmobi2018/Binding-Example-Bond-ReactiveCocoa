import UIKit
import DatePickerCell
import Bond
import MarqueeLabel
import LTMorphingLabel

class PhotoSearchViewController: UIViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var changeStatusBtn: UIBarButtonItem!
    
    private var viewModel = PhotoSearchViewModel()
    
    var statusLbl = LTMorphingLabel()
    
    func bindViewModel() {
        viewModel.searchString.bidirectionalBind(to: searchTextField.reactive.text)
        
        viewModel.validSearchText.map {
            $0 ? UIColor.black : UIColor.red
        }.bind(to: searchTextField.reactive.textColor)
        
//        viewModel.validSearchText.bind(to: activityIndicator.reactive.isAnimating )
        viewModel.searchInProgress.map { $0 }.bind(to: activityIndicator.reactive.isHidden)
        viewModel.searchInProgress.map {
            $0 ? CGFloat(0.5) : CGFloat(1)
        }.bind(to: resultsTable.reactive.alpha)
        
        viewModel.searchResults.bind(to: resultsTable) { dataSource, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! PhotoTableViewCell
            let photo = dataSource[indexPath.row]
            cell.title.text = photo.title
            
            let backgroundQueue = DispatchQueue(label: "backgroundQueue",
                                                qos: .background,
                                                attributes: .concurrent,
                                                autoreleaseFrequency: .inherit,
                                                target: nil)
            cell.photo.image = nil
            backgroundQueue.async {
                if let imageData = try? Data(contentsOf: photo.url) {
                    DispatchQueue.main.async() {
                        cell.photo.image = UIImage(data: imageData)
                    }
                }
            }
            
            return cell
        }
        
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()

    bindViewModel()
    
    statusLbl = LTMorphingLabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 30))
    statusLbl.text = "status content"
    view.addSubview(statusLbl)
    
    viewModel.statusString.bind(to: statusLbl.reactive.text)
    
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSettings" {
            let navVC = segue.destination as! UINavigationController
            let settingsVC = navVC.topViewController as! SettingsViewController
            settingsVC.viewModel = viewModel.searchMetadataViewModel
        }
    }

    @IBAction func onChangeStatusBtn(_ sender: Any) {
        if let effet = LTMorphingEffect(rawValue: 5) {
            statusLbl.morphingEffect = effet
            statusLbl.text = "changed"
        }
    }
}

extension PhotoSearchViewController: LTMorphingLabelDelegate {
    
    
    
}
