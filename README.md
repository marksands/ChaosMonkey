# ChaosMonkey
Stub a URL with a corresponding NSError and watch your requests randomly fail.

# Demo

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	TFFRandomNumberProvider *randomNumberProvider = [[TFFRandomNumberProvider alloc] init];
	self.chaosMonkey = [[TFFChaosMonkey alloc] initWithRandomNumberProvider:randomNumberProvider];
	
	NSError *paymentError = [NSError errorWithDomain:@"PaymentError" code:500 userInfo:nil];
	NSURL *paymentAPI = [NSURL urlWithString:@"https://api.payment.com/charge/my/creditCard"];
	[self.chaosMonkey stubURL:paymentAPI returningError:paymentError]; // POSTS to creditCard charges will randomly fail
	
	NSError *catchAllError = [NSError errorWithDomain:@"GenericError" code:500 userInfo:nil];
        NSURL *baseAPI = [NSURL urlWithString:@"https://api.example.com:1234"];
        [self.chaosMonkey stubURL:baseAPI returningError:catchAllError]; // all requests to baseAPI will randomly fail

	return YES;
}
```
