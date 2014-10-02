//
//  main.m
//  Sample Project
//
//  Created by Konstantin Sukharev on 02/10/14.
//  Copyright (c) 2014 Konstantin Sukharev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"

int main(int argc, const char * argv[]) {

	@autoreleasepool {
		
		NSString *resourceFolder = NSBundle.mainBundle.executablePath.stringByDeletingLastPathComponent;
		NSString *resourceFile = [resourceFolder stringByAppendingPathComponent:@"sample.xml"];
		NSData *fileContents = [NSData dataWithContentsOfFile:resourceFile];
		XMLNode *rootNode = [XMLParser.parser parseData:fileContents];
		
		NSString *channelTitle = rootNode[@"channel.title.#stringValue"];
		NSURL *channelURL = rootNode[@"channel.link.#URLValue"];
		NSArray *itemsTitles = rootNode[@"channel.item[].title.#stringValue"];
		
		NSLog(@"Channel: %@", channelTitle);
		NSLog(@"Link: %@", channelURL);
		
		[itemsTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
			
			NSLog(@"\t%@", title);
		}];
	}
    return 0;
}
