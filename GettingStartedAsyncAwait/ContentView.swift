import SwiftUI

struct ContentView: View {
    
    /// O atributo ``@State`` é usado para gerenciar pequenos estados locais de uma view.
    /// Essas variáveis são mutáveis, e, quando alteradas, fazem com que a interface do
    /// usuário seja automaticamente atualizada para refletir essas mudanças.
    @State private var currentDates: [CurrentDateModel] = []
    @StateObject private var currentDatesViewModel = CurrentDateViewModel()

    var body: some View {
        NavigationView {
            List(currentDatesViewModel.currentDates) { currentDate in
                Text(currentDate.date)
            }.listStyle(.plain)
            .navigationTitle("Dates")
            .navigationBarItems(trailing: Button(action: {
                Task {
                    await currentDatesViewModel.populateDates()
                }
            }, label: {
                Image(systemName: "arrow.clockwise.circle")
            }))
            .task {
                await currentDatesViewModel.populateDates()
            }
        }
    }
}

struct ContentViewPreviews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
