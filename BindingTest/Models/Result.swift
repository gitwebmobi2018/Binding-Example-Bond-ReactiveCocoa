import Foundation

// Describes the result of an asynchronous query
enum Result<T> {
  case success(T)
  case error(Error)
}
