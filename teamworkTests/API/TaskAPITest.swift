
import XCTest
@testable import teamwork

class TaskAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetTasklistsRequest() {
        
        let expectation = XCTestExpectation(description: "Get Tasklists")
        
        TaskAPI().getTasklists(byProject: "462923") { response in
            
            switch response {
            case .success(let tasklists):
                XCTAssertNotNil(tasklists, "Empty response.")
                print("projects: \(tasklists.debugDescription)")
            case .error(let error):
                XCTFail("Fail with error: \(error.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

    func testGetTasksRequest() {
        
        let expectation = XCTestExpectation(description: "Get Task")
        
        TaskAPI().getTasks(byTasklist: "1644707") { response in
            
            switch response {
            case .success(let taskList):
                XCTAssertNotNil(taskList, "Empty response.")
                print("projects: \(taskList.debugDescription)")
            case .error(let error):
                XCTFail("Fail with error: \(error.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

    func testPostMultipleTasksTest() {
        
        let expectation = XCTestExpectation(description: "Post Multiple Task")
        
        let tasks = MultTaskPost(content: "test-1\ntest-2",
                                 tasklistId: "462923",
                                 projectId: "462923")
        
        TaskAPI().postMultipleTasks(tasks) { response in
            
            switch response {
            case .success:
                XCTAssert(true)
            case .error(let error):
                XCTFail("Fail with error: \(error.localizedDescription)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)

    }
}

