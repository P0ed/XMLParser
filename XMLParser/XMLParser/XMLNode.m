//
//  XMLNode.m
//  Created by POed on 7/12/13.
//


#import "XMLNode.h"
#import "XMLParser.h"


@interface XMLNode ()
@property (nonatomic, strong) NSMutableString *foundCharacters;
@end


@implementation XMLNode {
	
	__weak XMLNode *_parentNode;
	NSMutableArray *_childNodes;
}

+ (instancetype)node {
	
	return [[self alloc] init];
}

+ (instancetype)nodeWithXMLString:(NSString *)string {
	
	return [XMLParser.parser parseData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (instancetype)init {
	
	if (self = [super init]) {
		
		_childNodes = @[].mutableCopy;
	}
	
	return self;
}

- (BOOL)isLeaf {
	
	return _childNodes.count == 0;
}

- (void)setParentNode:(XMLNode *)parentNode {
	
	// Закрытый сеттер, используется при добавлении/удалении узлов
	_parentNode = parentNode;
}

- (XMLNode *)rootNode {
	
	return self.parentNode ? self.parentNode.rootNode : self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
	
	// Перегрузка оператора [] для целых чисел
	return _childNodes[idx];
}

- (id)objectForKeyedSubscript:(id)key {
	
	// Перегрузка оператора [] для объектов
	return [self valueForKeyPath:key];
}

- (id)valueForKey:(NSString *)key {
	
	id value = nil;
	
	if ([key characterAtIndex:0] == '#') {
		
		// Поиск значения свойства <type> по ключу #<type>
		value = [super valueForKey:[key substringFromIndex:1]];
	}
	else if ([key hasSuffix:@"[]"]) {
		
		key = [key substringToIndex:key.length - 2];
		
		// Ищу дочерние узелы по ключу, и возвращаю массив
		NSIndexSet *indexSet = [_childNodes indexesOfObjectsPassingTest:^BOOL(XMLNode *node, NSUInteger idx, BOOL *stop) {
			
			return [node.key isEqual:key];
		}];
		
		if (indexSet.count) {
			
			value = [_childNodes objectsAtIndexes:indexSet];
		}
	}
	else {
		
		// Ищу дочерний узел по ключу
		NSUInteger index = [_childNodes indexOfObjectPassingTest:^BOOL(XMLNode *node, NSUInteger idx, BOOL *stop) {
			
			*stop = [node.key isEqual:key];
			return *stop;
		}];
		
		if (index != NSNotFound) {
			
			value = _childNodes[index];
		}
	}
	
	return value;
}

#pragma mark - description

- (NSString *)description {
	
	return [NSString stringWithFormat:
			@"<%@: 0x%lx; key: %@; value: %@; parentNode: 0x%lx; childNodes: %ld>",
			NSStringFromClass(self.class),
			(unsigned long)self,
			self.key,
			self.value,
			(unsigned long)self.parentNode,
			self.childNodes.count];
}

- (NSString *)contentWithIndentationLevel:(NSUInteger)indentationLevel {
	
	NSString *tabs = [@"" stringByPaddingToLength:indentationLevel withString:@"\t" startingAtIndex:0];
	NSMutableString *content = [NSMutableString stringWithFormat:@"%@<%@>", tabs, self.key];
	
	if (!self.isLeaf) {
		
		[content appendFormat:@"\n"];
		
		[self.childNodes enumerateObjectsUsingBlock:^(XMLNode *childNode, NSUInteger idx, BOOL *stop) {
			
			[content appendFormat:@"%@", [childNode contentWithIndentationLevel:indentationLevel + 1]];
		}];
		
		[content appendFormat:@"%@</%@>\n", tabs, self.key];
	}
	else {
		
		NSString *value = self.value ?: @"";
		
		[content appendFormat:@"%@</%@>\n", value, self.key];
	}
	
	return content;
}

- (NSString *)content {
	
	return [self contentWithIndentationLevel:0];
}


#pragma mark - Container methods

- (void)addChildNode:(XMLNode *)node {
	
	[self insertChildNode:node atIndex:_childNodes.count];
}

- (void)removeChildNode:(XMLNode *)node {
	
	NSUInteger index = [_childNodes indexOfObjectIdenticalTo:node];
	
	if (index != NSNotFound) {
		
		[self removeChildNodeAtIndex:index];
	}
}

- (void)insertChildNode:(XMLNode *)node atIndex:(NSUInteger)index {
	
	if ([_childNodes indexOfObjectIdenticalTo:node] == NSNotFound) {
		
		node.parentNode = self;
		[_childNodes insertObject:node atIndex:index];
	}
	else {
		
		[NSException raise:@"AttemptToAddAlreadyIncludedNode" format:@"Attempt to add already included node %@", node];
	}
}

- (void)removeChildNodeAtIndex:(NSUInteger)index {
	
	XMLNode *node = _childNodes[index];
	node.parentNode = nil;
	[_childNodes removeObjectAtIndex:index];
}

@end
