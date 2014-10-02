//
//  main.m
//  Sample Project
//
//  Created by Konstantin Sukharev on 02/10/14.
//  Copyright (c) 2014 Konstantin Sukharev. All rights reserved.
//

@import Foundation;
#import "XMLParser.h"


@interface Item : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSURL *link;
@property (nonatomic) NSString *text;
@end


@interface XMLNode (ItemValue)
@end


int main(int argc, const char * argv[]) {

	@autoreleasepool {
		
		NSString *resourceFolder = NSBundle.mainBundle.executablePath.stringByDeletingLastPathComponent;
		NSString *resourceFile = [resourceFolder stringByAppendingPathComponent:@"sample.xml"];
		NSData *fileContents = [NSData dataWithContentsOfFile:resourceFile];
		XMLNode *rootNode = [XMLParser.parser parseData:fileContents];
		
		NSString *channelTitle = rootNode[@"channel.title.#stringValue"];
		NSURL *channelURL = rootNode[@"channel.link.#URLValue"];
		NSArray *items = rootNode[@"channel.item[].#itemValue"];
		
		NSLog(@"Channel: %@", channelTitle);
		NSLog(@"Link: %@", channelURL);
		
		[items enumerateObjectsUsingBlock:^(Item *item, NSUInteger idx, BOOL *stop) {
			
			NSLog(@"\t%@", item.title);
		}];
	}
    return 0;
}


@implementation Item
@end


@implementation XMLNode (ItemValue)

- (Item *)itemValue {
	
	Item *item = [Item new];
	item.title = self[@"title.#stringValue"];
	item.link = self[@"title.#URLValue"];
	item.text = self[@"title.#stringValue"];
	
	return item;
}

@end

