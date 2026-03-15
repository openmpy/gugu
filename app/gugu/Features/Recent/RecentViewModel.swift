import SwiftUI
import Combine

@MainActor
final class RecentViewModel: ObservableObject {
    
    private let service = MemberService.shared
    
    @AppStorage("selectedRecentGender") var selectedGender: Gender = .all
    @AppStorage("recentComment") var savedComment: String = ""
    
    @Published var errorMessage: String?
    
    @Published var comments: [MemberGetCommentResponse] = []
    
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true
    
    @Published var showToast: Bool = false
    @Published var toastMessage: String?
    
    @Published var showCommentAlert: Bool = false
    @Published var comment: String = ""
    
    private var cursorId: Int64? = nil
    
    func fetchComments(gender: String) async {
        hasNext = true
        
        guard !isLoading, hasNext else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await service.getComments(
                gender: gender,
                cursorId: nil
            )
            
            comments = response.payload
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadMore(gender: String) async {
        guard !isLoading, hasNext else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await service.getComments(
                gender: gender,
                cursorId: cursorId
            )
            
            comments.append(contentsOf: response.payload)
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func writeComment(comment: String) async {
        do {
            try await service.writeComment(comment: comment)
            
            savedComment = comment
            
            showToast = true
            toastMessage = "코멘트가 작성되었습니다."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func bumpComment() async {
        do {
            try await service.bumpComment()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func searchComments(
        keyword: String,
        cursorId: Int64?
    ) async throws -> CursorResponse<MemberSearchCommentResponse> {
        try await service.searchComments(
            keyword: keyword,
            cursorId: cursorId
        )
    }
    
    func updateLocation(latitude: Double?, longitude: Double?) async {
        do {
            try await service.updateLocation(latitude: latitude, longitude: longitude)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
