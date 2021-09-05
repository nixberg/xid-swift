import ChaCha

public struct TimeAndRandom: XIDPrivate {
    static let id: UInt8 = 0b011_00000

    public let description: String
    
    init(unchecked description: String) {
        self.description = description
    }
    
    public init(nanosecondsSince1970: Timestamp = .now) {
        var rng = ChaCha()
        self.init(nanosecondsSince1970: nanosecondsSince1970, using: &rng)
    }
    
    init(nanosecondsSince1970: Timestamp = .now, using rng: inout ChaCha) {
        var bytes: [UInt8] = []
        bytes.reserveCapacity(25)
        
        bytes.append(contentsOf: nanosecondsSince1970.offsetBinary.bigEndianBytes)
        
        rng.append(to: &bytes, count: 16)
        
        bytes.append(Self.id)

        description = String(bytes.base32EncodedString().dropLast())
    }
}
