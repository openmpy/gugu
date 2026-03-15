import SwiftUI
import Combine

@MainActor
final class RecentSearchViewModel: ObservableObject {
    
    @Published var comments: [MemberSearchCommentResponse] = []
    
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true
    
    private let service = MemberService.shared
    
    private var cursorId: Int64? = nil
    private var keyword: String = ""
    
    func search(keyword: String) async {
        guard !keyword.isEmpty else {
            comments = []
            return
        }
        
        self.keyword = keyword
        hasNext = true
        
        guard !isLoading, hasNext else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await service.searchComments(
                keyword: keyword,
                cursorId: nil
            )
            
            comments = response.payload
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            print(error)
        }
    }
    
    func loadMoreSearch() async {
        guard !isLoading, hasNext else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await service.searchComments(
                keyword: keyword,
                cursorId: cursorId
            )
            
            comments.append(contentsOf: response.payload)
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            print(error)
        }
    }
}
