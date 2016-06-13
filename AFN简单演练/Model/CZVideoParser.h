//
//  CZVideoParser.h
//  AFN简单演练
//
//  Created by 张玺科 on 16/6/12.
//  Copyright © 2016年 张玺科. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Video;

@interface CZVideoParser : NSObject
- (void)parseWithData:(NSData *)data completion:(void (^)(NSArray <Video *> *list))completion;

- (NSArray *)parseWithParser:(NSXMLParser *)parser;

- (NSArray *)parseWithData:(NSData *)data;
@end
