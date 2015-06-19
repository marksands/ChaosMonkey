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

- (void)testWhenRequestingRandomBoolWithFixedPercentageThenBoolAlwaysReturnsYes {
    for (int i = 0; i < 100; ++i) {
        if ([testObject nextRandomBoolWithFixedPercentage:1.0]) {
            ++positiveCounts;
        }
    }
    
    XCTAssertEqual(positiveCounts, 100);
}

- (void)testWhenRequestingRandomBoolWithFixedPercentageThenBoolSometimesReturnsYes {
    for (int i = 0; i < 100; ++i) {
        if ([testObject nextRandomBoolWithFixedPercentage:0.63]) {
            ++positiveCounts;
        }
    }
    
    XCTAssertEqual(positiveCounts, 63);
}

- (void)testWhenRequestingRandomBoolWithFixedPercentageThenConsecutiveStreaksOccur {
	int longestStreak = 0;
	int currentStreak = 0;

	for (int i = 0; i < 250; ++i) {
		if ([testObject nextRandomBoolWithFixedPercentage:0.70]) {
			++positiveCounts;
			currentStreak++;
		} else {
			longestStreak = MAX(longestStreak, currentStreak);
			currentStreak = 0;
		}
	}

	XCTAssertEqual(positiveCounts, 175);
	XCTAssertEqual(longestStreak, 3);
}

@end
