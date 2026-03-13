import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var auth: AuthState
    
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
                    login()
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("알림"),
                message: Text(alertMessage),
                dismissButton: .default(Text("확인"))
            )
        }
    }
    
    func login() {
        LoginService.shared.login(phone: phone, password: password) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    auth.isLoggedIn = true
                    saveToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert = true
                    alertMessage = error.localizedDescription
                }
            }
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
