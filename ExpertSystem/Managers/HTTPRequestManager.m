//
// Created by Aleksandr Dakhno on 28/08/14.
// Copyright (c) 2014 DAV. All rights reserved.
//

#import "HTTPRequestManager.h"
@interface HTTPRequestManager () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSURLConnection *urlConnection;
@property (copy, nonatomic) void(^completion)(id receivedData, NSError *error);
@end

@implementation HTTPRequestManager

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - public API
- (void)makeRequestForURL:(NSURL *)url completion:(void(^)(id receivedData, NSError *error))completion {
    self.completion = completion;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.completion) self.completion(self.data, nil);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.completion) self.completion(nil, error);
}

@end