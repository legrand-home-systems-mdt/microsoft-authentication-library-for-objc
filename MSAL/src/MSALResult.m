//------------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "MSALResult.h"
#import "MSALAccessTokenCacheItem.h"
#import "MSIDAccessToken.h"
#import "NSString+MSIDExtensions.h"
#import "NSURL+MSIDExtensions.h"
#import "MSIDClientInfo.h"
#import "MSALIdToken.h"

@implementation MSALResult

@end

@implementation MSALResult (Internal)

+ (MSALResult *)resultWithAccessToken:(NSString *)accessToken
                            expiresOn:(NSDate *)expiresOn
                             tenantId:(NSString *)tenantId
                                 user:(MSALUser *)user
                              idToken:(NSString *)idToken
                             uniqueId:(NSString *)uniqueId
                               scopes:(NSArray<NSString *> *)scopes
{
    MSALResult *result = [MSALResult new];
    
    result->_accessToken = accessToken;
    result->_expiresOn = expiresOn;
    result->_tenantId = tenantId;
    result->_user = user;
    result->_idToken = idToken;
    result->_uniqueId = uniqueId;
    result->_scopes = scopes;
    
    return result;
}

+ (MSALResult *)resultWithAccessToken:(MSIDAccessToken *)accessToken
{
    MSIDClientInfo *clientInfo = [[MSIDClientInfo alloc] initWithRawClientInfo:accessToken.clientInfo.rawClientInfo error:nil];
    MSALIdToken *idToken = [[MSALIdToken alloc] initWithRawIdToken:accessToken.idToken];
    
    MSALUser *user = [[MSALUser alloc] initWithIdToken:idToken
                                            clientInfo:clientInfo environment:accessToken.authority.msidHostWithPortIfNecessary];
    return [self resultWithAccessToken:accessToken.accessToken
                             expiresOn:accessToken.expiresOn
                              tenantId:accessToken.authority.msidTenant
                                  user:user
                               idToken:accessToken.idToken
                              uniqueId:accessToken.uniqueUserId
                                scopes:[accessToken.scopes array]];
}

@end
