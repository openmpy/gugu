import SwiftUI

struct PointView: View {
    let products: [PointProduct] = [
        .init(point: 1000, price: 1500),
        .init(point: 3000, price: 4500),
        .init(point: 5000, price: 7500),
        .init(point: 10000, price: 15000),
        .init(point: 20000, price: 30000)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 10) {
                        Text("보유 포인트")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("3,200 P")
                            .font(.system(size: 36, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.1))
                    )
                    
                    VStack(spacing: 12) {
                        ForEach(products) { product in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(product.point) 포인트")
                                        .font(.headline)
                                    
                                    Text("\(product.price)원")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Button {
                                    
                                } label: {
                                    Text("구매")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 8)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                                
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("포인트")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

struct PointProduct: Identifiable {
    let id = UUID()
    let point: Int
    let price: Int
}

#Preview {
    PointView()
}
