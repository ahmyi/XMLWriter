//
// XMLWriter.h
//

#import <Foundation/Foundation.h>

@interface XMLWriter : NSObject{
@private
    NSMutableArray* nodes;
    NSString* xml;
    NSMutableArray* treeNodes;
    BOOL isRoot;
    NSString* passDict;
    BOOL withHeader;
}
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary;
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header;
+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toStringPath:(NSString *) path  Error:(NSError **)error;

@end
