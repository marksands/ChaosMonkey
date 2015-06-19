#import <XCTest/XCTest.h>
#import "TFFFixedEffectRandomizer.h"

@interface TFFFixedEffectRandomizerTests: XCTestCase {
    int positiveCounts;
	TFFFixedEffectRandomizer *testObject;
}
@end

@implementation TFFFixedEffectRandomizerTests

- (void)setUp {
    [super setUp];
    positiveCounts = 0;
	testObject = [[TFFFixedEffectRandomizer alloc] init];
}

- (void)testWhenRequestingRandomBoolForMappingWithAlwaysPriorityThenBoolAlwaysReturnsYes {
    for (int i = 0; i < 100; ++i) {
        if ([testObject nextRandomBoolWithFixedPercentage:1.0]) {
            ++positiveCounts;
        }
    }
    
    XCTAssertEqual(positiveCounts, 100);
}

- (void)testWhenRequestingRandomBoolForMappingWithHighPriorityThenBoolReturnsYesThreeQuartersOfTheTime {
    for (int i = 0; i < 100; ++i) {
        if ([testObject nextRandomBoolWithFixedPercentage:0.63]) {
            ++positiveCounts;
        }
    }
    
    XCTAssertEqual(positiveCounts, 63);
}

@end
