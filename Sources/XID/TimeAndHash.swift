import Xoodyak

public struct TimeAndHash: XIDPrivate {
    static let id: UInt8 = 0b010_00000

    public let description: String
    
    init(unchecked description: String) {
        self.description = description
    }
    
    public init<Input>(hashing input: Input, nanosecondsSince1970: Timestamp = .now)
    where Input: Sequence, Input.Element == UInt8 {
        var bytes: [UInt8] = []
        bytes.reserveCapacity(25)
        
        bytes.append(contentsOf: nanosecondsSince1970.offsetBinary.bigEndianBytes)
        
        var xoodyak = Xoodyak()
        xoodyak.absorb(input)
        xoodyak.squeeze(to: &bytes, count: 16)
        
        bytes.append(Self.id)
        
        description = String(bytes.base32EncodedString().dropLast())
    }
}
