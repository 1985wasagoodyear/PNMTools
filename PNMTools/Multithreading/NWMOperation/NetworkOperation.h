//
//  NetworkOperation.h
//  NSObjectathingy
//
//  Created by K Y on 9/12/19.
//  Copyright © 2019 K Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWMOperation.h"
#import <objc/nsobjcruntime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkOperation : NWMOperation

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

/// Method with body
- (instancetype)init:(NSURLSession *)session
                 url:(NSURL *)url
              method:(NSString *)method
                body:(NSData *)body
          completion:(void (^)(NSData *, NSURLResponse *, NSError *))completion;

/// Method without Body
- (instancetype)init:(NSURLSession *)session
                 url:(NSURL *)url
              method:(NSString *)method
          completion:(void (^)(NSData *, NSURLResponse *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END

