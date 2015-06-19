#import <XCTest/XCTest.h>
#import "TFFFailingURLRunner.h"

@interface TFFFailingURLRunnerTests: XCTestCase
@end

@implementation TFFFailingURLRunnerTests

- (void)testWhenMappingURLThatAlwaysInjectsErrorThenRespondsToRequestIsAlways {
    NSURL *url = [NSURL URLWithString:@"https://random.com/Always"];
    NSError *error = [NSError errorWithDomain:@"Domain" code:1 userInfo:nil];
    
    [[TFFFailingURLRunner sharedInstance] mapURL:url withError:error priority:TFFChaosInjectorFailingPriorityAlways];
    
    int responses = 0;
    for (int i = 0; i < 100; ++i) {
        if ([[TFFFailingURLRunner sharedInstance] respondToRequestRespectingPriority:[NSURLRequest requestWithURL:url]]) {
            responses++;
        }
    }
    
    XCTAssertEqual(responses, 100);
}

- (void)testWhenMappingURLWithHighPriorityThenRespondsToRequestIsTrueMostOfTheTime {
    NSURL *url = [NSURL URLWithString:@"https://random.com/High"];
    NSError *error = [NSError errorWithDomain:@"Domain" code:1 userInfo:nil];
    
    [[TFFFailingURLRunner sharedInstance] mapURL:url withError:error priority:TFFChaosInjectorFailingPriorityHigh];
    
    int responses = 0;
    for (int i = 0; i < 100; ++i) {
        if ([[TFFFailingURLRunner sharedInstance] respondToRequestRespectingPriority:[NSURLRequest requestWithURL:url]]) {
            responses++;
        }
    }
    
    XCTAssertTrue(responses > 25);
}

- (void)testWhenMappingURLWithBogusPriorityThenExceptionIsThrown {
	NSURL *url = [NSURL URLWithString:@"https://random.com/Bogus"];
	NSError *error = [NSError errorWithDomain:@"Domain" code:1 userInfo:nil];

	[[TFFFailingURLRunner sharedInstance] mapURL:url withError:error priority:(TFFChaosInjectorFailingPriority)999999];

	XCTAssertThrows([[TFFFailingURLRunner sharedInstance] respondToRequestRespectingPriority:[NSURLRequest requestWithURL:url]]);
}

@end
