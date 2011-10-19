//
// XMLWriter.h
//

#import <Foundation/Foundation.h>

@interface XMLWriter : NSObject{
@private
    int treeLevel ,nodeCounts, node, objectlevel, currentNode, samenodeflag;
    NSMutableArray* nodes;
    NSString* xml;
    NSMutableArray* oldroot;
    NSMutableArray* treeNodes;
}
@property (nonatomic)int treeLevel, node, objectlevel, nodeCounts, currentNode, samenodeflag;
@property (nonatomic, retain)NSMutableArray* nodes;
@property (nonatomic, retain)NSString* xml;
@property (nonatomic, retain)NSMutableArray* oldroot;
@property (nonatomic, retain)NSMutableArray* treeNodes;


-(void)serialize:(id)root;
-(void)pushRootHistory:(id)root;
-(id)callOldRoot;
-(void)checkParent;
-(void)push:(NSString *)stack;
-(void)pop;

-(NSString *)xmlString;
-(NSString *)endString;
-(void)Stack:(NSString *)tag;
-(void)pushStackValue:(NSString *)stack;
-(void)pushStackValueArray:(NSString *)stack;


+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary;
+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toStringPath:(NSString *) path  Error:(NSError **)error;

@end
