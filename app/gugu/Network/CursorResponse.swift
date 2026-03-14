struct CursorResponse<T: Decodable>: Decodable {
    let payload: [T]
    let nextId: Int64?
    let hasNext: Bool
}
