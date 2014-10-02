//
//  XMLNode.h
//  Created by POed on 7/12/13.
//


@import Foundation;


@interface XMLNode : NSObject

@property (nonatomic, readonly) BOOL isLeaf;
@property (nonatomic, readonly) XMLNode *parentNode;
@property (nonatomic, readonly) XMLNode *rootNode;

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@property (nonatomic, readonly) NSArray *childNodes;

@property (nonatomic, readonly) NSString *content;

+ (instancetype)node;
+ (instancetype)nodeWithXMLString:(NSString *)string;
- (instancetype)init;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (id)objectForKeyedSubscript:(id)key;

- (void)addChildNode:(XMLNode *)node;
- (void)removeChildNode:(XMLNode *)node;

- (void)insertChildNode:(XMLNode *)node atIndex:(NSUInteger)index;
- (void)removeChildNodeAtIndex:(NSUInteger)index;

@end
