//
// XMLWriter.h
//
//  Changed by RealZYC on 10/31/2016
//

#import <Foundation/Foundation.h>

@interface XMLWriter : NSObject{
@private
    NSMutableArray* nodes;
    NSMutableData* xml;
    NSMutableArray* treeNodes;
    BOOL isRoot;
    NSString* passDict;
    BOOL withHeader;
}
+(NSData *)XMLDataFromDictionary:(NSDictionary *)dictionary; //New
+(NSData *)XMLDataFromDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header; //New
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary;
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header;
+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toStringPath:(NSString *)path  Error:(NSError **)error;

@end
