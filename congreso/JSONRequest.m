//
//  JSONRequest.m
//  Cajeros MX
//
//  Created by Christian Roman on 14/01/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "JSONRequest.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "CongresoAPIClient.h"

#import "Member.h"
#import "State.h"
#import "Commission.h"

@implementation JSONRequest
@synthesize delegate;

- (void)getAllMembers
{
    NSString *URLString = [NSString stringWithFormat:@"%@/members", kBaseURL];
    
    __block NSMutableArray *members;
    
    NSURL *url = [[NSURL alloc] initWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        members = [JSONRequest parseMembersFromDict:JSON];
        
        [delegate performSelector:@selector(didReceiveJSONResponse:) withObject:members];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [delegate performSelector:@selector(didNotReceiveJSONResponse:) withObject:error];
        
    }];
    
    [operation start];
}

- (void)getAllMembersWithType:(int)type
{
    NSString *URLString = [NSString stringWithFormat:type == 1 ? @"%@/members/diputados" : @"%@/members/senadores", kBaseURL];
    
    __block NSMutableArray *members;
    
    NSURL *url = [[NSURL alloc] initWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        members = [JSONRequest parseMembersFromDict:JSON];
        
        [delegate performSelector:@selector(didReceiveJSONResponse:) withObject:members];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [delegate performSelector:@selector(didNotReceiveJSONResponse:) withObject:error];
        
    }];
    
    [operation start];
}

- (void)getAllMembersWithParty:(NSString *)party
{
    NSString *URLString = [NSString stringWithFormat:@"%@/members?party=%@", kBaseURL, party];
    
    __block NSMutableArray *members;
    
    NSURL *url = [[NSURL alloc] initWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        members = [JSONRequest parseMembersFromDict:JSON];
        
        [delegate performSelector:@selector(didReceiveJSONResponse:) withObject:members];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [delegate performSelector:@selector(didNotReceiveJSONResponse:) withObject:error];
        
    }];
    
    [operation start];
}

- (void)getNearbyMembers:(float)latitude longitude:(float)longitude
{
    NSString *URLString = [NSString stringWithFormat:@"%@/members/nearby?latitude=%f&longitude=%f", kBaseURL, latitude, longitude];
    
    __block NSMutableArray *members;
    
    NSURL *url = [[NSURL alloc] initWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        members = [JSONRequest parseMembersFromDict:JSON];
        
        [delegate performSelector:@selector(didReceiveJSONResponse:) withObject:members];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [delegate performSelector:@selector(didNotReceiveJSONResponse:) withObject:error];
        
    }];
    
    [operation start];
}

- (void)getAllCommissions
{
    NSString *URLString = [NSString stringWithFormat:@"%@/commissions", kBaseURL];
    
    __block NSMutableArray *commissions;
    
    NSURL *url = [[NSURL alloc] initWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                
        commissions = [[NSMutableArray alloc] init];
        
        NSString *status = [JSON objectForKey:@"status"];
        
        if([status isEqualToString:@"OK"]){
            
            NSArray *commissionsDict = [JSON objectForKey:@"commissions"];
            
            for(NSDictionary *item in commissionsDict){
                
                Commission *commission = [Commission new];
                commission.ID = [[item objectForKey:@"id"] intValue];
                commission.name = [item objectForKey:@"name"];
                [commissions addObject:commission];
                
            }
        }
        
        [delegate performSelector:@selector(didReceiveJSONResponse:) withObject:commissions];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [delegate performSelector:@selector(didNotReceiveJSONResponse:) withObject:error];
        
    }];
    
    [operation start];
}

- (void)getCommissionMembers:(int)commissionID
{
    NSString *URLString = [NSString stringWithFormat:@"%@/commissions/%d", kBaseURL, commissionID];
    
    __block NSMutableArray *members;
    
    NSURL *url = [[NSURL alloc] initWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        members = [[NSMutableArray alloc] init];
            
        NSArray *membersDict = [JSON objectForKey:@"members"];
        
        for(NSDictionary *item in membersDict){
            
            Member *member = [Member new];
            member.ID = [[item objectForKey:@"id"] intValue];
            member.name = [item objectForKey:@"name"];
            
            NSString *district = [item objectForKey:@"district"];
            member.district = [district isKindOfClass:[NSNull class]] ? nil : district;
            
            NSString *header = [item objectForKey:@"header"];
            member.header = [header isKindOfClass:[NSNull class]] ? nil : header;
            
            NSDictionary *stateDict = [item objectForKey:@"state"];
            State *state = [State new];
            state.ID = [[stateDict objectForKey:@"id"] intValue];
            state.name = [stateDict objectForKey:@"name"];
            state.division = [[stateDict objectForKey:@"division"] intValue];
            
            member.state = state;
            member.party = [item objectForKey:@"party"];
            member.email = [item objectForKey:@"email"];
            member.substitute = [item objectForKey:@"substitute"];
            member.image = [item objectForKey:@"image"];
            
            //NSArray *arrayPhones = [[NSArray alloc] init];
            //for ()
            //member.phones
            
            member.curul = [item objectForKey:@"curul"];
            member.kind = [[item objectForKey:@"kind"] intValue];
            
            NSString *id_alt = [item objectForKey:@"id_alt"];
            member.id_alt = [id_alt isKindOfClass:[NSNull class]] ? 0 : [id_alt intValue];
            
            [members addObject:member];
        }
        
        
        [delegate performSelector:@selector(didReceiveJSONResponse:) withObject:members];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        [delegate performSelector:@selector(didNotReceiveJSONResponse:) withObject:error];
        
    }];
    
    [operation start];
}

/*======================== Parse JSON ==========================*/

+ (NSMutableArray *)parseMembersFromDict:(NSDictionary *)dictionary
{
    NSMutableArray *members = [[NSMutableArray alloc] init];
    
    NSString *status = [dictionary objectForKey:@"status"];
    
    if([status isEqualToString:@"OK"]){
        
        NSArray *membersDict = [dictionary objectForKey:@"members"];
        
        for(NSDictionary *item in membersDict){
            
            Member *member = [Member new];
            member.ID = [[item objectForKey:@"id"] intValue];
            member.name = [item objectForKey:@"name"];
            
            NSString *district = [item objectForKey:@"district"];
            member.district = [district isKindOfClass:[NSNull class]] ? nil : district;
            
            NSString *header = [item objectForKey:@"header"];
            member.header = [header isKindOfClass:[NSNull class]] ? nil : header;
            
            NSDictionary *stateDict = [item objectForKey:@"state"];
            State *state = [State new];
            state.ID = [[stateDict objectForKey:@"id"] intValue];
            state.name = [stateDict objectForKey:@"name"];
            state.division = [[stateDict objectForKey:@"division"] intValue];
            
            member.state = state;
            member.party = [item objectForKey:@"party"];
            member.email = [item objectForKey:@"email"];
            member.substitute = [item objectForKey:@"substitute"];
            member.image = [item objectForKey:@"image"];
            
            //NSArray *arrayPhones = [[NSArray alloc] init];
            //for ()
            //member.phones
            
            member.curul = [item objectForKey:@"curul"];
            member.kind = [[item objectForKey:@"kind"] intValue];
            
            NSString *id_alt = [item objectForKey:@"id_alt"];
            member.id_alt = [id_alt isKindOfClass:[NSNull class]] ? 0 : [id_alt intValue];
            
            NSDictionary *commissionsDict = [item objectForKey:@"commissions"];
            
            NSMutableArray *commissions = [[NSMutableArray alloc] initWithCapacity:commissionsDict.count];
            
            for (NSDictionary *commissionDict in commissionsDict){
                Commission *commission = [Commission new];
                commission.ID = [[commissionDict objectForKey:@"id"] intValue];
                commission.name = [commissionDict objectForKey:@"name"];
                [commissions addObject:commission];
            }
            member.commissions = commissions;
            
            [members addObject:member];
        }
        
    }
    return members;
}
 
@end
