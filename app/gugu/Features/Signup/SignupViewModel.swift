import SwiftUI
import Combine

@MainActor
final class SignupViewModel: ObservableObject {
    
    private let service = MemberService.shared
    
    @Published var errorMessage: String?
    
    @Published var isSendVerifyCode: Bool = false
    @Published var verifySecond: Int = 180
    
    @Published var isActivated = false
    @Published var showNextView = false
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String?
    
    @Published var nickname: String = ""
    @Published var birthYear: String = ""
    @Published var bio: String = ""
    
    @Published var phone: String = ""
    @Published var code: String = ""
    @Published var password: String = ""
    
    private var timerCancellable: AnyCancellable?
    
    var isSubmit: Bool {
        isSendVerifyCode && !code.isEmpty && !password.isEmpty
    }
    
    init() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.isSendVerifyCode {
                    if self.verifySecond > 0 {
                        self.verifySecond -= 1
                    } else {
                        self.isSendVerifyCode = false
                    }
                }
            }
    }
    
    func sendCode(phone: String) async {
        do {
            try await service.sendCode(phone: phone)
            
            isSendVerifyCode = true
            verifySecond = 180
            
            showAlert = true
            alertMessage = "인증번호가 발송되었습니다."
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func verifyCode(phone: String, code: String, password: String, gender: String) async {
        do {
            let response = try await service.verifyCode(
                phone: phone,
                code: code,
                password: password,
                gender: gender
            )
            
            saveToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
            showNextView = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func activate(nickname: String, birthYear: String, bio: String) async {
        do {
            try await service.activate(nickname: nickname, birthYear: Int(birthYear) ?? 2000, bio: bio)
            
            isActivated = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func saveToken(accessToken: String, refreshToken: String) {
        KeychainHelper.save(key: "accessToken", value: accessToken)
        KeychainHelper.save(key: "refreshToken", value: refreshToken)
    }
}
