//
//  NetworkOperation.m
//  NSObjectathingy
//
//  Created by K Y on 9/12/19.
//  Copyright © 2019 K Y. All rights reserved.
//
// https://williamboles.me/networking-with-nsoperation-as-your-wingman/
// fun guide.

#import "NetworkOperation.h"

const NSTimeInterval TIMEOUT_ALLOCATION = 180.0;

@interface NetworkOperation () {
    NSURLSession *_session;
    NSMutableURLRequest *_url;
    NSString *_method;
    NSData *_body;
    void (^_completion)(NSData *, NSURLResponse *, NSError *);
    NSURLSessionDataTask *_task;
}

@end

@implementation NetworkOperation

- (instancetype)init {
    NSException* myException = [NSException
                                exceptionWithName:@"Do not call init: on this object. "
                                reason:@"Use init:url:method:body:completion:, instead."
                                userInfo:nil];
    @throw myException;
}

- (instancetype)init:(NSURLSession *)session
                 url:(NSURL *)url
              method:(NSString *)method
          completion:(void (^)(NSData *, NSURLResponse *, NSError *))completion {
    self = [super init];
    if (self) {
        _session = session;
        _url = [NSMutableURLRequest requestWithURL:url
                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                   timeoutInterval:TIMEOUT_ALLOCATION];
        _method = method;
        _completion = completion;
    }
    return self;
}

- (instancetype)init:(NSURLSession *)session
                 url:(NSURL *)url
              method:(NSString *)method
                body:(NSData *)body
          completion:(void (^)(NSData *, NSURLResponse *, NSError *))completion {
    self = [self init:session url:url method:method completion:completion];
    if (self) {
        _body = body;
    }
    return self;
}

- (id)copy {
    return [[NetworkOperation alloc] init:_session
                                      url:[_url URL]
                                   method:_method
                               completion:_completion];
}

#pragma mark - Control

- (void)start {
    [super start];
    // if we cancel this before, don't start perform tasks
    if ([self isCancelled]) {
        [self finish];
        return;
    }
    [_url setHTTPBody: _body];
    [_url setHTTPMethod:_method];
    
    __weak typeof(self) weakSelf = self;
    void (^comp)(NSData *data, NSURLResponse *response, NSError *error) = ^void(NSData *data, NSURLResponse *response, NSError *error) {
        // more work here
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_completion(data, response, error);
        [strongSelf finish];
    };
    _task = [_session dataTaskWithRequest:_url completionHandler:comp];
    [_task resume];
}

- (void)cancel {
    [super cancel];
    [_task cancel];
    [self finish];
}

@end
