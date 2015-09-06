//
//  BLUtility.m
//  HJDataSave
//
//  Created by HeJay on 8/24/15.
//  Copyright (c) 2015 Long. All rights reserved.
//

#import "BLUtility.h"

@implementation BLUtility

+ (NSString *)getPathWithinDocumentDir:(NSString *)aPath {
    NSString *fullPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([paths count] > 0) {
        fullPath = (NSString *)[paths objectAtIndex:0];
        if ([aPath length] > 0) {
            fullPath = [fullPath stringByAppendingPathComponent:aPath];
        }
    }
    
    return fullPath;
}

+ (BOOL)createDirectory:(NSString *)dirPath lastComponentIsDirectory:(BOOL)isDir {
    NSString *path = nil;
    if (isDir) {
        path = dirPath;
    } else {
        path = [dirPath stringByDeletingLastPathComponent];
    }
    if ([dirPath length] > 0 && [[NSFileManager defaultManager] fileExistsAtPath:path] == 0) {
        NSError *error = nil;
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
        if (!ret && error) {
            NSLog(@"create directory failed at path '%@',error %@, %@", path, [error localizedDescription], [error localizedFailureReason]);
            return NO;
        }
    }
    return YES;
}

+ (BOOL)removeFile:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                   error:&error];
        if (error) {
            NSLog(@"remove file '%@' failed, reson: %@", filePath, error);
            return NO;
        }
    }
    
    return YES;
}

+ (NSData *)archiverObject:(NSObject *)object forKey:(NSString *)key {
    if (object == nil) {
        return nil;
    }
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    
    return data;
}

+ (NSObject *)unarchiverObject:(NSData *)archivedData withKey:(NSString *)key {
    if (archivedData == nil) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archivedData];
    NSObject *object = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    
    return object;
}

@end
