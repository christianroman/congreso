//
//  CongresoAPIClient.m
//  congreso
//
//  Created by Christian Roman on 18/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "CongresoAPIClient.h"
#import "AFJSONRequestOperation.h"

@implementation CongresoAPIClient

+ (CongresoAPIClient *)sharedClient {
    static CongresoAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CongresoAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
