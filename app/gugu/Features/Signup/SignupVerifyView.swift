import SwiftUI
import Combine

struct SignupVerifyView: View {
    
    private enum Gender: String, CaseIterable, Identifiable {
        
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
    
    @StateObject private var vm = SignupViewModel()
    
    @State private var phone: String = ""
    @State private var code: String = ""
    @State private var password: String = ""
    @State private var selectedGender: Gender = .male
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var isSubmit: Bool {
        vm.isSendVerifyCode && !code.isEmpty && !password.isEmpty && !selectedGender.rawValue.isEmpty
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
                                Task {
                                    await vm.sendCode(phone: phone)
                                }
                            } label: {
                                Text(!vm.isSendVerifyCode ? "전송" : "\(vm.verifySecond)")
                                    .font(.headline)
                                    .frame(minWidth: 40)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(!phone.isEmpty ? Color.blue : Color.gray)
                                    .cornerRadius(12)
                            }
                            .disabled(vm.isSendVerifyCode)
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
                    Task {
                        await vm.verifyCode(
                            phone: phone,
                            code: code,
                            password: password,
                            gender: selectedGender.rawValue
                        )
                    }
                } label: {
                    Text("회원가입")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .glassEffect(isSubmit ? .regular.tint(.blue): .regular.tint(.gray))
                }
                .disabled(!isSubmit)
                .padding()
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .onReceive(timer) { _ in
                if vm.isSendVerifyCode {
                    if vm.verifySecond > 0 {
                        vm.verifySecond -= 1
                    } else {
                        vm.isSendVerifyCode = false
                    }
                }
            }
            .onTapGesture {
                KeyboardHelper.hideKeyboard()
            }
        }
        .onAppear {
            showAlert = true
            alertMessage = "미성년자는 이용할 수 없습니다.\n적발 시 영구 정지 대상입니다."
        }
        .alert("알림", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .alert("알림", isPresented: $vm.showAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(vm.alertMessage ?? "")
        }
        .alert("오류", isPresented: Binding(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(vm.errorMessage ?? "")
        }
        .fullScreenCover(isPresented: $vm.showNextView) {
            SignupActivateView()
        }
    }
}

#Preview {
    SignupVerifyView()
}
