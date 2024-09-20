import Foundation

struct CurrentDateModel: Decodable, Identifiable {

    let id = UUID()
    let date: String

    private enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}
