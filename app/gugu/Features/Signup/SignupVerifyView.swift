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
    
    @State private var selectedGender: Gender = .male
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("휴대폰")
                            .font(.headline)
                        
                        HStack {
                            TextField("휴대폰 번호를 입력해주세요", text: $vm.phone)
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
                                    await vm.sendCode(phone: vm.phone)
                                }
                            } label: {
                                Text(!vm.isSendVerifyCode ? "전송" : "\(vm.verifySecond)")
                                    .font(.headline)
                                    .frame(minWidth: 40)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(!vm.phone.isEmpty ? Color.blue : Color.gray)
                                    .cornerRadius(12)
                            }
                            .disabled(vm.isSendVerifyCode)
                        }
                    }
                    .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("인증번호")
                            .font(.headline)
                        
                        TextField("인증번호를 입력해주세요", text: $vm.code)
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
                        
                        SecureField("비밀번호를 입력해주세요", text: $vm.password)
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
                            phone: vm.phone,
                            code: vm.code,
                            password: vm.password,
                            gender: selectedGender.rawValue
                        )
                    }
                } label: {
                    Text("회원가입")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .glassEffect(vm.isSubmit ? .regular.tint(.blue): .regular.tint(.gray))
                }
                .disabled(!vm.isSubmit)
                .padding()
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .onTapGesture {
                KeyboardHelper.hideKeyboard()
            }
        }
        .onAppear {
            vm.showAlert = true
            vm.alertMessage = "미성년자는 이용할 수 없습니다.\n적발 시 영구 정지 대상입니다."
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
