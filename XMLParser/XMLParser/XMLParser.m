//
//  XMLParser.m
//  Created by POed on 7/12/13.
//


#import "XMLParser.h"


@interface XMLNode (XMLParser)
@property (nonatomic, strong) NSMutableString *foundCharacters;
@end


@interface NSString (XMLParser)
@property (nonatomic, readonly) NSString *po_stringByTrimmingEdges;
@end


@interface XMLParser () <NSXMLParserDelegate>
{
	NSData *_rawData;
	XMLNode *_rootNode;
	XMLNode *_currentNode;
}
@end


@implementation XMLParser


+ (instancetype)parser {
	
	return [[self alloc] init];
}

- (XMLNode *)parseData:(NSData *)data {
	
	_rawData = data;
	
	_rootNode = nil;
	_currentNode = nil;
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	
	if ([parser parse]) {
		
		[self parsingCompleted];
	}
	else {
		
		[self parsingCompletedWithError:parser.parserError];
	}
	
	return _rootNode;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)theParser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	
	XMLNode *node = [XMLNode node];
	node.key = elementName;
	node.foundCharacters = @"".mutableCopy;
	[_currentNode addChildNode:node], _currentNode = node;
	
	if (!_rootNode) {
		
		_rootNode = _currentNode;
	}
}

- (void)parser:(NSXMLParser *)theParser foundCharacters:(NSString *)string {
	
	[_currentNode.foundCharacters appendString:string];
}

- (void)parser:(NSXMLParser *)theParser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	_currentNode.value = _currentNode.foundCharacters.po_stringByTrimmingEdges;
	_currentNode.foundCharacters = nil;
	
	_currentNode = _currentNode.parentNode;
}


#pragma mark -

- (void)parsingCompleted {
	
	if (self.parseSucceed) {
		
		NSDictionary *userInfo = _rootNode ? @{@"rootNode": _rootNode} : nil;
		self.parseSucceed(userInfo);
	}
}

- (void)parsingCompletedWithError:(NSError *)error {

	if (self.parseFailed) {
	
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
		[userInfo setValue:error forKey:@"error"];
		[userInfo setValue:_rootNode forKey:@"rootNode"];
		
		self.parseFailed(userInfo);
	}
}

@end


@implementation XMLNode (XMLParser)
@dynamic foundCharacters;
@end


@implementation NSString (XMLParser)

- (NSString *)po_stringByTrimmingEdges {
	
	NSString *trimmedString = self;
	NSCharacterSet *charSet = [NSCharacterSet.whitespaceAndNewlineCharacterSet invertedSet];
	NSUInteger index = [trimmedString rangeOfCharacterFromSet:charSet].location;
	if (index != NSNotFound && index > 0) {
		
		trimmedString = [trimmedString substringWithRange:NSMakeRange(index, trimmedString.length - index)];
	}
	
	index = [trimmedString rangeOfCharacterFromSet:charSet options:NSBackwardsSearch].location + 1;
	if (index != NSNotFound && index < trimmedString.length) {
		
		trimmedString = [trimmedString substringWithRange:NSMakeRange(0, index)];
	}
	
	return trimmedString;
}

@end
