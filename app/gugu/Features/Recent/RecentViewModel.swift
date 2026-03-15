import SwiftUI
import Combine

@MainActor
final class RecentViewModel: ObservableObject {
    
    @Published var comments: [MemberGetCommentResponse] = []
    
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true
    
    private let service = MemberService.shared
    
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
            print(error)
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
            print(error)
        }
    }
    
    func writeComment(comment: String) async {
        do {
            try await service.writeComment(comment: comment)
        } catch {
            print(error)
        }
    }
    
    func bumpComment() async {
        do {
            try await service.bumpComment()
        } catch is CancellationError {
            return
        } catch {
            print(error)
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
}
