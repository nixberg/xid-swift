import ChaCha
import XCTest
@testable import XID

final class XIDTests: XCTestCase {
    func testHash() throws {
        XCTAssertEqual(
            Hash(hashing: "".utf8),
            Hash("x8ajyat7qkh4xyu6rhwx9bfhff9j9p06x1fzeqg"))
        
        XCTAssertNil(Hash(String(Random())))
        XCTAssertNil(Hash(String(TimeAndHash(hashing: "".utf8))))
        XCTAssertNil(Hash(String(TimeAndRandom())))
        
        try codableTest(with: Hash(hashing: "Codable".utf8))
    }
    
    func testRandom() throws {
        var rng = ChaCha(seed: .zero)
        
        XCTAssertEqual(
            Random(using: &rng),
            Random("7r0eybw9bx0dcztuq3m1y2d5m4p883p3std7yes"))
        XCTAssertEqual(
            Random(using: &rng),
            Random("30dy327fe4d1x62cw5sbj8bf86fm8mu78npnc69"))
        
        XCTAssertNil(Random(String(Hash(hashing: "".utf8))))
        XCTAssertNil(Random(String(TimeAndHash(hashing: "".utf8))))
        XCTAssertNil(Random(String(TimeAndRandom())))
        
        try codableTest(with: Random())
    }
    
    func testTimeAndHash() throws {
        XCTAssertEqual(
            TimeAndHash(hashing: "".utf8, nanosecondsSince1970: .min),
            TimeAndHash("0000000000001tgn5wnmff729uxpdh3stjpz2yt"))
        XCTAssertEqual(
            TimeAndHash(hashing: "".utf8, nanosecondsSince1970: .zero),
            TimeAndHash("g000000000001tgn5wnmff729uxpdh3stjpz2yt"))
        XCTAssertEqual(
            TimeAndHash(hashing: "".utf8, nanosecondsSince1970: .max),
            TimeAndHash("zzzzzzzzzzzzztgn5wnmff729uxpdh3stjpz2yt"))
        
        XCTAssertNil(TimeAndHash(String(Hash(hashing: "".utf8))))
        XCTAssertNil(TimeAndHash(String(Random())))
        XCTAssertNil(TimeAndHash(String(TimeAndRandom())))
        
        try codableTest(with: TimeAndHash(hashing: "Codable".utf8))
    }
    
    func testTimeAndRandom() throws {
        var rng = ChaCha(seed: .zero)
        
        XCTAssertEqual(
            TimeAndRandom(nanosecondsSince1970: .min, using: &rng),
            TimeAndRandom("0000000000000fg0xwqrjqt0tsznqe783w4tb8b"))
        XCTAssertEqual(
            TimeAndRandom(nanosecondsSince1970: .zero, using: &rng),
            TimeAndRandom("g000000000000b441u1wx6kz7cc1qrc8xxrhm7k"))
        XCTAssertEqual(
            TimeAndRandom(nanosecondsSince1970: .max, using: &rng),
            TimeAndRandom("zzzzzzzzzzzzz62cw5sbj8bf86fm8mu78npnc6b"))
        
        XCTAssertNil(TimeAndRandom(String(Hash(hashing: "".utf8))))
        XCTAssertNil(TimeAndRandom(String(Random())))
        XCTAssertNil(TimeAndRandom(String(TimeAndHash(hashing: "".utf8))))
        
        try codableTest(with: TimeAndRandom())
    }
}

fileprivate func codableTest<XID: XIDProtocol>(
    with xid: XID,
    file: StaticString = #filePath,
    line: UInt = #line
) throws {
    let json = Data("\"\(xid)\"".utf8)
    
    let decoded = try JSONDecoder().decode(XID.self, from: json)
    XCTAssertEqual(decoded, xid, file: file, line: line)
    
    XCTAssertEqual(try JSONEncoder().encode(decoded), json, file: file, line: line)
}
