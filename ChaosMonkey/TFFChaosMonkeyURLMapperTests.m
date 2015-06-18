#import <XCTest/XCTest.h>
#import "TFFChaosMonkeyURLMapper.h"
#import "TFFStreakBreaker.h"

@interface TFFChaosMonkeyURLMapperTests : XCTestCase

@end

@implementation TFFChaosMonkeyURLMapperTests

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
    
    XCTAssertEqualWithAccuracy(responses, 75, EPSILON);
}

- (void)testWhenMappingURLWithMediumPriorityThenRespondsToRequestIsTrueSomeOfTheTime {
    NSURL *url = [NSURL URLWithString:@"https://random.com/Medium"];
    NSError *error = [NSError errorWithDomain:@"Domain" code:1 userInfo:nil];
    
    [[TFFChaosMonkeyURLMapper sharedInstance] mapURL:url withError:error priority:TFFChaosMonkeyPriorityMedium];
    
    int responses = 0;
    for (int i = 0; i < 100; ++i) {
        if ([[TFFChaosMonkeyURLMapper sharedInstance] respondToRequestRespectingPriority:[NSURLRequest requestWithURL:url]]) {
            responses++;
        }
    }
    
    XCTAssertEqualWithAccuracy(responses, 50, EPSILON);
}

- (void)testWhenMappingURLWithLowPriorityThenRespondsToRequestIsTrueSeldomly {
    NSURL *url = [NSURL URLWithString:@"https://random.com/Low"];
    NSError *error = [NSError errorWithDomain:@"Domain" code:1 userInfo:nil];
    
    [[TFFChaosMonkeyURLMapper sharedInstance] mapURL:url withError:error priority:TFFChaosMonkeyPriorityLow];
    
    int responses = 0;
    for (int i = 0; i < 100; ++i) {
        if ([[TFFChaosMonkeyURLMapper sharedInstance] respondToRequestRespectingPriority:[NSURLRequest requestWithURL:url]]) {
            responses++;
        }
    }
    
    XCTAssertEqualWithAccuracy(responses, 25, EPSILON);
}

@end
