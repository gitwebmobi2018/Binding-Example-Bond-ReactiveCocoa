import Foundation
import Bond

class PhotoSearchMetadataViewModel {
    
    let creativeCommons = Observable<Bool>(false)
    let dateFilter = Observable<Bool>(false)
    let minUploadDate = Observable<Date>(Date())
    let maxUploadDate = Observable<Date>(Date())
    
    init() {
        _ = maxUploadDate.observeNext {
            [unowned self]
            maxDate in
            if maxDate.timeIntervalSince(self.minUploadDate.value) < 0 {
                self.minUploadDate.value = maxDate
            }
        }
        _ = minUploadDate.observeNext {
            [unowned self]
            minDate in
            if minDate.timeIntervalSince(self.maxUploadDate.value) > 0 {
                self.maxUploadDate.value = minDate
            }
        }
    }
    
}
