import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [ChatBubble] = []
    @State private var sessionId: String?
    @State private var isWaitingForAI = false
    @State private var sessions: [ChatSession] = []
    @State private var showSessionsList = false

    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                chatHeader
                Divider().background(AppTheme.border)

                if messages.isEmpty && !isWaitingForAI {
                    emptyState
                } else {
                    messagesList
                }

                chatInput
            }
        }
        .sheet(isPresented: $showSessionsList) {
            SessionsListView(
                sessions: $sessions,
                onSelect: { session in
                    loadSession(session)
                    showSessionsList = false
                },
                onDelete: { session in
                    deleteSession(session)
                }
            )
        }
    }

    private var chatHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("AI Chat")
                    .font(.title2.weight(.bold))
                    .foregroundColor(AppTheme.textPrimary)
                if let sessionId = sessionId {
                    Text("Session: \(sessionId.prefix(8))...")
                        .font(.caption2)
                        .foregroundColor(AppTheme.textMuted)
                }
            }
            Spacer()
            Button {
                loadSessionsList()
                showSessionsList = true
            } label: {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(AppTheme.accent)
            }
            Button {
                startNewChat()
            } label: {
                Image(systemName: "plus.bubble")
                    .foregroundColor(AppTheme.accent)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.textMuted)
            Text("Chat with your journal")
                .font(.headline)
                .foregroundColor(AppTheme.textSecondary)
            Text("Ask questions about your mood patterns,\nget insights from your entries.")
                .font(.subheadline)
                .foregroundColor(AppTheme.textMuted)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }

    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { msg in
                        bubbleView(for: msg)
                            .id(msg.id)
                    }
                    if isWaitingForAI {
                        typingIndicator
                            .id("typing")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .onChange(of: messages.count) { _ in
                withAnimation {
                    if let last = messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
            .onChange(of: isWaitingForAI) { waiting in
                if waiting {
                    withAnimation { proxy.scrollTo("typing", anchor: .bottom) }
                }
            }
        }
    }

    private func bubbleView(for msg: ChatBubble) -> some View {
        HStack {
            if msg.isUser { Spacer(minLength: 60) }
            Text(msg.content)
                .font(.body)
                .foregroundColor(.white)
                .padding(12)
                .background(msg.isUser ? AppTheme.userBubble : AppTheme.aiBubble)
                .cornerRadius(16, corners: msg.isUser
                    ? [.topLeft, .topRight, .bottomLeft]
                    : [.topLeft, .topRight, .bottomRight])
            if !msg.isUser { Spacer(minLength: 60) }
        }
    }

    private var typingIndicator: some View {
        HStack {
            HStack(spacing: 5) {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(AppTheme.accent.opacity(0.6))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(12)
            .background(AppTheme.aiBubble)
            .cornerRadius(16)
            Spacer(minLength: 60)
        }
    }

    private var chatInput: some View {
        HStack(spacing: 10) {
            TextField("Type a message...", text: $messageText, axis: .vertical)
                .lineLimit(1...4)
                .padding(12)
                .background(AppTheme.inputBg)
                .foregroundColor(AppTheme.textPrimary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.border, lineWidth: 1)
                )
                .focused($isInputFocused)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 34))
                    .foregroundColor(canSend ? AppTheme.accent : AppTheme.accent.opacity(0.3))
            }
            .disabled(!canSend)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(AppTheme.surface)
    }

    private var canSend: Bool {
        !isWaitingForAI && !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userId = UserSession.shared.userId
        guard !userId.isEmpty else { return }

        let userBubble = ChatBubble(id: UUID().uuidString, content: trimmed, isUser: true)
        messages.append(userBubble)
        messageText = ""
        isWaitingForAI = true

        sendChatMessage(message: trimmed, userId: userId, sessionId: sessionId) { result in
            DispatchQueue.main.async {
                isWaitingForAI = false
                switch result {
                case .success(let response):
                    sessionId = response.sessionId
                    let aiBubble = ChatBubble(id: UUID().uuidString, content: response.response, isUser: false)
                    messages.append(aiBubble)
                case .failure(let error):
                    let errorBubble = ChatBubble(id: UUID().uuidString, content: "Something went wrong: \(error.localizedDescription)", isUser: false)
                    messages.append(errorBubble)
                }
            }
        }
    }

    private func startNewChat() {
        messages = []
        sessionId = nil
    }

    private func loadSessionsList() {
        let userId = UserSession.shared.userId
        guard !userId.isEmpty else { return }
        getChatSessionsByUser(userId: userId) { result in
            DispatchQueue.main.async {
                if case .success(let fetched) = result {
                    sessions = fetched
                }
            }
        }
    }

    private func loadSession(_ session: ChatSession) {
        sessionId = session.id
        messages = []
        isWaitingForAI = true

        getChatHistory(sessionId: session.id) { result in
            DispatchQueue.main.async {
                isWaitingForAI = false
                if case .success(let fetched) = result {
                    messages = fetched.map { msg in
                        ChatBubble(id: msg.id, content: msg.content, isUser: msg.role == "user")
                    }
                }
            }
        }
    }

    private func deleteSession(_ session: ChatSession) {
        deleteChatSession(id: session.id) { result in
            DispatchQueue.main.async {
                if case .success = result {
                    sessions.removeAll { $0.id == session.id }
                    if sessionId == session.id {
                        startNewChat()
                    }
                }
            }
        }
    }
}

struct ChatBubble: Identifiable {
    let id: String
    let content: String
    let isUser: Bool
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct SessionsListView: View {
    @Binding var sessions: [ChatSession]
    let onSelect: (ChatSession) -> Void
    let onDelete: (ChatSession) -> Void
    @Environment(\.dismiss) var dismiss

    private func formattedDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) {
            let display = DateFormatter()
            display.dateStyle = .medium
            display.timeStyle = .short
            return display.string(from: date)
        }
        let fallback = ISO8601DateFormatter()
        if let date = fallback.date(from: dateString) {
            let display = DateFormatter()
            display.dateStyle = .medium
            display.timeStyle = .short
            return display.string(from: date)
        }
        return dateString
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg.ignoresSafeArea()

                if sessions.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 40))
                            .foregroundColor(AppTheme.textMuted)
                        Text("No past conversations")
                            .foregroundColor(AppTheme.textSecondary)
                    }
                } else {
                    List {
                        ForEach(sessions) { session in
                            Button {
                                onSelect(session)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Image(systemName: session.contextType == "single_entry"
                                              ? "doc.text" : "globe")
                                            .foregroundColor(AppTheme.accent)
                                        Text(session.contextType == "single_entry"
                                             ? "Entry Chat" : "Global Chat")
                                            .font(.headline)
                                            .foregroundColor(AppTheme.textPrimary)
                                    }
                                    Text(formattedDate(session.createdAt))
                                        .font(.caption)
                                        .foregroundColor(AppTheme.textMuted)
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(AppTheme.cardBg)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { i in
                                onDelete(sessions[i])
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Past Conversations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(AppTheme.accent)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    ChatView()
}
