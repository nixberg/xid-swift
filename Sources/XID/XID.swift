import Base32
import ChaCha
import Foundation
import Xoodyak

public protocol XIDProtocol: Codable, Equatable, LosslessStringConvertible {
    var description: String { get }
}

protocol XIDPrivate: XIDProtocol {
    static var id: UInt8 { get }
    
    init(unchecked description: String)
}

extension XIDProtocol {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        zip(lhs.description.utf8, rhs.description.utf8).map(^).reduce(0, |) == 0
    }
}

extension XIDPrivate {
    public init?(_ description: String) {
        guard description.isValid(id: Self.id) else {
            return nil
        }
        self.init(unchecked: description)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let description = try container.decode(String.self)
        
        guard description.isValid(id: Self.id) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "TODO")
        }
        self.init(unchecked: description)
    }
}

extension String {
    func isValid(id: UInt8) -> Bool {
        guard count == 39 else {
            return false
        }
        guard let decoded = Array(base32Encoded: self + "0") else {
            return false
        }
        return decoded[24] == id
    }
}

public typealias Timestamp = Int64

extension Timestamp {
    public static var now: Self {
        #if os(macOS)
        
        guard #available(macOS 10.12, *) else {
            return Self(Date().timeIntervalSince1970 * 1e9)
        }
        return Self(clock_gettime_nsec_np(CLOCK_REALTIME))
        
        #else //#elseif os(Linux)
        
        Self(Date().timeIntervalSince1970 * 1e9)
        
        #endif
    }
    
    var offsetBinary: UInt64 {
        UInt64(bitPattern: self) ^ (1 << 63)
    }
}

extension UInt64 {
    var bigEndianBytes: [UInt8] {
        stride(from: 0, to: Self.bitWidth, by: 8)
            .reversed()
            .map { UInt8(truncatingIfNeeded: self &>> $0) }
    }
}
