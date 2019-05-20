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

#import "MSALOauth2Provider.h"
#import "MSIDOauth2Factory.h"
#import "MSIDTokenResult.h"
#import "MSALOauth2Provider+Internal.h"
#import "MSALAuthorityFactory.h"
#import "MSALResult+Internal.h"
#import "MSIDAuthority.h"

@implementation MSALOauth2Provider

#pragma mark - Public

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initDerivedProperties];
    }
    
    return self;
}

- (MSALResult *)resultWithTokenResult:(MSIDTokenResult *)tokenResult
                                error:(NSError **)error
{
    NSError *authorityError = nil;
    
    MSALAuthority *authority = [MSALAuthorityFactory authorityFromUrl:tokenResult.authority.url context:nil error:&authorityError];
    
    if (!authority)
    {
        MSID_LOG_NO_PII(MSIDLogLevelWarning, nil, nil, @"Invalid authority");
        MSID_LOG_PII(MSIDLogLevelWarning, nil, nil, @"Invalid authority, error %@", authorityError);
        
        if (error) *error = authorityError;
        
        return nil;
    }
    
    return [MSALResult resultWithMSIDTokenResult:tokenResult authority:authority error:error];
}

- (BOOL)removeAdditionalAccountInfo:(__unused MSALAccount *)account
                           clientId:(__unused NSString *)clientId
                         tokenCache:(__unused MSIDDefaultTokenCacheAccessor *)tokenCache
                              error:(NSError **)error
{
    return YES;
}

- (MSIDAuthority *)issuerAuthorityWithAccount:(__unused MSALAccount *)account
                             requestAuthority:(MSIDAuthority *)requestAuthority
                                        error:(__unused NSError **)error
{
    // TODO: after authority->issuer cache is ready, this should always lookup cached issuer instead
    return requestAuthority;
}

#pragma mark - Protected

- (void)initDerivedProperties
{
    self.msidOauth2Factory = [MSIDOauth2Factory new];
}

@end