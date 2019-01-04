import Foundation
import UIKit
import Bond
import DatePickerCell


class SettingsViewController: UITableViewController {
  
  fileprivate let rowHeight: CGFloat = 44
  
  @IBOutlet weak var maxPickerCell: DatePickerCell!
  @IBOutlet weak var minPickerCell: DatePickerCell!
  @IBOutlet weak var creativeCommonsSwitch: UISwitch!
  @IBOutlet weak var filterDatesSwitch: UISwitch!
  
  @IBAction func doneButtonClicked(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil);
  }
    
    var viewModel: PhotoSearchMetadataViewModel?
  
    fileprivate func bind(_ modelDate: Observable<Date>, picker: DatePickerCell) {
        _ = modelDate.observeNext {
            event in
            picker.date = event
        }
        
        _ = picker.datePicker.reactive.date.observeNext {
            event in
            modelDate.value = event
        }
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.creativeCommons.bidirectionalBind(to: creativeCommonsSwitch.reactive.isOn)
        viewModel.dateFilter.bidirectionalBind(to: filterDatesSwitch.reactive.isOn)
        
        let opacity = viewModel.dateFilter.map { $0 ? CGFloat(1.0) : CGFloat(0.5) }
        opacity.bind(to: minPickerCell.leftLabel.reactive.alpha)
        opacity.bind(to: maxPickerCell.leftLabel.reactive.alpha)
        opacity.bind(to: minPickerCell.rightLabel.reactive.alpha)
        opacity.bind(to: maxPickerCell.rightLabel.reactive.alpha)
        
        bind(viewModel.minUploadDate, picker: minPickerCell)
        bind(viewModel.maxUploadDate, picker: maxPickerCell)
    }
    
  override func viewDidLoad() {
    
    bindViewModel()
    
    tableView.estimatedRowHeight = rowHeight
    
    maxPickerCell.leftLabel.text = "Max Date"
    minPickerCell.leftLabel.text = "Min Date"
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    guard let datePickerCell = cell as? DatePickerCell else {
      return
    }
    datePickerCell.selectedInTableView(tableView)
    tableView.deselectRow(at: indexPath, animated: false)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let cell = tableView.cellForRow(at: indexPath)
    guard let datePickerCell = cell as? DatePickerCell else {
      return rowHeight
    }
    return datePickerCell.datePickerHeight()
  }
}

extension UITextField {
    
}
