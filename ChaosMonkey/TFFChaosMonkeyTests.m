#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TFFChaosMonkey.h"

@interface TFFChaosMonkeyTests : XCTestCase
@end

@implementation TFFChaosMonkeyTests

- (void)testWhenInjectingErrorForAllRequestsMatchingThatHostThenNetworkRequestsForThatHostAlwaysReturnThatError {
    NSError *expectedError = [NSError errorWithDomain:@"ChaosDomain" code:1337 userInfo:@{NSLocalizedDescriptionKey:@"An error has occurred!"}];
    [TFFChaosMonkey injectURL:[NSURL URLWithString:@"https://website.abc/inject"] returningError:expectedError priority:TFFChaosMonkeyPriorityAlways];
    
    NSError *actualError;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://website.abc/inject"]];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&actualError];
    
    [self assertThatError:expectedError isEqualToError:actualError];
}

- (void)testWhenNothingIsInjectedForASpecifiedURLThenRequestsForThatURLMayExecuteAsExepcted {
    NSError *expectedError = [NSError errorWithDomain:@"ChaosDomain" code:1337 userInfo:@{NSLocalizedDescriptionKey:@"An error has occurred!"}];
    [TFFChaosMonkey injectURL:[NSURL URLWithString:@"https://website.abc/fail"] returningError:expectedError priority:TFFChaosMonkeyPriorityAlways];
    
    [self assertSuccessfulOfflineRequest];
}

- (void)testWhenInjectingErrorForAllRequestsMatchingThatHostWithHighPriorityThenNetworkRequestsForThatHostMostlyReturnThatError {
    NSError *expectedError = [NSError errorWithDomain:@"ChaosDomain" code:1337 userInfo:@{NSLocalizedDescriptionKey:@"An error has occurred!"}];
    [TFFChaosMonkey injectURL:[NSURL URLWithString:@"https://website.abc/injectHigh"] returningError:expectedError priority:TFFChaosMonkeyPriorityHigh];
    
    int countOfErrors = [self countOfErrorsForRequestWithURL:[NSURL URLWithString:@"https://website.abc/injectHigh"] expectedError:expectedError];
    
    XCTAssertEqualWithAccuracy(countOfErrors, 75, 12);
}

- (void)testWhenInjectingErrorForAllRequestsMatchingThatHostWithMediumPriorityThenNetworkRequestsForThatHostSometimesReturnThatError {
    NSError *expectedError = [NSError errorWithDomain:@"ChaosDomain" code:1337 userInfo:@{NSLocalizedDescriptionKey:@"An error has occurred!"}];
    [TFFChaosMonkey injectURL:[NSURL URLWithString:@"https://website.abc/injectMedium"] returningError:expectedError priority:TFFChaosMonkeyPriorityMedium];
    
    int countOfErrors = [self countOfErrorsForRequestWithURL:[NSURL URLWithString:@"https://website.abc/injectMedium"] expectedError:expectedError];
    
    XCTAssertEqualWithAccuracy(countOfErrors, 50, 12);
}

- (void)testWhenInjectingErrorForAllRequestsMatchingThatHostWithLowPriorityThenNetworkRequestsForThatHostSeldomReturnThatError {
    NSError *expectedError = [NSError errorWithDomain:@"ChaosDomain" code:1337 userInfo:@{NSLocalizedDescriptionKey:@"An error has occurred!"}];
    [TFFChaosMonkey injectURL:[NSURL URLWithString:@"https://website.abc/injectLow"] returningError:expectedError priority:TFFChaosMonkeyPriorityLow];
    
    int countOfErrors = [self countOfErrorsForRequestWithURL:[NSURL URLWithString:@"https://website.abc/injectLow"] expectedError:expectedError];
    
    XCTAssertEqualWithAccuracy(countOfErrors, 25, 12);
}

- (BOOL)error:(NSError *)expectedError isEqualToError:(NSError *)actualError {
    return [expectedError.domain isEqualToString:actualError.domain] &&
    expectedError.code == actualError.code &&
    [expectedError.localizedDescription isEqualToString:actualError.localizedDescription];
}

- (void)assertThatError:(NSError *)expectedError isEqualToError:(NSError *)actualError {
    XCTAssertEqualObjects(expectedError.domain, actualError.domain);
    XCTAssertEqual(expectedError.code, actualError.code);
    XCTAssertEqualObjects(expectedError.localizedDescription, actualError.localizedDescription);
}

- (void)assertSuccessfulOfflineRequest {
    XCTestExpectation *expectation = [self expectationWithDescription:@"offline request"];
    
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"file" ofType:@"txt"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [task resume];
    
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}

- (int)countOfErrorsForRequestWithURL:(NSURL *)url  expectedError:(NSError *)expectedError {
    int countOfErrors = 0;
    for (int i = 0; i < 100; ++i) {
        NSError *actualError;
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&actualError];
        countOfErrors += ([self error:expectedError isEqualToError:actualError]) ? 1 : 0;
    }
    return countOfErrors;
}

@end
