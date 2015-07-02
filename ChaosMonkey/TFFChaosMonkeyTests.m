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
	NSError *error = [NSError errorWithDomain:@"domain" code:3 userInfo:nil];
	NSURL *url = [NSURL URLWithString:@"https://api.example.com/endpoint?withQueryString=1"];
	[self stubURL:url returningError:error randomNumbers:@[@1]];

	[self verifyError:error	fromURL:url];
	NSURL *urlWithDifferingEndpoint = [NSURL URLWithString:@"https://api.example.com/endpoint2?withQueryString=2"];
	[self verifyNoError:error fromURL:urlWithDifferingEndpoint];
}

- (void)testWhenStubbingErrorResponseForMultipleURLsAndRequestIsMadeForAllURLsAndRandomNumberProviderReturnsTrueThenStubbedErrorResponsesAreReturned {
	NSError *error1 = [NSError errorWithDomain:@"domain1" code:333 userInfo:nil];
	NSError *error2 = [NSError errorWithDomain:@"domain2" code:444 userInfo:nil];
	NSURL *url1 = [NSURL URLWithString:@"https://api.example.com/endpoint1"];
	NSURL *url2 = [NSURL URLWithString:@"https://api.example.com/endpoint2"];
	testObject = [self stubURL:url1 returningError:error1 randomNumbers:@[@1, @1]];
	[testObject stubURL:url2 returningError:error2];

    [self verifyError:error1 fromURL:url1];
    [self verifyError:error2 fromURL:url2];
    [self verifyError:error1 fromURL:url1];
    [self verifyError:error1 fromURL:url1];
    [self verifyError:error2 fromURL:url2];
}

- (void)testWhenStubbingErrorResponseForURLAndRequestIsMadeForURLAndRandomNumberProviderReturnsFalseThenResponseNotStubbed {
	NSError *error = [NSError errorWithDomain:@"domain111" code:111 userInfo:nil];
	NSURL *url = [NSURL URLWithString:@"https://api.example.com/endpoint/3"];
	[self stubURL:url returningError:error randomNumbers:@[@0]];

	[self verifyNoError:error fromURL:url];
}

- (void)testWhenStubbingErrorResponseForURLAndRequestIsMadeForURLAndRandomNumberProviderReturnsVariedResultsThenResponseIsStubbedAsExpected {
	NSError *error = [NSError errorWithDomain:@"domain111" code:111 userInfo:nil];
	NSURL *url = [NSURL URLWithString:@"https://api.example.com/endpoint/3"];
	[self stubURL:url returningError:error randomNumbers:@[@0, @1, @0, @1, @1]];

	[self verifyNoError:error fromURL:url];
	[self verifyError:error fromURL:url];
	[self verifyNoError:error fromURL:url];
	[self verifyError:error fromURL:url];
	[self verifyError:error fromURL:url];
}

- (TFFChaosMonkey *)stubURL:(NSURL *)url returningError:(NSError *)error randomNumbers:(NSArray *)randomNumbers {
	randomNumberProvider = [[TFFMockRandomNumberProvider alloc] initWithGeneratedRandomNumbers:randomNumbers];
	testObject = [[TFFChaosMonkey alloc] initWithRandomNumberProvider:randomNumberProvider];
	[testObject stubURL:url returningError:error];
	return testObject;
}

- (void)verifyError:(NSError *)error fromURL:(NSURL *)url {
	XCTestExpectation *expectation = [self expectationWithDescription:@"Stubbed Response"];
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
	XCTestExpectation *expectation = [self expectationWithDescription:@"Response Not Stubbed"];
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
