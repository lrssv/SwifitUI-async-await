import Foundation

class Webservice {

    func getDate() async throws -> CurrentDateModel? {
        guard let url = URL(string: "https://ember-sparkly-rule.glitch.me/current-date") else {
            fatalError()
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try? JSONDecoder().decode(CurrentDateModel.self, from: data)
    }
}
