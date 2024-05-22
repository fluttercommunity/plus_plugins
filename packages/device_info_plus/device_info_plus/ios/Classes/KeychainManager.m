//
//  KeychainUUID.m
//  Runner
//
//  Created by Kang on 2024/5/11.
//

#import "KeychainManager.h"
//#import <Security/Security.h>
@implementation KeychainManager

//+ (instancetype)sharedManager {
//    static dispatch_once_t onceToken;
//    static KeychainSaveData *manager;
//    dispatch_once(&onceToken, ^{
//        manager = [[self alloc] initKeyChainManager];
//    });
//    return manager;
//}

//- (instancetype)init {
//    NSAssert(NO, @"Singleton class, use shared method");
//    return nil;
//}

//- (instancetype)initKeyChainManager {
//    self = [super init];
//    if (!self) return nil;
//    return self;
//}


+(NSMutableDictionary*)keyChainIdentifier:(NSString*)identifier
{
    NSMutableDictionary * keyChainInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                       (id)kSecClassGenericPassword,kSecClass,
                                                      [ [NSBundle mainBundle] bundleIdentifier],kSecAttrService,
                                                       identifier,kSecAttrAccount,
                                                       (id)kSecAttrAccessibleAfterFirstUnlock,kSecAttrAccessible, nil];
    return keyChainInfo;
}


/*
 保存数据
 
 @data  要存储的数据
 @identifier 存储数据的唯一标示
 */
+(BOOL)saveDataForKeyChain:(id)data identifier:(NSString*)identifier
{
    //获取存储数据的必要条件
    NSMutableDictionary *saveQueryInfo = [self keyChainIdentifier:identifier];
    //删除旧的数据
    SecItemDelete((CFDictionaryRef)saveQueryInfo);
    //设置需要存储的新的数据
    [saveQueryInfo setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:nil] forKey:(id)kSecValueData];
//    [saveQueryInfo setObject:
//     [NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //添加数据，saveState返回添加数据是否成功状态
    OSStatus saveState = SecItemAdd((CFDictionaryRef)saveQueryInfo, nil);
    if (saveState == errSecSuccess) {
        return YES;
    }
    return NO;
}

/*
 读取数据
 
 @identifier 存储数据的标示
 */
+(id)readDataFromKeyChain:(NSString*)identifier
{
    id objc = nil ;
    //通过标记获取数据查询条件
    NSMutableDictionary *readQueryInfo = [self keyChainIdentifier:identifier];
    // 设置搜索条件：这是获取数据的时，必须提供的两个属性
    // 查询结果返回类型为： kSecValueData
    [readQueryInfo setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    // 只返回搜索到的第一条数据
    [readQueryInfo setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    // 创建一个数据对象
    CFDataRef keyChainData = nil ;
    // 通过条件查询数据
    if (SecItemCopyMatching((CFDictionaryRef)readQueryInfo , (CFTypeRef *)&keyChainData) == noErr){
        @try {
            NSError *err = nil;
            objc = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[NSArray.class,NSDictionary.class, NSString.class,NSMutableArray.class, NSMutableDictionary.class, NSMutableString.class, NSMutableData.class, NSData.class, NSNull.class, NSValue.class,NSDate.class]] fromData:(__bridge NSData *)(keyChainData) error:&err];
                
           /* [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)(keyChainData)]*/;
        } @catch (NSException * exception){
            NSLog(@"Unarchive of search data where %@ failed of %@ ",identifier,exception);
        }
    }
    if (keyChainData) {
        CFRelease(keyChainData);
    }
    return objc;
}


/*
 更新数据
 
 @data  要更新的数据
 @identifier 数据存储时的标示
 */
+(BOOL)updataForKeyChain:(id)data identifier:(NSString*)identifier
{
    // 通过标记获取数据更新的必要条件
    NSMutableDictionary * updataQueryInfo = [self keyChainIdentifier:identifier];
    // 创建更新数据字典
    NSMutableDictionary * updataInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    // 存储数据
    [updataInfo setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:nil] forKey:(id)kSecValueData];
    // 获取更新存储的状态
    OSStatus  updataStatus = SecItemUpdate((CFDictionaryRef)updataQueryInfo, (CFDictionaryRef)updataInfo);
    if (updataStatus == errSecSuccess) {
        return  YES ;
    }
    return NO;
}

/*
 删除数据
 
 @identifier 数据存储时的标示
 */
+(BOOL)keyChainDelete:(NSString*)identifier
{
    // 获取删除数据的查询条件
    NSMutableDictionary * deleteQueryInfo = [self keyChainIdentifier:identifier];
    // 删除指定条件的数据
    OSStatus  updataStatus = SecItemDelete((CFDictionaryRef)deleteQueryInfo);
    if (updataStatus == errSecSuccess) {
        return  YES ;
    }
    return NO;
}


@end
