//
//  XMLNode+Values.m
//  XMLParser
//  Created by POed on 02/10/14.
//

#import "XMLNode+Values.h"

@implementation XMLNode (Values)

- (id)stringValue {
	
	return self.value;
}

- (id)integerValue {
	
	NSNumber *value = nil;
	NSInteger integerValue = 0;
	
	if ([[NSScanner scannerWithString:self.value] scanInteger:&integerValue]) {
		
		value = @(integerValue);
	}
	
	return value;
}

- (id)floatValue {
	
	NSNumber *value = nil;
	double doubleValue = 0;
	
	if ([[NSScanner scannerWithString:self.value] scanDouble:&doubleValue]) {
		
		value = @(doubleValue);
	}
	
	return value;
}

- (id)boolValue {
	
	NSNumber *value = nil;
	if ([self.value.lowercaseString isEqualToString:@"true"]) {
		
		value = @(YES);
	}
	else if ([self.value.lowercaseString isEqualToString:@"false"]) {
		
		value = @(NO);
	}
	
	return value;
}

- (id)URLValue {
	
	return [NSURL URLWithString:self.value];
}

@end
