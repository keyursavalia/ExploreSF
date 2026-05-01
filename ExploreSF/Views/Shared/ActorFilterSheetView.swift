import SwiftUI

struct ActorFilterSheetView: View {
    @Binding var actorName: String?
    let onApply: (String) -> Void

    @State   private var input = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter an actor or director name to filter films they appeared in.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                TextField("e.g. Robin Williams", text: $input)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .onSubmit { apply() }

                if actorName != nil {
                    Button("Clear Actor Filter", role: .destructive) {
                        actorName = nil
                        dismiss()
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Filter by Actor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") { apply() }
                        .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.fraction(0.4)])
        .onAppear { input = actorName ?? "" }
    }

    private func apply() {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        actorName = trimmed
        onApply(trimmed)
        dismiss()
    }
}
