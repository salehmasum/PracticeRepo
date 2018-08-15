//
//  KeyChainStore.h
//  FrameworkTest
//
//  Created by 朱明 on 16/3/11.
//  Copyright © 2016年 Shanghai Seari Intelligent System Co., Ltd. Xi'an Inst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject
/**
 *	@brief	保存数据到keyChain
 *
 *	@param 	service 	关键字
 *	@param 	data 	需要保存的数据
 */
+ (void)save:(NSString *)service data:(id)data;

/**
 *	@brief	读取Keychain中的数据
 *
 *	@param 	service 	关键字key
 *
 *	@return	返回关键字对应的值
 */
+ (id)load:(NSString *)service;

/**
 *	@brief	删除Keychain中的字段
 *
 *	@param 	service 	需要删除的字段
 */
+ (void)deleteKeyData:(NSString *)service;

@end
