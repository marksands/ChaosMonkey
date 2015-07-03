#import "TFFChaosMonkey.h"

@interface TFFURLStubManager : NSObject

@property (nonatomic) NSMutableDictionary *urlForErrorDictionary;
@property (nonatomic) TFFRandomNumberProvider *randomNumberProvider;

- (void)addStubbedURL:(NSURL *)url withError:(NSError *)error;

- (void)resetRandomNumberProvider:(TFFRandomNumberProvider *)provider;
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

- (void)resetRandomNumberProvider:(TFFRandomNumberProvider *)randomNumberProvider {
	self.randomNumberProvider = randomNumberProvider;
    [self.urlForErrorDictionary removeAllObjects];
}

- (void)addStubbedURL:(NSURL *)url withError:(NSError *)error {
	self.urlForErrorDictionary[url.absoluteString] = error;
}

- (BOOL)canInitializeRequest:(NSURL *)url {
	BOOL canInitializeRequest = NO;
	if ([self errorWithURL:url]) {
		canInitializeRequest = self.randomNumberProvider.nextRandom > 0.5;
	}
	return canInitializeRequest;
}

- (NSError *)errorWithURL:(NSURL *)url {
	NSError *error = nil;
	for (NSString *urlString in self.urlForErrorDictionary) {
		if ([self stubbedURLString:urlString matchesURLOrSingleStubbedHost:url]) {
			error = self.urlForErrorDictionary[urlString];
            break;
		}
	}
	return error;
}

- (BOOL)stubbedURLString:(NSString *)urlKey matchesURLOrSingleStubbedHost:(NSURL *)url {
    return [urlKey isEqualToString:url.absoluteString] || [self stubbedURLString:urlKey matchesComponentsForURL:url];;
}

- (BOOL)stubbedURLString:(NSString *)urlString matchesComponentsForURL:(NSURL *)URL {
    NSURLComponents *stubbedURLComponents = [NSURLComponents componentsWithString:urlString];
    NSURLComponents *potentiallyMatchingURLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];

	BOOL matchesScheme = stubbedURLComponents.scheme && potentiallyMatchingURLComponents.scheme ? [stubbedURLComponents.scheme isEqualToString:potentiallyMatchingURLComponents.scheme] : YES;
	BOOL matchesHost = stubbedURLComponents.host && potentiallyMatchingURLComponents.host ? [stubbedURLComponents.host isEqualToString:potentiallyMatchingURLComponents.host] : YES;
	BOOL matchesPort = stubbedURLComponents.port && potentiallyMatchingURLComponents.port ? [stubbedURLComponents.port isEqualToNumber:potentiallyMatchingURLComponents.port] : YES;
	BOOL matchesPath = stubbedURLComponents.path.length && ![stubbedURLComponents.path isEqualToString:@"/"] && potentiallyMatchingURLComponents.path.length ? [stubbedURLComponents.path isEqualToString:potentiallyMatchingURLComponents.path] : YES;
	BOOL matchesQueryString = stubbedURLComponents.query && potentiallyMatchingURLComponents.query ? [stubbedURLComponents.query isEqualToString:potentiallyMatchingURLComponents.query] : YES;

	return matchesScheme && matchesHost && matchesPort && matchesPath && matchesQueryString;
}

@end

#pragma mark -

@interface TFFURLProtocol : NSURLProtocol
@end

@implementation TFFURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
	return [[TFFURLStubManager sharedManager] canInitializeRequest:request.URL];
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

@implementation TFFChaosMonkey

- (void)stubURL:(NSURL *)url returningError:(NSError *)error {
    [[TFFURLStubManager sharedManager] addStubbedURL:url withError:error];
}

- (instancetype)initWithRandomNumberProvider:(TFFRandomNumberProvider *)randomNumberProvider {
	self = [super init];
    [NSURLProtocol unregisterClass:TFFURLProtocol.class];
    [NSURLProtocol registerClass:TFFURLProtocol.class];
    [[TFFURLStubManager sharedManager] resetRandomNumberProvider:randomNumberProvider];
	return self;
}

@end
