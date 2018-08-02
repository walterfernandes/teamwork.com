
import XCTest
@testable import teamwork

class ResponseDecoderTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testResponseContainerCreate() {
        
        let jsonData = """
            {
              "STATUS": "OK",
              "projects": [
                {
                  "company": {
                    "name": "Demo 1 Company",
                    "is-owner": "1",
                    "id": "999"
                  },
                  "starred": false,
                  "name": "Demo Project",
                  "show-announcement": false,
                  "announcement": "",
                  "description": "",
                  "status": "active",
                  "isProjectAdmin": false,
                  "created-on": "2013-12-04T19:11:44Z",
                  "category": {
                    "name": "",
                    "id": ""
                  },
                  "start-page": "projectoverview",
                  "startDate": "20131204",
                  "logo": "http://demo1company.teamwork.com/images/logo.jpg",
                  "notifyeveryone": false,
                  "id": "999",
                  "last-changed-on": "2014-03-18T11:20:49Z",
                  "endDate": "20140313",
                  "harvest-timers-enabled": "true"
                },
                {
                  "company": {
                    "name": "Demo 1 Company",
                    "is-owner": "1",
                    "id": "999"
                  },
                  "starred": false,
                  "name": "Demo Project 2",
                  "show-announcement": false,
                  "announcement": "",
                  "description": "",
                  "status": "active",
                  "isProjectAdmin": false,
                  "created-on": "2013-12-04T19:11:44Z",
                  "category": {
                    "name": "",
                    "id": ""
                  },
                  "start-page": "projectoverview",
                  "startDate": "20131204",
                  "logo": "http://demo1company.teamwork.com/images/logo.jpg",
                  "notifyeveryone": false,
                  "id": "990",
                  "last-changed-on": "2014-03-18T11:20:49Z",
                  "endDate": "20140313",
                  "harvest-timers-enabled": "true"
                }

              ]
            }
        """.data(using: .utf8)!
        
        let responseContainer = try? ResponseDecoder<[Project]>.decode(jsonData, rootElement: "projects")
        XCTAssertNotNil(responseContainer)
        XCTAssertTrue(responseContainer?.status == "OK")
        XCTAssertTrue(responseContainer?.data.first?.name == "Demo Project")
        XCTAssertTrue(responseContainer?.data.first?.starred == false)
        XCTAssertTrue(responseContainer?.data.first?.description == "")
        XCTAssertTrue(responseContainer?.data.first?.status == "active")
        XCTAssertTrue(responseContainer?.data.first?.id == "999")
        let createdOn = ISO8601DateFormatter().date(from: "2013-12-04T19:11:44Z")
        XCTAssertEqual(createdOn, responseContainer?.data.first?.createdOn)
        let startDate = DateFormatter.yyyyMMdd.date(from: "20131204")!
        XCTAssertEqual(startDate, responseContainer?.data.first?.startDate)
        let endDate = DateFormatter.yyyyMMdd.date(from: "20140313")!
        XCTAssertEqual(endDate, responseContainer?.data.first?.endDate)
        XCTAssertTrue(responseContainer?.data.first?.logo?.absoluteString == "http://demo1company.teamwork.com/images/logo.jpg")
    }
    

}
