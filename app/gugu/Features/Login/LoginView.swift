import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var auth: AuthState
    
    @StateObject private var vm = LoginViewModel()
    
    @State private var phone: String = ""
    @State private var password = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private var isSubmit: Bool {
        !phone.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("휴대폰")
                        .font(.headline)
                    
                    TextField("휴대폰 번호를 입력해주세요", text: $phone)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .keyboardType(.numberPad)
                        .submitLabel(.done)
                }
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("비밀번호")
                        .font(.headline)
                    
                    SecureField("비밀번호를 입력해주세요", text: $password)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .textContentType(.password)
                        .submitLabel(.done)
                }
                .padding(.bottom)
                
                VStack(alignment: .center) {
                    NavigationLink(destination: SignupVerifyView()) {
                        Text("회원가입")
                    }
                }
                .padding(.bottom)
                
                Spacer()
                
                Button {
                    Task {
                        do {
                            let response = try await vm.login(phone: phone, password: password)
                            
                            saveToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
                            auth.isLoggedIn = true
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("로그인")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSubmit ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!isSubmit)
            }
            .padding()
            .navigationTitle("로그인")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
        .alert("알림", isPresented: $showAlert) {
            Button("닫기", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func saveToken(accessToken: String, refreshToken: String) {
        KeychainHelper.save(key: "accessToken", value: accessToken)
        KeychainHelper.save(key: "refreshToken", value: refreshToken)
    }
}

#Preview {
    LoginView()
}
