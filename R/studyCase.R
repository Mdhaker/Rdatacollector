#' Collect facebook data
#'
#' This function collect data from facebook (nodes/edge) couple such posts and feed in pages, groups and events,
#' then parse it and save into an R dataframe and spredsheet excel file.
#'
#' @param nodeid Id if the target facebook node
#' @param user FALSE to use an application based call, TRUE t o use Autenticated calls (used to fetch private groups and events)
#' @param rootPath path to save the generated results
#' @export
collectFacebookNodes<-function(nodeid,edge="feed",user=FALSE,rootPath="/home/dhaker/Desktop/Ghandi/")
{
      #parsing posts to dataframe
      #****
      pathToJson <-paste0(rootPath,"/facebook/",nodeid);
      resultsource <- jsonLoadFromFacebook(pathToJson,nodeid,edge,user = user);
      postscount <-countData(resultsource,flatten = TRUE,rootarray = "data");
      if(postscount > 0)
      {
      postsIds<-selectData(resultsource,"id as id",flatten = TRUE);
      postsTypes <- selectData(resultsource,"type as type",flatten = TRUE);
      postsMessage <- selectData(resultsource,"message as message",flatten = TRUE);
      postsCreationTime <- selectData(resultsource,"created_time as ctime",flatten = TRUE);
      postsUpdateTime <- selectData(resultsource,"updated_time as utime",flatten = TRUE);
      postsShares <- selectData(resultsource,"shares.count as shares",flatten = TRUE);
      fromId <-selectData(resultsource,"from.id as id",flatten = TRUE);
      fromName <-selectData(resultsource,"from.name as name",flatten = TRUE);
      postLikes <- list();
      for(i in 0:postscount)
        {
        postLikes[i]<-length(selectData(resultsource,paste0("FLATTEN(root.data[",i,"].likes.data) as likes")));
        }
    postLikes <-unlist(postLikes);

    postComments <- list();
      for(i in 0:postscount)
      {
        postComments[i]<-length(selectData(resultsource,paste0("FLATTEN(root.data[",i,"].comments.data) as comments")));
      }
      postComments <-unlist(postComments);
      data <- data.frame();
      data=cbind(fromId,fromName,postsIds,postsMessage,postsTypes,postsCreationTime,postsUpdateTime,postsShares,postLikes,postComments);
      save(data,file=paste0(pathToJson,paste0(edge,".rda")));
      xlsx::write.xlsx(x = data, file = paste0(pathToJson,"/",edge,".xlsx"),
                       sheetName = edge);
      #parsing comments to data frame
      comment_postIds = list();
      comment_message = list();
      comment_time = list();
      comment_ids = list();
      comment_likescount = list();
      comment_from_id = list();
      comment_from_name = list();
      comment_urls =list();
      url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+";
      comment_index = 0;
      for(i in 0:postscount)
      {
        postid<-selectData(resultsource,paste0("root.data[",i,"].id as id"));
        commentCount<-length(selectData(resultsource,paste0("FLATTEN(root.data[",i,"].comments.data) as comments")));
        if(commentCount>0)
          {
        messages <- list();
        ids <- list();
        commentsids <-list();
        likecount<-list();
        fromname<-list();
        fromid<-list();
        times<-list();
        urls<-list();

        print(paste0("Number of comments to parse : ",commentCount));


          commentCount = commentCount-1;
        for(j in 0 :commentCount)
        {
          ids[(j+1)] = postid ;
          commentsids[(j+1)] = selectData(resultsource,paste0("root.data[",i,"].comments.data[",j,"].id as id"));
          messages[(j+1)] = selectData(resultsource,paste0("root.data[",i,"].comments.data[",j,"]['message'] as message"));
          likecount[(j+1)] = selectData(resultsource,paste0("root.data[",i,"].comments.data[",j,"]['like_count'] as likes"));
          fromname[(j+1)] = selectData(resultsource,paste0("root.data[",i,"].comments.data[",j,"]['from']['name'] as username"));
          fromid[(j+1)] = selectData(resultsource,paste0("root.data[",i,"].comments.data[",j,"]['from']['id'] as userid"));
          times[(j+1)] = selectData(resultsource,paste0("root.data[",i,"].comments.data[",j,"]['created_time'] as creationtime"));
          urls[(j+1)] = stringr::str_extract(comment_message[j], url_pattern);
          #comment_index = comment_index + 1 ;
        }
        print(paste0("this is the list of comment ids : ",commentsids));
        comment_message<-list(comment_message,messages);
        comment_ids<-list(comment_ids,commentsids);
        comment_postIds<-list(comment_postIds,ids);
        comment_likescount<-list(comment_likescount,likecount);
        comment_from_name<-list(comment_from_name,fromname);
        comment_from_id<-list(comment_from_id,fromid);
        comment_time<-list(comment_time,times);
        comment_urls<-list(comment_urls,urls);

      }

      comment_postIds = unlist(comment_postIds);
      comment_message = unlist(comment_message);
      comment_time = unlist(comment_time);
      comment_ids = unlist(comment_ids);
      comment_likescount = unlist(comment_likescount);
      comment_from_id = unlist(comment_from_id);
      comment_from_name = unlist(comment_from_name);
      comment_urls = unlist(comment_urls);
      data=cbind(comment_postIds,comment_ids,comment_message,comment_time,comment_from_id,comment_from_name,comment_likescount,comment_urls);
      save(data,file=paste0(pathToJson,paste0("Comments",edge,".rda")));}
      xlsx::write.xlsx(x = data, file = paste0(pathToJson,"/",edge,"Comments.xlsx"),
                       sheetName = "comments");
      return(data);
      }
      else
      {
        print("Query returned empty result");
        return(NULL);
      }
}

#' Search facebook data
#'
#' This function searchs facebook nodes including groups and events and pages,
#' then parse the results and save into an R dataframe and spredsheet excel file.
#'
#' @param query text query to use for the search
#' @param rootPath path to save the generated results
#' @export
searchFacebookNodes<-function(query,rootPath="/home/dhaker/Desktop/Ghandi/")
{
  nodeTypes <-c();
  nodeIds <-c();
  nodeNames <-c();
  nodeCategories <-c();
  pathToJson <-paste0(rootPath,"/facebook/searchResults/",stringr::str_trim(query),"/");
  pagesResultSource<-jsonSearchFromFacebook(pathToJson,"page",query);
  pagescount <- countData(pagesResultSource,flatten = TRUE,rootarray = "data");

  if(pagescount > 0)
  {
  for(i in 0:pagescount)
    {
      if(i>0)
        i=i-1;
      nodeTypes <-c(nodeTypes,"Page");
      nodeIds <-c(nodeIds,selectData(pagesResultSource,paste0("root.data[",i,"].id as id")));
      nodeNames <-c(nodeNames,selectData(pagesResultSource,paste0("root.data[",i,"].name as name")));
      nodeCategories <-c(nodeCategories,selectData(pagesResultSource,paste0("root.data[",i,"].category as category")));
    }
  }
  else
    print("No pages found");
  GroupsResultSource<-jsonSearchFromFacebook(pathToJson,"group",query);
  groupscount <- countData(pagesResultSource,flatten = TRUE,rootarray = "data");
  if(groupscount > 0)
  {
  for(i in 0:groupscount)
  {
    if(i>0)
      i=i-1;
    nodeTypes <-c(nodeTypes,"Group");
    nodeIds <-c(nodeIds,selectData(GroupsResultSource,paste0("root.data[",i,"].id as id")));
    nodeNames <-c(nodeNames,selectData(GroupsResultSource,paste0("root.data[",i,"].name as name")));
    nodeCategories <-c(nodeCategories,selectData(GroupsResultSource,paste0("root.data[",i,"].category as category")));

    }
  }
  else
    print("No groups found");
  EventsResultSource<-jsonSearchFromFacebook(pathToJson,"event",query);
  eventcount <- countData(EventsResultSource,flatten = TRUE,rootarray = "data");
  if(eventcount > 0){
  for(i in 0:eventcount)
  {
    if(i>0)
      i=i-1;
    nodeTypes <-c(nodeTypes,"Event");
    nodeIds <-c(nodeIds,selectData(EventsResultSource,paste0("root.data[",i,"].id as id")));
    nodeNames <-c(nodeNames,selectData(EventsResultSource,paste0("root.data[",i,"].name as name")));
    nodeCategories <-c(nodeCategories,selectData(EventsResultSource,paste0("root.data[",i,"].category as category")));

    }
  }
  else
    print("No event found");
  data =cbind(nodeTypes,nodeIds,nodeNames,nodeCategories);
  save(data,file=paste0(pathToJson,stringr::str_trim(query),"dataframe.rda"));
  xlsx::write.xlsx(x = data, file = paste0(pathToJson,"spreedSheet.xlsx"));
  return (data);



}
#' Search Twitter data
#'
#' This function searchs Tweets of the last 7 days from twitter from using a text query, then parse the result into an R dataframe and spreedSheet xls
#'
#' @param query text query to use for the search
#' @param rootPath path to save the generated results
#' @export
searchFromTwitter<-function(query,rootPath="/home/dhaker/Desktop/Ghandi/")
{
  pathToJson <-paste0(rootPath,"/Twitter/",stringr::str_trim(query),"/");
  resultsource <- jsonSearchTweetsByQuery(pathToJson,query);
  postscount <-countData(resultsource,flatten = TRUE,rootarray = "data");
  if(postscount > 0)
  {
  #collect tweet data
  tweetIsoLang<-selectData(resultsource,"metadata.iso_language_code as lang",flatten = TRUE);
  tweetCreated_at<-selectData(resultsource,"created_at as created_at",flatten = TRUE);
  tweetIds<-selectData(resultsource,"id as id",flatten = TRUE);
  tweetRetweetCount<-selectData(resultsource,"retweet_count as retweet",flatten = TRUE);
  tweetText<-selectData(resultsource,"text as tweet",flatten = TRUE);
  tweetPlace<-selectData(resultsource,"place.full_name as place",flatten = TRUE);
  #saving data
  data =cbind(tweetIsoLang,tweetCreated_at,tweetIds,tweetRetweetCount,tweetText,tweetPlace);
  save(data,file=paste0(pathToJson,"Tweets.rda"));
  xlsx::write.xlsx(x = data, file = paste0(pathToJson,"/","Tweets.xlsx"));

  #Collect user data
  userName<-selectData(resultsource,"user.name as name",flatten = TRUE);
  userLocation <- selectData(resultsource,"user.location as location",flatten = TRUE);
  userId <- selectData(resultsource,"user.id_str as id",flatten = TRUE);
  userLang <- selectData(resultsource,"user.lang as lang",flatten = TRUE);
  userCreatedAt <- selectData(resultsource,"user.created_at as created_at",flatten = TRUE);
  userFreindsCount <- selectData(resultsource,"user.friends_count as freinds",flatten = TRUE);
  userListCount <- selectData(resultsource,"user.listed_count as lists",flatten = TRUE);
  userFavoriteCount <- selectData(resultsource,"user.favourites_count as favourites_count",flatten = TRUE);
  userStatuesCount <- selectData(resultsource,"user.statuses_count as statues",flatten = TRUE);
  userFollowersCount <- selectData(resultsource,"user.followers_count as followers",flatten = TRUE);
  userTimeZone <- selectData(resultsource,"user.time_zone as zone",flatten = TRUE);
  userDescription <- selectData(resultsource,"user.description as description",flatten = TRUE);

  data =cbind(userName,userDescription,userId,userLocation,userLang,userCreatedAt,userFreindsCount,userStatuesCount,userFollowersCount,userTimeZone);
  save(data,file=paste0(pathToJson,stringr::str_trim(query),"user.rda"));
  xlsx::write.xlsx(x = data, file = paste0(pathToJson,"/","user.xlsx"));

  return (data);
  }
  else
  {
    print("Query returned empty result");
    return(NULL);
  }
}
#' Search google plus data
#'
#' This function searchs google plus activities using a text query, then parse the result into an R dataframe and spreedSheet xls
#'
#' @param query text query to use for the search
#' @param rootPath path to save the generated results
#' @export
searchFromGooglePlus<-function(query,rootPath="/home/dhaker/Desktop/Ghandi/")
{
  pathToJson <-paste0(rootPath,"/GooglePlus/",stringr::str_trim(query),"/");
  resultsource <- jsonSearchFomGooglePlus(pathToJson,query);
  postscount <-countData(resultsource,flatten = TRUE,rootarray = "data");
  if(postscount > 0)
  {
  #collect activity data
  activity_ids<-selectData(resultsource,"id as name",flatten = TRUE);
  activity_url<-selectData(resultsource,"url as name",flatten = TRUE);
  activity_titles<- selectData(resultsource,"title as location",flatten = TRUE);
  activity_publish_time <- selectData(resultsource,"published as published",flatten = TRUE);
  activity_update_time <- selectData(resultsource,"updated as updated",flatten = TRUE);
  activity_content <- selectData(resultsource,"object.content as content",flatten = TRUE);
  activity_type <- selectData(resultsource,"object.objectType as freinds",flatten = TRUE);
  activity_replies <- selectData(resultsource,"object.replies.totalItems as replies",flatten = TRUE);
  activity_plusoners <- selectData(resultsource,"object.plusoners.totalItems as plusoners",flatten = TRUE);
  activity_reshares <- selectData(resultsource,"object.resharers.totalItems as resharers",flatten = TRUE);
  activity_attachment_content <- selectData(resultsource,"object.attachments.0.content as attach",flatten = TRUE);
  activity_attachment_type  <- selectData(resultsource,"object.attachments.0.objectType as attach",flatten = TRUE);
  activity_attachment_url  <- selectData(resultsource,"object.attachments.0.url as description",flatten = TRUE);
  publisher_id<- selectData(resultsource,"actor.id as actor",flatten = TRUE);
  publisher_name<- selectData(resultsource,"actor.displayName as actorname",flatten = TRUE);
  publisher_url<- selectData(resultsource,"actor.url as actoruel",flatten = TRUE);
  print(paste0("Number of rows fetched = ",postscount));
  data =cbind(activity_ids,activity_url,activity_titles,activity_publish_time,
              activity_update_time,activity_content,activity_type,
              activity_replies,activity_plusoners,activity_reshares,activity_attachment_content,
              activity_attachment_type,activity_attachment_url,publisher_id,publisher_name,publisher_url);
  save(data,file=paste0(pathToJson,stringr::str_trim(query),"_Activities.rda"));
  xlsx::write.xlsx(x = data, file = paste0(pathToJson,"/","Activities.xlsx"));

  return (data);

  }
  else
  {
    print("Query returned empty result");
    return(NULL);
  }
}

#' Search Youtube data
#'
#' This function search for videos and channels from youtube using a text query, then parse the result into an R dataframe and spreedSheet xls
#'
#' @param query text query to use for the search
#' @param rootPath path to save the generated results
#'
#' @export
searchFromYouTube<-function(query,rootPath="/home/dhaker/Desktop/Ghandi/")
{
  pathToJson <-paste0(rootPath,paste0("youtube/searchResults/",stringr::str_trim(query),"/"));
  channelspath<-jsonSearchFromYoutube(pathToJson,"channel",query);
  videospath<-jsonSearchFromYoutube(pathToJson,"video",query);
  #search for channels
  channelspath<-jsonLoadByListFromYoutube(pathToJson,"channel",selectData(channelspath,"id.channelId as id",where="id.kind like 'youtube#channel'",flatten = TRUE));
  channelCount <- countData(channelspath,flatten = TRUE,rootarray = "data");
  #search for video
  videospath<-jsonLoadByListFromYoutube(pathToJson,"video",selectData(videospath,"id.videoId as id",where="id.kind like 'youtube#video'",flatten = TRUE));
  videosCount <- countData(videospath,flatten = TRUE,rootarray = "data");
  if((channelCount > 0))
  {
  channelIds<-selectData(channelspath,"id as alias",flatten=TRUE);
  channelTypes<-selectData(channelspath,"kind as alias",flatten=TRUE);
  channelPublishDate<-selectData(channelspath,"snippet.publishedAt as alias",flatten=TRUE);
  channelTitle<-selectData(channelspath,"snippet.title as alias",flatten=TRUE);
  channelDesc<-selectData(channelspath,"snippet.description as alias",flatten=TRUE);
  channelvideosCount <-selectData(channelspath,"statistics.videoCount as alias",flatten=TRUE);
  channelsubscriberCount<-selectData(channelspath,"statistics.subscriberCount as alias",flatten=TRUE);
  channelviewCount<-selectData(channelspath,"statistics.viewCount as alias",flatten=TRUE);
  channelCommentCount<-selectData(channelspath,"statistics.commentCount as alias",flatten=TRUE);

  channelFrame <-cbind(channelTypes,channelIds,channelPublishDate,channelTitle,channelDesc,
              channelvideosCount,channelsubscriberCount,channelviewCount,channelCommentCount);
  channelFrame <-data.frame(channelFrame);
  names(channelFrame)<-c("Type","Channel ID","Channel start date","Channel Title","Channel description",
                         "Number of videos","Number of subscribers","Number of views","Number of comments");
  save(channelFrame,file=paste0(pathToJson,"/channel/",stringr::str_trim(query),"_channel#list.rda"));
  xlsx::write.xlsx(x = channelFrame, file = paste0(pathToJson,"/channel/",stringr::str_trim(query),"_channel#list.xlsx"));
  }
  if (videosCount >0)
  {
    videoIds<-selectData(videospath,"id as alias",flatten=TRUE);
    videoTypes<-selectData(videospath,"kind as alias",flatten=TRUE);
    videoPublishDate<-selectData(videospath,"snippet.publishedAt as alias",flatten=TRUE);
    videoTitle<-selectData(videospath,"snippet.title as alias",flatten=TRUE);
    videoDesc<-selectData(videospath,"snippet.description as alias",flatten=TRUE);
    videoTags <-selectData(videospath,"snippet.tags as alias",flatten=TRUE);
    videoLiveBroadcast<-selectData(videospath,"snippet.liveBroadcastContent as alias",flatten=TRUE);
    videoViewCount<-selectData(videospath,"statistics.viewCount as alias",flatten=TRUE);
    videoDislikeCount<-selectData(videospath,"statistics.dislikeCount as alias",flatten=TRUE);
    videoLikeCount<-selectData(videospath,"statistics.likeCount as alias",flatten=TRUE);
    videoFavoriteCount<-selectData(videospath,"statistics.favoriteCount as alias",flatten=TRUE);
    videoCommentCount<-selectData(videospath,"statistics.commentCount as alias",flatten=TRUE);

    videoFrame <-cbind(videoTypes,videoIds,videoPublishDate,videoTitle,videoDesc,videoLiveBroadcast,
                       videoViewCount,videoTags,videoDislikeCount,videoLikeCount,videoFavoriteCount,videoCommentCount);
    videoFrame <-data.frame(videoFrame);
    names(videoFrame)<-c("Type","Video ID","Video upload date","Video Title","Video description",
                           "Live","Number of views", "Video tags","Video dislike","Video like","Video favorite", "Video Comments");
    save(videoFrame,file=paste0(pathToJson,"/video/",stringr::str_trim(query),"_video#list.rda"));
    xlsx::write.xlsx(x = videoFrame, file = paste0(pathToJson,"/video/",stringr::str_trim(query),"_video#list.xlsx"));
  }
  if( (videosCount == 0) && (channelCount == 0))
  {
    print("Query returned empty result");
  }
}

#' Collect youtube data
#'
#' This function collect data about a specific youtube element attached to videos and channels including activities, playlists, subscriptions, comments and video captions track
#' then parse it and save it into an R dataframe and an excel spredsheet file.
#'
#' @param type element type to fetch ("activity","playlist","comment","subscription","caption")
#' @param id a video id or a channel id, video id for ("caption","comment") and channel id for the rest
#' @param rootPath path to save the generated results
#' @return R dataframe representing the result node
#' @export
collectFromYoutube<-function(type,id,rootPath="/home/dhaker/Desktop/Ghandi/")
{
  pathToJson <-paste0(rootPath,paste0("/youtube#",type,"/"));
  youtubepath<-jsonLoadFromYoutube(pathToJson,type,id);
  #channel Data
  if(type=="channel")
  {
    #parsing channel activities
  activityChannelPath<-jsonLoadFromYoutube(pathToJson,"activity",id);
  activityFrame <-cbind(selectData(activityChannelPath,"id as alias",flatten=TRUE),
                        selectData(activityChannelPath,"snippet.publishedAt as alias",flatten=TRUE),
                        selectData(activityChannelPath,"snippet.title as alias",flatten=TRUE),
                        selectData(activityChannelPath,"snippet.description as alias",flatten=TRUE),
                        selectData(activityChannelPath,"snippet.channelId as alias",flatten=TRUE),
                        selectData(activityChannelPath,"snippet.channelTitle as alias",flatten=TRUE),
                        selectData(activityChannelPath,"snippet.groupId as alias",flatten=TRUE));
  activityFrame<-data.frame(activityFrame);
  names(activityFrame) <-c("ID","Time of creation","Title","Description","Channel ID","Channel Title","Group ID");

  saveDataFrame(activityFrame,paste0(pathToJson,"/",id,"/"),"activities");
  #parsing channel subscriptions
  subscriptionChannelPath<-jsonLoadFromYoutube(pathToJson,"subscription",id);
  subscriptionFrame <-cbind(selectData(activityChannelPath,"id as alias",flatten=TRUE),
                        selectData(subscriptionChannelPath,"snippet.publishedAt as alias",flatten=TRUE),
                        selectData(subscriptionChannelPath,"snippet.title as alias",flatten=TRUE),
                        selectData(subscriptionChannelPath,"snippet.description as alias",flatten=TRUE),
                        selectData(subscriptionChannelPath,"snippet.channelId as alias",flatten=TRUE),
                        selectData(subscriptionChannelPath,"snippet.channelTitle as alias",flatten=TRUE),
                        selectData(subscriptionChannelPath,"snippet.resourceId.channelId as alias",flatten=TRUE),
                        selectData(subscriptionChannelPath,"snippet.resourceId.kind as alias",flatten=TRUE));
  subscriptionFrame<-data.frame(subscriptionFrame);
  names(subscriptionFrame) <-c("ID","Time of subscription","Subscription's title","Subscription's details","Channel ID","Channel Title","Subscriped to ID","Subscriped to type");
  saveDataFrame(subscriptionFrame,paste0(pathToJson,"/",id,"/"),"subscriptions");

  #parsing channel playlists
  playlistsChannelPath<-jsonLoadFromYoutube(pathToJson,"playlist",id);
  playlistFrame <-cbind(selectData(playlistsChannelPath,"id as alias",flatten=TRUE),
                        selectData(playlistsChannelPath,"snippet.publishedAt as alias",flatten=TRUE),
                        selectData(playlistsChannelPath,"snippet.title as alias",flatten=TRUE),
                        selectData(playlistsChannelPath,"snippet.description as alias",flatten=TRUE),
                        selectData(playlistsChannelPath,"snippet.channelId as alias",flatten=TRUE),
                        selectData(playlistsChannelPath,"snippet.channelTitle as alias",flatten=TRUE),
                        selectData(playlistsChannelPath,"snippet.tags as alias",flatten=TRUE),
                        selectData(playlistsChannelPath,"snippet.localized.title as alias",flatten=TRUE),
                        selectData(playlistsChannelPath,"snippet.localized.description as alias",flatten=TRUE));
  playlistFrame<-data.frame(playlistFrame);
  names(playlistFrame)<-c("ID","Time of creation","Title","Description","Channel ID","Channel Title","Tags","Localized title","Localized description");

  saveDataFrame(playlistFrame,paste0(pathToJson,"/",id,"/"),"palylists");

  }
  else if(type=="video")
  {
    #parsing video captions
    captionChannelPath<-jsonLoadFromYoutube(pathToJson,"caption",id);
    captionFrame <-cbind(selectData(captionChannelPath,"id as alias",flatten=TRUE),
                          selectData(captionChannelPath,"snippet.videoId as alias",flatten=TRUE),
                          selectData(captionChannelPath,"snippet.lastUpdated as alias",flatten=TRUE),
                          selectData(captionChannelPath,"snippet.trackKind as alias",flatten=TRUE),
                          selectData(captionChannelPath,"snippet.language as alias",flatten=TRUE),
                          selectData(captionChannelPath,"snippet.name as alias",flatten=TRUE),
                          selectData(captionChannelPath,"snippet.audioTrackType as alias",flatten=TRUE),
                          selectData(captionChannelPath,"snippet.isCC as alias",flatten=TRUE),
                         selectData(captionChannelPath,"snippet.isLarge as alias",flatten=TRUE));
    captionFrame<-data.frame(captionFrame);
    names(captionFrame)<-c("Caption ID","Video ID","Last update","Track type","Caption language","Caption name","Audio track type","Closed caption(deaf)",
                           "Large caption text");
    saveDataFrame(captionFrame,paste0(pathToJson,"/",id,"/"),"captions");

    #parsing video comments
    commentsChannelPath<-jsonLoadFromYoutube(pathToJson,"comment",id);
    commentsFrame <-cbind(selectData(commentsChannelPath,"id as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.publishedAt as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.authorDisplayName as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.authorChannelUrl as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.authorChannelId.value as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.videoId as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.channelId as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.textDisplay as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.parentId as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.viewerRating as alias",flatten=TRUE),
                         selectData(commentsChannelPath,"snippet.topLevelComment.snippet.likeCount as alias",flatten=TRUE));
    commentsFrame<-data.frame(commentsFrame);
    names(commentsFrame)<-c("Comment ID","Comment date" ,"Author display name","Author channel url",
                            "Author channel ID","Comment Video ID","Comment channel ID","Comment text","Parent comment",
                           "Viewer rating","Number of likes");
    saveDataFrame(commentsFrame,paste0(pathToJson,"/",id,"/"),"comments");

  }
  else
  {
    print("Type should be 'Channel' or 'Video' ");
  }

}

saveDataFrame<-function(data,path,name)
{
  save(data,file=paste0(path,stringr::str_trim(name),"_dataframe.rda"));
  xlsx::write.xlsx(x = data, file = paste0(path,"/",stringr::str_trim(name),".xlsx"));
}
