XMLParser
=========

Simple parser that builds a tree and provides easy access to the nodes,
allowing to transform nodes into objects implementing a single method.

Example:

<rss version="2.0">
	<channel>
		<title>
			W3Schools Home Page
		</title>
		<link>http://www.w3schools.com</link>
		<description>Free web building tutorials</description>
		
		<item>
			<title>RSS Tutorial</title>
			<link>http://www.w3schools.com/rss</link>
			<description>New RSS tutorial on W3Schools</description>
		</item>
		<item>
			<title>XML Tutorial</title>
			<link>http://www.w3schools.com/xml</link>
			<description>New XML tutorial on W3Schools</description>
		</item>
	</channel>
</rss>

XMLNode *rootNode = [XMLParser.parser parseData:fileContents];
XMLNode *channelNode = rootNode[@"channel"];
NSString *channelTitle = channelNode[@"title.#stringValue"];
NSURL *channelURL = channelNode[@"link.#URLValue"];
NSArray *items = channelNode[@"item[].#itemValue"];

To transform <item> into Item you need to implement a method in XMLNode category

@implementation XMLNode (ItemValue)
- (Item *)itemValue {
	
	Item *item = [Item new];
	item.title = self[@"title.#stringValue"];
	item.link = self[@"title.#URLValue"];
	item.text = self[@"title.#stringValue"];
	
	return item;
}
@end
