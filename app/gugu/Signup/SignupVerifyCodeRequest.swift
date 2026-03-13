struct SignupVerifyCodeRequest: Codable {
    let phone: String
    let code: String
    let password: String
    let gender: String
}
