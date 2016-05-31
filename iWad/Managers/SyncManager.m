//
//  WebServiceManager.m
//  iWad
//
//  Created by Himal Madhushan on 1/8/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "SyncManager.h"

@implementation SyncManager

@synthesize syncDelegate = _syncDelegate;

- (id)initWithDelegate:(id<SyncManagerDelegate>)delegate {
    _syncDelegate = delegate;
    return self;
}

#pragma mark - User

- (void)loginUser:(NSDictionary *)params parentView:(UIView *)view {
    
    SWPOSTRequest *postReq     = [self initiatePostRequestWithType];
    [self setDefaultHeadersForRequest:postReq];
    [postReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL, userLoginURL] parameters:params parentView:view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"loginUser response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:postReq.tag];
        
    } failure:^(NSURLSessionTask * uploadTask, NSError * error) {
        [self failedResponseWithRespObject:error withTag:postReq.tag];
    }];
}

- (void)changePassword:(NSDictionary *)params parentView:(UIView *)view {
    SWPOSTRequest *postReq     = [self initiatePostRequestWithType];
    [self setAuthorizationHeaderForRequest:postReq];
    [self setDefaultHeadersForRequest:postReq];
    
    [postReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL, changePasswordURL]
                       parameters:params
                       parentView:view
                          success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"changePassword response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:postReq.tag];
        
    } failure:^(NSURLSessionTask * uploadTask, NSError * error) {
        [self failedResponseWithRespObject:error withTag:postReq.tag];
    }];
}

- (void)registerUser:(NSDictionary *)params parentView:(UIView *)view {
    
    SWPOSTRequest *postReq     = [self initiatePostRequestWithType];
    [self setDefaultHeadersForRequest:postReq];
    
    [postReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL, userRegisterURL] parameters:params parentView:view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"registerUser response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:postReq.tag];
        
    } failure:^(NSURLSessionTask * uploadTask, NSError * error) {
        [self failedResponseWithRespObject:error withTag:postReq.tag];
    }];
    
}

- (void)updateUserProfile:(NSDictionary *)params files:(NSArray *)filesArr parentView:(UIView *)view {
    
    SWPUTRequest *putReq     = [[SWPUTRequest alloc] init];
    putReq.responseDataType  = [SWResponseJSONDataType type];
    putReq.tag = 101;
    [self setAuthorizationHeaderForRequest:putReq];
    
    NSString * updateURL = [NSString stringWithFormat:@"%@%@%@",BASE_URL, updateUserURL, [CoreDataManager user].userID];
    
    [putReq startUploadTaskWithURL:updateURL
                              files:filesArr
                         parameters:params
                         parentView:view
                 sendLaterIfOffline:YES
                         cachedData:^(NSCachedURLResponse *response, id responseObject) {
    } success:^(NSURLSessionUploadTask *uploadTask, id responseObject) {
        
        NSLog(@"updateUserProfile response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:putReq.tag];
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        [self failedResponseWithRespObject:error withTag:putReq.tag];
    }];
    
}

- (void)fetchUserDetailsInView:(UIView *)view {
    SWGETRequest * getReq = [self initiateGetRequestWithType];
    getReq.tag = 105;
    [self setAuthorizationHeaderForRequest:getReq];
    
    NSString * userURL = [NSString stringWithFormat:@"%@%@%@",BASE_URL, updateUserURL, [CoreDataManager user].userID];
    
    [getReq startDataTaskWithURL:userURL parameters:nil parentView:view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
//        NSLog(@"fetchUserDetails response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:getReq.tag];
        
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"fetchUserDetails error : %@", error.userInfo);
        [self failedResponseWithRespObject:error withTag:getReq.tag];
    }];
}

- (void)logoutUserInView:(UIView *)view {
    SWPOSTRequest *postReq     = [self initiatePostRequestWithType];
    postReq.tag = 108;
    [self setDefaultHeadersForRequest:postReq];
    [self setAuthorizationHeaderForRequest:postReq];
    
    NSDictionary *params = @{@"device_type":@"IPHONE",
                             @"push_token":[CoreDataManager user].userPushToken};
    
    [postReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL, userLogoutURL] parameters:params parentView:view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        
        NSLog(@"logoutUserInView response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:postReq.tag];
        
    } failure:^(NSURLSessionTask * uploadTask, NSError * error) {
        [self failedResponseWithRespObject:error withTag:postReq.tag];
    }];
}


#pragma mark - Delivery

- (void)createDelivery:(NSDictionary *)params token:(NSString *)paymentToken parentView:(UIView *)view {
    
    SWPOSTRequest *postReq     = [self initiatePostRequestWithType];
    postReq.tag = 200;
    
    [self setDefaultHeadersForRequest:postReq];
    [self setAuthorizationHeaderForRequest:postReq];
    
    [postReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL, createNewDeliveryURL] parameters:params parentView:view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"createDelivery response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:postReq.tag];
    } failure:^(NSURLSessionTask * uploadTask, NSError * error) {
        [self failedResponseWithRespObject:error withTag:postReq.tag];
    }];
    
}

- (void)fetchPromoCodes {
    
    SWGETRequest * getReq = [self initiateGetRequestWithType];
    getReq.tag = 100;
    [self setAuthorizationHeaderForRequest:getReq];
    
    [getReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL, promoCodesURL] parameters:nil parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"fetchPromoCodes response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:getReq.tag];
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"fetchPromoCodes error : %@", error.userInfo);
        [self failedResponseWithRespObject:error withTag:getReq.tag];
    }];
    
}



- (void)fetchAllDeliveriesInView:(UIView *)view {
    
    SWGETRequest * getReq = [self initiateGetRequestWithType];
    [self setAuthorizationHeaderForRequest:getReq];

    [getReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@?page=1&per_page=2000",BASE_URL, allDeliveriesURL] parameters:nil parentView:view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"fetchAllDeliveries response : %@", responseObject);
        [CoreDataManager insertDeliveryFromResponse:responseObject];
        [self successResponseWithRespObject:responseObject withTag:getReq.tag];
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        NSLog(@"fetchAllDeliveries error : %@", error.userInfo);
        [self failedResponseWithRespObject:error withTag:getReq.tag];
    }];
    
}

- (void)updateDeliveryForPushInfo:(NSDictionary *)userInfo {
    NSString *deliveryID = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"delivery_id"]];
    Deliveries * deli = [CoreDataManager deliverForID:deliveryID];
    if (deli) {
        SWGETRequest * getReq = [self initiateGetRequestWithType];
        [self setAuthorizationHeaderForRequest:getReq];
        
        [getReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@/%@",BASE_URL, allDeliveriesURL,deliveryID] parameters:nil parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
            NSLog(@"updateDeliveryForPushInfo response : %@", responseObject);
            [CoreDataManager updateDeliveryForID:deliveryID response:responseObject];
            [self successResponseWithRespObject:responseObject withTag:getReq.tag];
            
        } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
            NSLog(@"fetchAllDeliveries error : %@", error.userInfo);
            [self failedResponseWithRespObject:error withTag:getReq.tag];
        }];
    } else
        NSLog(@"No delivery found for the ID : %@",deliveryID);
}

- (void)fetchDriverLocationOfDeliveryForDriverID:(NSString *)driverID {
    SWGETRequest * getReq = [self initiateGetRequestWithType];
    getReq.tag = 303;
    [self setAuthorizationHeaderForRequest:getReq];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",BASE_URL, driversURL,driverID];
    [getReq startDataTaskWithURL:url parameters:nil parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"fetchDriverLocationOfDeliveryForDriverID response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:getReq.tag];
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        [self failedResponseWithRespObject:error withTag:getReq.tag];
    }];
}

- (void)fetchVehicles {
    SWGETRequest * getReq = [self initiateGetRequestWithType];
    getReq.tag = 101;
    [self setAuthorizationHeaderForRequest:getReq];
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL, vehiclesURL];
    [getReq startDataTaskWithURL:url parameters:nil parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
//        NSLog(@"fetchVehicles response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:getReq.tag];
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        [self failedResponseWithRespObject:error withTag:getReq.tag];
    }];
}

#pragma mark - Drivers

- (void)fetchAllDrivers {
    
    SWGETRequest * getReq = [self initiateGetRequestWithType];
    getReq.tag = 300;
    [self setAuthorizationHeaderForRequest:getReq];
    
    [getReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@",BASE_URL, driversURL] parameters:nil parentView:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"fetchAllDrivers response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:getReq.tag];
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        [self failedResponseWithRespObject:error withTag:getReq.tag];
    }];
    
}

- (void)fetchAvailableDriversInView:(UIView *)view {
    SWGETRequest * getReq = [self initiateGetRequestWithType];
    getReq.tag = 301;
    [self setAuthorizationHeaderForRequest:getReq];
    [getReq.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [getReq.request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
//    NSDictionary *dic = @{@"allDrivers":@"1"};
    [getReq startDataTaskWithURL:[NSString stringWithFormat:@"%@%@?allDrivers=1",BASE_URL, driversURL] parameters:nil parentView:view success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSLog(@"fetchAvailableDriversInView response : %@", responseObject);
        [self successResponseWithRespObject:responseObject withTag:getReq.tag];
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        [self failedResponseWithRespObject:error withTag:getReq.tag];
    }];
}

#pragma mark - Other Methods
/**
 *  Will add Accept header.
 *
 *  @param request request
 */
- (void)setDefaultHeadersForRequest:(SWRequest *)request {
//    [request.request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request.request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
}

/**
 *  Will add Authorization header.
 *
 *  @param swRequest request
 */
- (void)setAuthorizationHeaderForRequest:(SWRequest *)swRequest {
    NSString * token = [CoreDataManager user].userToken;
    [swRequest.request addValue:[NSString stringWithFormat:@"Token token=%@", token] forHTTPHeaderField:@"Authorization"];
}

#pragma mark - Other Methods


- (void)successResponseWithRespObject:(id)responseObject withTag:(int)tag {
    if ([_syncDelegate respondsToSelector:@selector(syncManagerResponseSuccessWithResponse:withTag:)]) {
        [_syncDelegate syncManagerResponseSuccessWithResponse:responseObject withTag:tag];
    }
}


- (void)failedResponseWithRespObject:(NSError *)error withTag:(int)tag {
    if ([_syncDelegate respondsToSelector:@selector(syncManagerResponseFailedWithError:withTag:)]) {
        [_syncDelegate syncManagerResponseFailedWithError:error withTag:tag];
    }
}


- (SWPOSTRequest *)initiatePostRequestWithType {
    SWPOSTRequest *postReq     = [[SWPOSTRequest alloc]init];
    postReq.responseDataType   = [SWResponseJSONDataType type];
    return postReq;
}

- (SWGETRequest *)initiateGetRequestWithType {
    SWGETRequest * getReq = [[SWGETRequest alloc] init];
    getReq.responseDataType = [SWResponseJSONDataType type];
    return getReq;
}

@end
