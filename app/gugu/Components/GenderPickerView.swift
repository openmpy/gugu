import SwiftUI

struct GenderPickerView: View {
    
    @Binding var selectedGender: Gender
    var onChange: ((Gender, Gender) -> Void)? = nil
    
    var body: some View {
        Picker("Gender", selection: $selectedGender) {
            ForEach(Gender.allCases) { gender in
                Text(gender.text).tag(gender)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.top)
        .padding(.bottom, 5)
        .onChange(of: selectedGender) { oldGender, newGender in
            onChange?(oldGender, newGender)
        }
    }
}
