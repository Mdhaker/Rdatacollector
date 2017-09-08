selectData <- function(path,item="id",where="",file="",append=FALSE,flatten=FALSE)
{
  return (rJava::.jcall(socialInterface,"[Ljava/lang/String;","selectFrom",path,item,where,file,append,flatten));
}

countData <- function(path,item="*",flatten=FALSE,rootarray)
{
  return (rJava::.jcall(socialInterface,"I","count",path,item,flatten,rootarray));
}

## Get facebook graph edge of a specific node
#
# this function calls facebook graph API endpoints to collect public data using nodes and edges
#and save it into a json file
# @param path Path to save the data
# @param node Facebook graph node id, eg(Page id, User id, Post id)...
# @param edge Graph edge name, eg(comment,posts,feed,likes) ...
# @param user TRUE to use user token for the edge call, FALSE to use the App token
# @return


jsonLoadFromFacebook <- function(path,node,edge,user=FALSE,params=rJava::.jarray(c("")))
{
  return(rJava::.jcall(socialInterface,"Ljava/lang/String;","getFacebookEdge",path,node,edge,user,params));
}

# Search for facebook nodes with query
#
# this function call the search endpoint for facebook nodes including users, pages, groups and events
#by calling the facebook graph search endpoint, and save the result data into a json file
#
# @param path Path to save the data
# @param node Facebook node type : user, page, event, group
#@param query Text query of the search request
# @return

jsonSearchFromFacebook <- function(path,node="page",query)
{
  return(rJava::.jcall(socialInterface,"Ljava/lang/String;","searchFacebookEdge",path,node,query));
}
# Get Twitter data by filter
#
# this function target the twitter search endpoint of twitter API by filter and save the reponse data into a json file
# in the directory path provided
#
# @param path directory path to save the json data file
# @param allwords filter tweets by all words in the string seperated by space
# @param exactphrase filter tweets by exact string
# @param lang language code of the tweets ...
# @param hashtag filter tweets by hashtags in this string seperated by space ...
# @param oneof filter tweets by one of the words in this string seperated by space ...
# @param noneof filter tweets by excluding all the words in this string seperated by space ...
# @param attitude postive attitude : True, negative attitude : False
# @param question question exist in tweet : True else false.
# @return void

jsonSearchTweetsByFilter <- function(path,lang="en",exact="",allword="",hashtags="",noneWords="",oneOf="",
                                   accounts="",attitude=TRUE,question=FALSE)
{
  return(rJava::.jcall(socialInterface,"Ljava/lang/String;","getTweets",path,lang,exact,allword,hashtags,noneWords,oneOf,accounts,attitude,question));
}


# Get Twitter data by text query
#
# this function target the twitter search endpoint of twitter API by text query and save the reponse data into a json file
# in the directory path provided
#
# @param path directory path to save the json data file
# @param query fetch tweets by the provided text query
# @return void
jsonSearchTweetsByQuery <- function(path,query)
{
  return(rJava::.jcall(socialInterface,"Ljava/lang/String;","getTweets",path,query));
}

# Get google plus data
#
# this function fetch activities from google plus API by submitting a filtered search in save it to a json file
# in the directory path provided
#
# @param path path to save the data
# @param query text query to search for activities
# @param lang language code of the activities ...
# @return void
jsonSearchFomGooglePlus <- function(path,query="",lang="en")
{
  return(rJava::.jcall(socialInterface,"Ljava/lang/String;","getActivities",path,query,lang));
}
# Collect topics from Social medias such twitter and google+
#
# this function calls twitter and google+ api endpoints to retreive activities and tweets then save into json files
# @param path path of the json file to save
# @param query Search query
# @return void

jsonLoadTopics <- function(path,query)
{
  return (rJava::.jcall(socialInterface,"V","getTopics",path,query));
}
# search Data from youtube
#
# this function calls youtube search endpoint api to retreive json data of a given query or type and save into a file
# @param path Path to save the json file
# @param type type of element to retreive (channel, video, playlist)
# @param query query of the request

# @return void
jsonSearchFromYoutube<-function(path,type="",query)
{
  return (rJava::.jcall(socialInterface,"Ljava/lang/String;","searchYoutube",path,type,query));
}

# Collect Data from Tumblr
#
# this function calls Tumblr search api to retreive json data about posts based on a given tag
# @param path Path to save the json file
# @param tag type of element to retreive (channel, video, playlist)
# @return void
jsonSearchFromTumblr<-function(path,tag)
{
  return (rJava::.jcall(socialInterface,"Ljava/lang/String;","getTumblrPosts",path,tag));
}
# Collect Data from Flickr
#
# this function calls Tumblr search api to retreive json data about a published photo based on a text query  a given tag
# @param path Path to save the json file
# @param query type of element to retreive (channel, video, playlist)
# @return void
jsonSearchFromFlickr<-function(path,query)
{
  return (rJava::.jcall(socialInterface,"Ljava/lang/String;","getFlickrPhotos",path,query));
}
# Collect Data from youtube
#
# this function calls youtube Google api to retreive json data of a single given element and save into a file
# @param path Path to save the json file
# @param type type of element to retreive (channel, video, playlist)
# @param id id of the element

# @return void
jsonLoadFromYoutube<-function(path,type,id)
{
  return (rJava::.jcall(socialInterface,"Ljava/lang/String;","getYoutube",path,type,id));
}


# Collect List of Data from Flickr
#
# this function calls Flickr api to retreive json data from a list of Ids and save into a file
# @param path Path to save the json file
# @param ids array of ids
# @return void
jsonLoadByListFromFlickr<-function(path,ids)
{
  ids=rJava::.jarray(ids);
  return (rJava::.jcall(socialInterface,"Ljava/lang/String;","getFlickrList",path,ids));
}

# Collect List of Data from youtube
#
# this function calls youtube Google api to retreive json data of a iDs list and save into a file
# @param path Path to save the json file
# @param type type of element to retreive (channel, video, playlist)
# @param ids array of ids
# @return void
jsonLoadByListFromYoutube<-function(path,type,ids)
{
  ids=rJava::.jarray(ids);
  return (rJava::.jcall(socialInterface,"Ljava/lang/String;","getYouTubeList",path,type,ids));
}

# Collect data about users of facebook and google+
#
# this function collect and fetch data about facebook and google+ users and save it into a json file
# @param path Path to save file
# @param query Search query
# @return void
jsonLoadUsers <- function(path,query)
{
  return (rJava::.jcall(socialInterface,"V","getUsers",path,query));
}
