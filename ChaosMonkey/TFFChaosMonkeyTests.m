#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TFFChaosMonkey.h"
#import "TFFMockRandomNumberProvider.h"

@interface TFFChaosMonkeyTests : XCTestCase {
	TFFMockRandomNumberProvider *randomNumberProvider;
	TFFChaosMonkey *testObject;
}
@end

@implementation TFFChaosMonkeyTests

- (void)testWhenStubbingErrorResponseForAURLAndARequestIsMadeForThatURLAndRandomNumberProviderReturnsTrueThenStubbedErrorResponseIsReturned {
	randomNumberProvider = [[TFFMockRandomNumberProvider alloc] initWithGeneratedRandomNumbers:@[@1]];
	NSError *error = [NSError errorWithDomain:@"domain" code:3 userInfo:nil];
	NSURL *url = [NSURL URLWithString:@"https://api.example.com/endpoint?withQueryString=1"];

	testObject = [[TFFChaosMonkey alloc] initWithRandomNumberProvider:randomNumberProvider];
	[testObject stubURL:url returningError:error];

	[self verifyError:error	fromURL:url];

	NSURL *urlWithDifferingEndpoint = [NSURL URLWithString:@"https://api.example.com/endpoint2?withQueryString=2"];
	[self verifyNoError:error fromURL:urlWithDifferingEndpoint];
}

- (void)testWhenStubbingErrorResponseForMultipleURLsAndRequestIsMadeForAllURLsAndRandomNumberProviderReturnsTrueThenStubbedErrorResponsesAreReturned {
	randomNumberProvider = [[TFFMockRandomNumberProvider alloc] initWithGeneratedRandomNumbers:@[@1, @1]];
	NSError *error1 = [NSError errorWithDomain:@"domain1" code:333 userInfo:nil];
	NSError *error2 = [NSError errorWithDomain:@"domain2" code:444 userInfo:nil];
	NSURL *url1 = [NSURL URLWithString:@"https://api.example.com/endpoint1"];
	NSURL *url2 = [NSURL URLWithString:@"https://api.example.com/endpoint2"];
    
    testObject = [[TFFChaosMonkey alloc] initWithRandomNumberProvider:randomNumberProvider];
    [testObject stubURL:url1 returningError:error1];
    [testObject stubURL:url2 returningError:error2];

    [self verifyError:error1 fromURL:url1];
    [self verifyError:error2 fromURL:url2];
    [self verifyError:error1 fromURL:url1];
    [self verifyError:error1 fromURL:url1];
    [self verifyError:error2 fromURL:url2];
}

- (void)verifyError:(NSError *)error fromURL:(NSURL *)url {
	XCTestExpectation *expectation = [self expectationWithDescription:@"request"];
	[[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *networkError) {
		XCTAssertEqual(error.code, networkError.code);
		XCTAssertEqualObjects(error.domain, networkError.domain);
		[expectation fulfill];
	}] resume];

	[self waitForExpectationsWithTimeout:1 handler:^(NSError *expectationError) {
		XCTAssertNil(expectationError);
	}];
}

- (void)verifyNoError:(NSError *)error fromURL:(NSURL *)url {
	XCTestExpectation *expectation = [self expectationWithDescription:@"request"];
	[[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *networkError) {
		XCTAssertNotEqual(error.code, networkError.code);
		XCTAssertNotEqualObjects(error.domain, networkError.domain);
        [expectation fulfill];
	}] resume];

	[self waitForExpectationsWithTimeout:1 handler:^(NSError *expectationError) {
		XCTAssertNil(expectationError);
	}];
}

@end
