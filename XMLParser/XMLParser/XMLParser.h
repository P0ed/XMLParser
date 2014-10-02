//
//  XMLParser.h
//  Created by POed on 7/12/13.
//


@import Foundation;
#import "XMLNode.h"


typedef void (^ParseCompletionBlock)(NSDictionary *userInfo);


@interface XMLParser : NSObject

@property (nonatomic, copy) ParseCompletionBlock parseSucceed;
@property (nonatomic, copy) ParseCompletionBlock parseFailed;

+ (instancetype)parser;

- (XMLNode *)parseData:(NSData *)data;

- (void)parsingCompleted;
- (void)parsingCompletedWithError:(NSError *)error;

@end
