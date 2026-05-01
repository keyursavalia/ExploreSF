import SwiftUI

struct FilterPickerSheetView: View {
    let title:    String
    let options:  [String]
    @Binding var selected: String?

    @State   private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    private var filtered: [String] {
        guard !searchText.isEmpty else { return options }
        return options.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                if selected != nil {
                    Button("Clear Filter", role: .destructive) {
                        selected = nil
                        dismiss()
                    }
                }
                ForEach(filtered, id: \.self) { option in
                    Button {
                        selected = option
                        dismiss()
                    } label: {
                        HStack {
                            Text(option).foregroundStyle(.primary)
                            Spacer()
                            if selected == option {
                                Image(systemName: "checkmark").foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search \(title)")
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
