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


#import "MSALCacheConfig.h"

#if TARGET_OS_IPHONE
#import "MSIDKeychainTokenCache.h"
#endif

@implementation MSALCacheConfig
  
- (instancetype)initWithKeychainSharingGroup:(NSString *)keychainSharingGroup
{
    self = [super init];
    if (self)
    {
#if TARGET_OS_IPHONE
        _keychainSharingGroup = keychainSharingGroup;
#endif
    }
    return self;
}

+ (NSString *)defaultKeychainSharingGroup
{
#if TARGET_OS_IPHONE
    return MSIDKeychainTokenCache.defaultKeychainGroup;
#else
    return nil;
#endif
}

+ (instancetype)defaultConfig
{
#if TARGET_OS_IPHONE
    return [[self.class alloc] initWithKeychainSharingGroup:MSIDKeychainTokenCache.defaultKeychainGroup];
#else
    return [[self.class alloc] initWithKeychainSharingGroup:nil];
#endif
}

- (BOOL)enableKeychainSharing
{
#if TARGET_OS_IPHONE
    return [_keychainSharingGroup isEqualToString:[[NSBundle mainBundle] bundleIdentifier]];
#else
    return NO;
#endif
}

- (void)setEnableKeychainSharing:(BOOL)enableKeychainSharing
{
#if TARGET_OS_IPHONE
    if (enableKeychainSharing && [_keychainSharingGroup isEqualToString:[[NSBundle mainBundle] bundleIdentifier]])
    {
        _keychainSharingGroup = MSIDKeychainTokenCache.defaultKeychainGroup;
    }
    else
    {
        _keychainSharingGroup = [[NSBundle mainBundle] bundleIdentifier];
    }
#else
    // TODO: add mac support
#endif
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    NSString *keychainSharingGroup = [_keychainSharingGroup copyWithZone:zone];
    return [[self.class alloc] initWithKeychainSharingGroup:keychainSharingGroup];
}

@end