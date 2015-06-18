#import <XCTest/XCTest.h>
#import "TFFChaosMonkeyURLMapper.h"
#import "TFFStreakBreaker.h"

@interface TFFChaosMonkeyURLMapperTests : XCTestCase

@end

@implementation TFFChaosMonkeyURLMapperTests

- (void)testWhenMappingURLThatAlwaysInjectsErrorThenRespondsToRequestIsAlways {
    NSURL *url = [NSURL URLWithString:@"https://random.com/Always"];
    NSError *error = [NSError errorWithDomain:@"Domain" code:1 userInfo:nil];
    
    [[TFFChaosMonkeyURLMapper sharedInstance] mapURL:url withError:error priority:TFFChaosMonkeyPriorityAlways];
    
    int responses = 0;
    for (int i = 0; i < 100; ++i) {
        if ([[TFFChaosMonkeyURLMapper sharedInstance] respondToRequestRespectingPriority:[NSURLRequest requestWithURL:url]]) {
            responses++;
        }
    }
    
    XCTAssertEqual(responses, 100);
}

- (void)testWhenMappingURLWithHighPriorityThenRespondsToRequestIsTrueMostOfTheTime {
    NSURL *url = [NSURL URLWithString:@"https://random.com/High"];
    NSError *error = [NSError errorWithDomain:@"Domain" code:1 userInfo:nil];
    
    [[TFFChaosMonkeyURLMapper sharedInstance] mapURL:url withError:error priority:TFFChaosMonkeyPriorityHigh];
    
    int responses = 0;
    for (int i = 0; i < 100; ++i) {
        if ([[TFFChaosMonkeyURLMapper sharedInstance] respondToRequestRespectingPriority:[NSURLRequest requestWithURL:url]]) {
            responses++;
        }
    }
    
    XCTAssertTrue(responses > 25);
}

@end
