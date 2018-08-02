
import XCTest
@testable import teamwork

class ProjectAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetProjectsRequest() {
        
        let expectation = XCTestExpectation(description: "Get Project List")
        
        ProjectAPI().getProjectList { response in
            
            switch response {
            case .success(let projects):
                XCTAssertNotNil(projects, "Empty response.")
                print("projects: \(projects.debugDescription)")
            case .error(let error):
                XCTFail("Fail with error: \(error.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}
