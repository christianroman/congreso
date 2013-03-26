//
//  CongresoAPIClient.h
//  congreso
//
//  Created by Christian Roman on 18/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "AFHTTPClient.h"

@interface CongresoAPIClient : AFHTTPClient

+ (CongresoAPIClient *)sharedClient;

@end
