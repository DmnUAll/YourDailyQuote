import Foundation

// MARK: - QuoteModel
struct QuoteModelElement: Decodable {

// swiftlint:disable identifier_name
    let q, a: String
// swiftlint:enable identifier_name
}

typealias QuoteModel = [QuoteModelElement]
