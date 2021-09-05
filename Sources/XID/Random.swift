import ChaCha

public struct Random: XIDPrivate {
    static let id: UInt8 = 0b001_00000

    public let description: String
    
    init(unchecked description: String) {
        self.description = description
    }
    
    public init() {
        var rng = ChaCha()
        self.init(using: &rng)
    }
    
    init(using rng: inout ChaCha) {
        var bytes: [UInt8] = []
        bytes.reserveCapacity(25)
        
        rng.append(to: &bytes, count: 24)
        
        bytes.append(Self.id)
        
        description = String(bytes.base32EncodedString().dropLast())
    }
}
