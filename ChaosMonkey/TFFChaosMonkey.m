#import "TFFChaosMonkey.h"

@interface TFFURLStubManager : NSObject

@property (nonatomic) NSMutableDictionary *urlForErrorDictionary;

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

- (instancetype)init {
	self = [super init];
	_urlForErrorDictionary = [NSMutableDictionary dictionary];
	return self;
}

- (void)reset {
    [self.urlForErrorDictionary removeAllObjects];
}

- (void)addStubbedURL:(NSURL *)url withError:(NSError *)error {
	self.urlForErrorDictionary[url.absoluteString] = error;
}

- (NSString *)existingURLStringWithURL:(NSURL *)url {
	NSString *absoluteURL = nil;
	for (NSString *urlKey in self.urlForErrorDictionary) {
		if ([urlKey isEqualToString:url.absoluteString]) {
			absoluteURL = urlKey;
		}
	}
	return absoluteURL;
}

- (NSError *)errorWithURL:(NSURL *)url {
	NSError *error = nil;
	for (NSString *urlKey in self.urlForErrorDictionary) {
		if ([urlKey isEqualToString:url.absoluteString]) {
			error = self.urlForErrorDictionary[urlKey];
		}
	}
	return error;
}

@end

#pragma mark -

@interface TFFURLProtocol : NSURLProtocol <NSURLConnectionDelegate>
@end

@implementation TFFURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
	return [[TFFURLStubManager sharedManager] existingURLStringWithURL:request.URL] != nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
	return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)requestOne toRequest:(NSURLRequest *)requestTwo {
	return NO;
}

- (void)startLoading {
	NSError *error = [[TFFURLStubManager sharedManager] errorWithURL:self.request.URL];
	[self.client URLProtocol:self didFailWithError:error];
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
    [[TFFURLStubManager sharedManager] addStubbedURL:url withError:error];
}

- (instancetype)initWithRandomNumberProvider:(TFFRandomNumberProvider *)randomNumberProvider {
	self = [super init];
    [NSURLProtocol registerClass:TFFURLProtocol.class];
    [[TFFURLStubManager sharedManager] reset];
	_randomNumberProvider = randomNumberProvider;
	return self;
}

@end
