import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var auth: AuthState
    
    @StateObject private var vm = LoginViewModel()
    
    @State private var phone: String = ""
    @State private var password = ""
    
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
                        await vm.login(phone: phone, password: password)
                    }
                } label: {
                    Text("로그인")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .glassEffect(isSubmit ? .regular.tint(.blue): .regular.tint(.gray))
                }
                .disabled(!isSubmit)
            }
            .padding()
            .navigationTitle("로그인")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
        .onChange(of: vm.isActivated) { _, activated in
            if activated {
                auth.isLoggedIn = true
            }
        }
        .alert("오류", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(vm.errorMessage ?? "")
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
