#import "TFFChaosMonkey.h"

@interface TFFURLStubManager : NSObject

@property (nonatomic) NSURL *stubbedURL;
@property (nonatomic) NSError *stubbedError;

@end

@implementation TFFURLStubManager

+ (TFFURLStubManager *)sharedManager {
    static dispatch_once_t once;
    static TFFURLStubManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[TFFURLStubManager alloc] init];
    });
    return sharedInstance;
}

@end

#pragma mark -

@interface TFFURLProtocol : NSURLProtocol <NSURLConnectionDelegate>
@end

@implementation TFFURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
	return [[TFFURLStubManager sharedManager].stubbedURL isEqual:request.URL];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
	return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)requestOne toRequest:(NSURLRequest *)requestTwo {
	return NO;
}

- (void)startLoading {
    [self.client URLProtocol:self didFailWithError:[TFFURLStubManager sharedManager].stubbedError];
}

- (void)stopLoading {
}

@end

#pragma mark -

@interface TFFChaosMonkey() <NSURLConnectionDelegate>
@property (nonatomic, readonly) TFFRandomNumberProvider *randomNumberProvider;
@end

@implementation TFFChaosMonkey

- (void)stubURL:(NSURL *)url returningError:(NSError *)error {
	[TFFURLStubManager sharedManager].stubbedURL = url;
	[TFFURLStubManager sharedManager].stubbedError = error;
}

- (instancetype)initWithRandomNumberProvider:(TFFRandomNumberProvider *)randomNumberProvider {
	self = [super init];
    [NSURLProtocol registerClass:TFFURLProtocol.class];
	_randomNumberProvider = randomNumberProvider;
	return self;
}

@end
