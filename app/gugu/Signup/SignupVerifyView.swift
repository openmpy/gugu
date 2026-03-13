import SwiftUI
import Combine

struct SignupVerifyView: View {
    
    enum Gender: String, CaseIterable, Identifiable {
        case male = "MALE"
        case female = "FEMALE"
        
        var id: Self { self }
        
        var displayName: String {
            switch self {
            case .male: return "남자"
            case .female: return "여자"
            }
        }
    }
    
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var selectedGender: Gender = .male
    
    @State private var code: String = ""
    @State private var isSendVerifyCode: Bool = false
    @State private var verifySecond: Int = 180
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showNextView = false
    
    private var isSubmit: Bool {
        isSendVerifyCode && !code.isEmpty && !password.isEmpty && !selectedGender.rawValue.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("휴대폰")
                            .font(.headline)
                        
                        HStack {
                            TextField("휴대폰 번호를 입력해주세요", text: $phone)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                                .keyboardType(.numberPad)
                                .submitLabel(.done)
                            
                            Button {
                                sendCode()
                            } label: {
                                Text(!isSendVerifyCode ? "전송" : "\(verifySecond)")
                                    .font(.headline)
                                    .frame(minWidth: 40)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(!phone.isEmpty ? Color.blue : Color.gray)
                                    .cornerRadius(12)
                            }
                            .disabled(isSendVerifyCode)
                        }
                    }
                    .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("인증번호")
                            .font(.headline)
                        
                        TextField("인증번호를 입력해주세요", text: $code)
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
                    
                    VStack(alignment: .leading) {
                        Text("성별")
                            .font(.headline)
                        
                        HStack {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Button {
                                    selectedGender = gender
                                } label: {
                                    Text(gender.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(selectedGender == gender ? Color.blue : Color.gray)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.bottom, 5)
                        
                        Text("성별은 변경할 수 없습니다. 신중하게 선택해주세요.")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                    .padding(.bottom)
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    verifyCode()
                } label: {
                    Text("회원가입")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSubmit ? Color.blue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!isSubmit)
                .padding()
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .onReceive(timer) { _ in
                if isSendVerifyCode {
                    if verifySecond > 0 {
                        verifySecond -= 1
                    } else {
                        isSendVerifyCode = false
                    }
                }
            }
            .onTapGesture {
                KeyboardHelper.hideKeyboard()
            }
        }
        .onAppear {
            showAlert = true
            alertMessage = "미성년자는 이용할 수 없습니다.\n적발 시 차단될 수 있습니다."
        }
        .alert("알림", isPresented: $showAlert) {
            Button("닫기", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(isPresented: $showNextView) {
            SignupActivateView()
        }
    }
    
    func sendCode() {
        SignupService.shared.sendCode(phone: phone) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    isSendVerifyCode = true
                    verifySecond = 180
                    
                    showAlert = true
                    alertMessage = "인증 번호가 전송되었습니다."
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert = true
                    alertMessage = error.localizedDescription
                }
            }
        }
    }
    
    func verifyCode() {
        SignupService.shared.verifyCode(
            phone: phone,
            code: code,
            password: password,
            gender: selectedGender.rawValue,
        ) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    showNextView = true
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
    SignupVerifyView()
}
