//
//  KeychainUUID.h
//  Runner
//
//  Created by Kang on 2024/5/11.
//

#import <Foundation/Foundation.h>
//
NS_ASSUME_NONNULL_BEGIN

@interface KeychainManager : NSObject

//+ (instancetype)sharedManager;

/*
 保存数据
 
 @data  要存储的数据
 @identifier 存储数据的标示
 */
+(BOOL)saveDataForKeyChain:(id)data identifier:(NSString*)identifier;

/*
 读取数据
 
 @identifier 存储数据的标示
 */
+(id)readDataFromKeyChain:(NSString*)identifier;

/*
 更新数据
 
 @data  要更新的数据
 @identifier 数据存储时的标示
 */
+(BOOL)updataForKeyChain:(id)data identifier:(NSString*)identifier;

/*
 删除数据
 
 @identifier 数据存储时的标示
 */
+(BOOL)keyChainDelete:(NSString*)identifier;
@end

NS_ASSUME_NONNULL_END
