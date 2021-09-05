import Xoodyak

public struct Hash: XIDPrivate {
    static let id: UInt8 = 0b000_00000
    
    public let description: String
    
    init(unchecked description: String) {
        self.description = description
    }

    public init<Input>(hashing input: Input) where Input: Sequence, Input.Element == UInt8 {
        var bytes: [UInt8] = []
        bytes.reserveCapacity(25)
        
        var xoodyak = Xoodyak()
        xoodyak.absorb(input)
        xoodyak.squeeze(to: &bytes, count: 24)
        
        bytes.append(Self.id)

        description = String(bytes.base32EncodedString().dropLast())
    }
}
