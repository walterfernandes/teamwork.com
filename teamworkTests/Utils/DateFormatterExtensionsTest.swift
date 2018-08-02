
import XCTest
@testable import teamwork

class DateFormatterExtensionsTest: XCTestCase {
    
    func testyyyyMMdd() {
        let dateString = "20131204"
        let date = DateFormatter.yyyyMMdd.date(from: dateString)!
        XCTAssertTrue(DateFormatter.yyyyMMdd.string(from: date) == dateString)
    }
    
}
