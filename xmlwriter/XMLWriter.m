//
//  XMLWriter.m
//
#import "XMLWriter.h"
#define PREFIX_STRING_FOR_ELEMENT @"@" //From XMLReader
@implementation XMLWriter

-(void)serialize:(id)root
{    
    if([root isKindOfClass:[NSArray class]])
        {
            int mula = (int)[root count];
            mula--;
            [nodes addObject:[NSString stringWithFormat:@"%i",(int)mula]];

            for(id objects in root)
            {
                if ([[nodes lastObject] isEqualToString:@"0"] || [nodes lastObject] == NULL || ![nodes count])
                {
                    [nodes removeLastObject];
                    [self serialize:objects];
                }
                else
                {
                    [self serialize:objects];
                    if(!isRoot)
                    {
                        //xml = [xml stringByAppendingFormat:@"</%@><%@>",[treeNodes lastObject],[treeNodes lastObject]];
                        NSString *itemLast = [NSString stringWithFormat:@"</%@><%@>",
                                              [treeNodes lastObject],
                                              [treeNodes lastObject]];
                        itemLast = [itemLast
                                    stringByReplacingOccurrencesOfString:@"</(null)><(null)>"
                                    withString:@"\n"]; //RealZYC
                        [xml appendData:
                         [itemLast dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    else
                        isRoot = FALSE;
                    int value = [[nodes lastObject] intValue];
                    [nodes removeLastObject];
                    value--;
                    [nodes addObject:[NSString stringWithFormat:@"%i",(int)value]];
                }
            }
        }
        else if ([root isKindOfClass:[NSDictionary class]])
        {
            for (NSString* key in root)
            {
                if(!isRoot)
                {
//                    NSLog(@"We came in");
                    [treeNodes addObject:key];
                    //xml = [xml stringByAppendingFormat:@"<%@>",key];
                    [xml appendData:
                     [[NSString stringWithFormat:@"<%@>",key]
                      dataUsingEncoding:NSUTF8StringEncoding]];
                    [self serialize:[root objectForKey:key]];
                    //xml =[xml stringByAppendingFormat:@"</%@>",key];
                    [xml appendData:
                     [[NSString stringWithFormat:@"</%@>",key]
                      dataUsingEncoding:NSUTF8StringEncoding]];
                    [treeNodes removeLastObject];
                } else {
                    isRoot = FALSE;
                    [self serialize:[root objectForKey:key]];
                }
            }
        }
        else if ([root isKindOfClass:[NSString class]] || [root isKindOfClass:[NSNumber class]] || [root isKindOfClass:[NSURL class]])
        {
//            if ([root hasPrefix:"PREFIX_STRING_FOR_ELEMENT"])
//            is element
//            else
            //xml = [xml stringByAppendingFormat:@"%@",root];
            [xml appendData:
             [[NSString stringWithFormat:@"%@",root]
              dataUsingEncoding:NSUTF8StringEncoding]];
        }
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        // Initialization code here.
        //xml = @"";
        xml = [[NSMutableData alloc] init];
        if (withHeader)
            //xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
            [xml appendData:
             [@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
              dataUsingEncoding:NSUTF8StringEncoding]];
        nodes = [[NSMutableArray alloc] init]; 
        treeNodes = [[NSMutableArray alloc] init]; 
        isRoot = YES;
        passDict = [[dictionary allKeys] lastObject];
        //xml = [xml stringByAppendingFormat:@"<%@>\n",passDict];
        [xml appendData:
         [[NSString stringWithFormat:@"<%@>\n",passDict]
          dataUsingEncoding:NSUTF8StringEncoding]];
        [self serialize:dictionary];
    }
    
    return self;
}
- (id)initWithDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header {
    withHeader = header;
    self = [self initWithDictionary:dictionary];
    return self;
}

-(void)dealloc
{
    //    [xml release],nodes =nil;
    /*[nodes release],*/ nodes = nil ;
    /*[treeNodes release],*/ treeNodes = nil;
    //[super dealloc];
}

-(NSData *)getXML
{
    //xml = [xml stringByReplacingOccurrencesOfString:@"</(null)><(null)>" withString:@"\n"]; //Can not do it with NSData
    //xml = [xml stringByAppendingFormat:@"\n</%@>",passDict];
    [xml appendData:
     [[NSString stringWithFormat:@"\n</%@>",passDict]
      dataUsingEncoding:NSUTF8StringEncoding]];
    return xml;
}

+(NSData *)XMLDataFromDictionary:(NSDictionary *)dictionary
{
    if (![[dictionary allKeys] count])
        return NULL;
    XMLWriter* fromDictionary = [[XMLWriter alloc]initWithDictionary:dictionary];
    return [fromDictionary getXML];
}

+ (NSData *) XMLDataFromDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header {
    if (![[dictionary allKeys] count])
        return NULL;
    XMLWriter* fromDictionary = [[XMLWriter alloc]initWithDictionary:dictionary withHeader:header];
    return [fromDictionary getXML];
}

+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary
{
    return [[NSString alloc]
            initWithData:[XMLWriter XMLDataFromDictionary:dictionary]
            encoding:NSUTF8StringEncoding];
}

+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header
{
    return [[NSString alloc]
            initWithData:[XMLWriter XMLDataFromDictionary:dictionary withHeader:header]
            encoding:NSUTF8StringEncoding];
}

+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toStringPath:(NSString *) path  Error:(NSError **)error
{
    
    XMLWriter* fromDictionary = [[XMLWriter alloc]initWithDictionary:dictionary];
    [[fromDictionary getXML] writeToFile:path atomically:YES];
    if (error)
        return FALSE;
    else
        return TRUE;
    
}
@end
