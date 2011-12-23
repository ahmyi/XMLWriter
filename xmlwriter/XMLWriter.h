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
}
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary;
+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toStringPath:(NSString *) path  Error:(NSError **)error;

@end
