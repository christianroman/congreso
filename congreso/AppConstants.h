//
//  AppConstants.h
//  congreso
//
//  Created by Christian Roman on 18/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define kBaseURL @"http://192.168.1.68:3000/api/v1"
#else
    #define kBaseURL @"http://secret-depths-9188.herokuapp.com/"
#endif

@interface AppConstants : NSObject

@end
