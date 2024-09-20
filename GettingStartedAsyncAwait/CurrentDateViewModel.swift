import Foundation

@MainActor
class CurrentDateViewModel: ObservableObject {

    @Published var currentDates: [CurrentDateModel] = []

    func populateDates() async {
        do {
            guard let date = try await Webservice().getDate() else { return }
            currentDates.append(date)
        } catch {
            print(error)
        }
    }
}
