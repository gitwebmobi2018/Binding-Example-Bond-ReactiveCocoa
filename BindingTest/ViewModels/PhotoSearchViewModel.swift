import Foundation
import Bond
import ReactiveKit

class PhotoSearchViewModel {
    
    private let searchService : PhotoSearch = {
//        let apiKey = Bundle.main.object(forInfoDictionaryKey: "apiKey") as! String
        return PhotoSearch(key: "apiKey")
    }()
    
    let searchMetadataViewModel = PhotoSearchMetadataViewModel()
    
    let searchResults = MutableObservableArray<Photo>([])
    
    let statusString = Observable<String>("")
    let searchString = Observable<String?>("")
    let validSearchText = Observable<Bool>(false)
    let searchInProgress = Observable<Bool>(false)
    
//    let error = DynamicSubject<String, NoError>()
    
    init() {
        _ = searchString.observeNext { text in
            if let txt = text {
                print(txt)
            }
        }
        
        searchString.map {
            $0?.count ?? 0 > 3
        }.bind(to: validSearchText)
        
        searchString.map{ $0?.count ?? 0 > 3 ? "searching" : "search text should be more than 3 charactors." }.bind(to: statusString)
        
        _ = searchString.filter {
            $0?.count ?? 0 > 3
        }.throttle(seconds: 0.5)
            .observeNext { text in
                if let txt = text {
                    self.executeSearch(txt)
                }
        }
        
        _ = combineLatest(searchMetadataViewModel.dateFilter, searchMetadataViewModel.maxUploadDate,
                          searchMetadataViewModel.minUploadDate, searchMetadataViewModel.creativeCommons)
            .throttle(seconds: 0.5)
            .observeNext {
                [unowned self] _ in
                self.executeSearch(self.searchString.value!)
        }
        
    }
    
    func executeSearch(_ text: String) {
        var query = PhotoQuery()
        query.creativeCommonsLicence = searchMetadataViewModel.creativeCommons.value
        query.dateFilter = searchMetadataViewModel.dateFilter.value
        query.minDate = searchMetadataViewModel.minUploadDate.value
        query.maxDate = searchMetadataViewModel.maxUploadDate.value
        
        query.text = searchString.value ?? ""
        searchInProgress.value = true
        searchService.findPhotos(query) { (result) in
            self.searchInProgress.value = false
            switch result {
            case .success(let photos):
                print("500px API returned \(photos.count) photos")
                self.searchResults.removeAll()
                self.searchResults.insert(contentsOf: photos, at: 0)
            case .error(let err):
                print("Sad face :-( - \(err.localizedDescription)")
            }
        }
    }
    
}
