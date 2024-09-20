import SwiftUI

struct CurrentDate: Decodable, Identifiable {

    let id = UUID()
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}

struct ContentView: View {

    @State private var currentDates: [CurrentDate] = []

    private func getDate() async throws -> CurrentDate? {
        guard let url = URL(string: "https://ember-sparkly-rule.glitch.me/current-date") else {
            fatalError()
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try? JSONDecoder().decode(CurrentDate.self, from: data)
    }

    private func populateDates() async {
        do {
            guard let date = try await getDate() else { return }
            currentDates.append(date)
        } catch {
            print(error)
        }
    }

    var body: some View {
        NavigationView {
            List(currentDates) { currentDate in
                Text(currentDate.date)
            }.listStyle(.plain)
            .navigationTitle("Dates")
            .navigationBarItems(trailing: Button(action: {
                Task {
                    await populateDates()
                }
            }, label: {
                Image(systemName: "arrow.clockwise.circle")
            }))
            .task {
                await populateDates()
            }
        }
    }
}

struct ContentViewPreviews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
