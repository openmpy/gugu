import SwiftUI
import Combine

@MainActor
final class LocationViewModel: ObservableObject {
    
    @Published var locations: [MemberGetLocationResponse] = []
    
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true
    
    private let service = MemberService.shared
    
    private var cursorId: Int64? = nil
    
    func fetchLocations(gender: String) async {
        hasNext = true
        
        guard !isLoading, hasNext else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await service.getLocations(
                gender: gender,
                cursorId: nil
            )
            
            locations = response.payload
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
            let response = try await service.getLocations(
                gender: gender,
                cursorId: cursorId
            )
            
            locations.append(contentsOf: response.payload)
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            print(error)
        }
    }
    
    func updateLocation(latitude: Double?, longitude: Double?) async {
        do {
            try await service.updateLocation(latitude: latitude, longitude: longitude)
        } catch {
            print(error)
        }
    }
}
