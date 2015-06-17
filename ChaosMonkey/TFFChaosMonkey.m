#import "TFFChaosMonkey.h"

@interface TFFChaosMonkeyURLMapper : NSObject

@property (nonatomic, readonly) NSMutableArray *URLs;

@end

@implementation TFFChaosMonkeyURLMapper

+ (instancetype)sharedInstance {
	static TFFChaosMonkeyURLMapper *sharedInstance = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[TFFChaosMonkeyURLMapper alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init {
	self = [super init];
	_URLs = [NSMutableArray array];
	return self;
}

- (void)mapURL:(NSURL *)url {
	[self.URLs addObject:url];
}

- (BOOL)canInitializeRequest:(NSURLRequest *)request {
	for (NSURL *url in self.URLs) {
		if ([request.URL isEqual:url]) {
			return YES;
		}
	}
	return NO;
}

@end

#pragma mark -

@implementation TFFChaosMonkey

+ (void)injectURL:(NSURL *)url returningError:(NSError *)error priority:(TFFChaosMonkeyPriority)priority {
	[NSURLProtocol registerClass:self];

	return [[TFFChaosMonkeyURLMapper sharedInstance] mapURL:url];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
	return [[TFFChaosMonkeyURLMapper sharedInstance] canInitializeRequest:request];
}

@end
