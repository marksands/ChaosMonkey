#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TFFChaosMonkey.h"

@interface TFFChaosMonkeyTests : XCTestCase
@end

@implementation TFFChaosMonkeyTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)assertThatError:(NSError *)expectedError isEqualToError:(NSError *)actualError {
    XCTAssertEqualObjects(expectedError.domain, actualError.domain);
    XCTAssertEqual(expectedError.code, actualError.code);
    XCTAssertEqualObjects(expectedError.localizedDescription, actualError.localizedDescription);
}

- (void)testWhenInjectingErrorForAllRequestsMatchingThatHostThenNetworkRequestsForThatHostAlwaysReturnThatError {
    NSError *expectedError = [NSError errorWithDomain:@"ChaosDomain" code:1337 userInfo:@{NSLocalizedDescriptionKey:@"An error has occurred!"}];
    [TFFChaosMonkey injectURL:[NSURL URLWithString:@"https://website.abc/inject"] returningError:expectedError priority:TFFChaosMonkeyPriorityAlways];
    
    NSError *actualError;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://website.abc/inject"]];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&actualError];
    
    [self assertThatError:expectedError isEqualToError:actualError];
}

@end
