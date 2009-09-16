//
//  md5.m
//  txtEdit
//
//  Created by Mike Fluff on 31.08.09.
//  Copyright 2009 Altell ltd. All rights reserved.
//

#import "md5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (MD5)
- (NSString *)md5sum {
	CC_MD5_CTX digestCtx;
    unsigned char digestBytes[CC_MD5_DIGEST_LENGTH];
    char digestChars[CC_MD5_DIGEST_LENGTH * 2 + 1];
    NSRange stringRange = NSMakeRange(0, [self length]);
    unsigned char buffer[128];
    NSUInteger usedBufferCount;
    CC_MD5_Init(&digestCtx);
    while ([self getBytes:buffer
                maxLength:sizeof(buffer)
               usedLength:&usedBufferCount
                 encoding:NSUnicodeStringEncoding
                  options:NSStringEncodingConversionAllowLossy
                    range:stringRange
           remainingRange:&stringRange])
        CC_MD5_Update(&digestCtx, buffer, usedBufferCount);
    CC_MD5_Final(digestBytes, &digestCtx);
    for (int i = 0;
         i < CC_MD5_DIGEST_LENGTH;
         i++)
        sprintf(&digestChars[2 * i], "%02x", digestBytes[i]);
    return [NSString stringWithUTF8String:digestChars];
}
@end

