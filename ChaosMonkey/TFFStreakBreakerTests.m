#import <XCTest/XCTest.h>
#import "TFFStreakBreaker.h"

@interface TFFStreakBreakerTests : XCTestCase {
    NSURL *url;
    NSError *error;
    int positiveCounts;
}
@end

@implementation TFFStreakBreakerTests

- (void)setUp {
    [super setUp];
    url = [NSURL URLWithString:@"https://randomBool.com/always"];
    error = [NSError errorWithDomain:@"Domain" code:1 userInfo:nil];
    positiveCounts = 0;
}

- (void)testWhenRequestingRandomBoolForMappingWithAlwaysPriorityThenBoolAlwaysReturnsYes {
    TFFURLResponseMap *responseMap = [[TFFURLResponseMap alloc] initWithURL:url error:error priority:TFFChaosMonkeyPriorityAlways];
    TFFStreakBreaker *testObject = [[TFFStreakBreaker alloc] initWithMapping:responseMap];
    
    for (int i = 0; i < 100; ++i) {
        if ([testObject nextRandomBool]) {
            ++positiveCounts;
        }
    }
    
    XCTAssertEqual(positiveCounts, 100);
}

- (void)testWhenRequestingRandomBoolForMappingWithHighPriorityThenBoolReturnsYesThreeQuartersOfTheTime {
    TFFURLResponseMap *responseMap = [[TFFURLResponseMap alloc] initWithURL:url error:error priority:TFFChaosMonkeyPriorityHigh];
    TFFStreakBreaker *testObject = [[TFFStreakBreaker alloc] initWithMapping:responseMap];
    
    for (int i = 0; i < 100; ++i) {
        if ([testObject nextRandomBool]) {
            ++positiveCounts;
        }
    }
    
    XCTAssertEqualWithAccuracy(positiveCounts, 75, EPSILON);
}

- (void)testWhenRequestingRandomBoolForMappingWithHighPriorityThenBoolReturnsYesOneHalfOfTheTime {
    TFFURLResponseMap *responseMap = [[TFFURLResponseMap alloc] initWithURL:url error:error priority:TFFChaosMonkeyPriorityMedium];
    TFFStreakBreaker *testObject = [[TFFStreakBreaker alloc] initWithMapping:responseMap];
    
    for (int i = 0; i < 100; ++i) {
        if ([testObject nextRandomBool]) {
            ++positiveCounts;
        }
    }
    
    XCTAssertEqualWithAccuracy(positiveCounts, 50, EPSILON);
}

- (void)testWhenRequestingRandomBoolForMappingWithHighPriorityThenBoolReturnsYesOneQuarterOfTheTime {
    TFFURLResponseMap *responseMap = [[TFFURLResponseMap alloc] initWithURL:url error:error priority:TFFChaosMonkeyPriorityLow];
    TFFStreakBreaker *testObject = [[TFFStreakBreaker alloc] initWithMapping:responseMap];
    
    for (int i = 0; i < 100; ++i) {
        if ([testObject nextRandomBool]) {
            ++positiveCounts;
        }
    }
    
    XCTAssertEqualWithAccuracy(positiveCounts, 25, EPSILON);
}

@end
