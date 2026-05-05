import SwiftUI

struct HistoryView: View {
    @State private var entries: [Entry] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("History")
                        .font(.title.weight(.bold))
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Button {
                        loadEntries()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(AppTheme.accent)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 8)

                if isLoading {
                    Spacer()
                    ProgressView()
                        .tint(AppTheme.accent)
                        .scaleEffect(1.2)
                    Spacer()
                } else if let errorMessage = errorMessage {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 40))
                            .foregroundColor(AppTheme.textMuted)
                        Text(errorMessage)
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") { loadEntries() }
                            .foregroundColor(AppTheme.accent)
                    }
                    .padding()
                    Spacer()
                } else if entries.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 44))
                            .foregroundColor(AppTheme.textMuted)
                        Text("No entries yet")
                            .font(.headline)
                            .foregroundColor(AppTheme.textSecondary)
                        Text("Your journal entries will appear here")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textMuted)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(entries) { entry in
                                EntryCard(entry: entry, onDelete: {
                                    deleteEntryFromList(entry)
                                })
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    }
                }
            }
        }
        .onAppear { loadEntries() }
    }

    private func loadEntries() {
        let userId = UserSession.shared.userId
        guard !userId.isEmpty else {
            errorMessage = "Please log in again"
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil
        getEntriesByUser(userId: userId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetched):
                    entries = fetched
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func deleteEntryFromList(_ entry: Entry) {
        deleteEntry(id: entry.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    withAnimation {
                        entries.removeAll { $0.id == entry.id }
                    }
                case .failure:
                    break
                }
            }
        }
    }
}

struct EntryCard: View {
    let entry: Entry
    let onDelete: () -> Void
    @State private var showDeleteConfirm = false

    private var moodEmoji: String {
        switch entry.sentimentScore {
        case 1...2: return "😢"
        case 3...4: return "😔"
        case 5...6: return "😐"
        case 7...8: return "😊"
        case 9...10: return "😄"
        default: return "😐"
        }
    }

    private var formattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: entry.createdAt) {
            let display = DateFormatter()
            display.dateStyle = .medium
            display.timeStyle = .short
            return display.string(from: date)
        }
        let fallback = ISO8601DateFormatter()
        if let date = fallback.date(from: entry.createdAt) {
            let display = DateFormatter()
            display.dateStyle = .medium
            display.timeStyle = .short
            return display.string(from: date)
        }
        return entry.createdAt
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(moodEmoji)
                    .font(.title2)
                Text("Mood: \(entry.sentimentScore)/10")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(AppTheme.accent)
                Spacer()
                Button {
                    showDeleteConfirm = true
                } label: {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(AppTheme.destructive.opacity(0.7))
                }
            }

            Text(entry.content)
                .font(.body)
                .foregroundColor(AppTheme.textPrimary)
                .lineLimit(4)

            Text(formattedDate)
                .font(.caption)
                .foregroundColor(AppTheme.textMuted)
        }
        .padding(16)
        .background(AppTheme.cardBg)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(AppTheme.border, lineWidth: 1)
        )
        .confirmationDialog("Delete this entry?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { onDelete() }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    HistoryView()
}
