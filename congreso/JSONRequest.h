//
//  JSONRequest.h
//  Cajeros MX
//
//  Created by Christian Roman on 14/01/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class JSONRequest;

@protocol JSONRequest <NSObject>

- (void)didReceiveJSONResponse:(id)objectResponse;
- (void)didNotReceiveJSONResponse:(NSError *)error;

@end

@interface JSONRequest : NSObject
{
    id<JSONRequest> delegate;
}

@property(strong, nonatomic) id<JSONRequest> delegate;

- (void)getAllMembers;
- (void)getAllMembersWithType:(int)type;
- (void)getAllMembersWithParty:(NSString *)party;
- (void)getNearbyMembers:(float)latitude longitude:(float)longitude;

- (void)getAllCommissions;
- (void)getCommissionMembers:(int)commissionID;

@end
