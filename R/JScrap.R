
#' Collect data from a web page
#'
#' This function scraps data from a web page and save it into an excel sheet. </<br>
#' Data such : Email, phones numbers, medias, links, social media links, and html tables
#'
#' Example of usage :
#' collectWebPageData(<path\file.xls>,"https://www.apec.fr/")
#' @param excelpath Path to the excel file
#' @param url url of the target web page11

#' @return void
#' @export

collectWebPageData<- function(excelpath,url)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jmethods(scrapInterface);
  rJava::.jcall(scrapInterface,"V","scrapInFile",excelpath);
}
#' Download images from a target page
#'
#' This function exctract all image files from a target webpage and download it into a provided directory path
#' Example of usage :
#' downloadImages(<path>,"https://www.wallpaper.com/art")
#' @param path Path to the download directory
#' @param url url of the target web page

#' @return void
#' @export
downloadImages <- function(path,url)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jcall(scrapInterface,"V","downloadImages",path);
}

#' Download documents from a target page
#'
#' This functions extract all documents files into a provided directory path
#'
#' @param path Path to the download directory
#' @param url url of the target web page

#' @return void
#' @export

downloadDocuments <- function(path,url)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  scrapInterface <- rJava::.jcall(scrapInterface,"V","downloadDocuments",path);
}

#' Download videos from a target page
#'
#' This functions extract all video files and download it into a provided directory path
#'
#' @param path Path to the download directory
#' @param url url of the target web page

#' @return void
#' @export
downloadVideos <- function(path,url)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jcall(scrapInterface,"V","downloadVideos",path);
}

#' Collect data from a whole website
#'
#' this function crawls a whole website for the requested data and save each scraped page into
#' an excel sheet, and download the availble media in a sepcific directory
#'
#' @param excelpath Path to the excel file
#' @param url url of the target web page
#' @param downloadpath path to download directory

#' @return void
#' @export
collectWebSiteData <- function(url,excelpath,downloadpath)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jcall(scrapInterface,"V","crawlSite",excelpath,downloadpath);
}
#' Collect emails from a web page
#'
#'this function extract all emails from a web page
#' @param url url of the target web page

#' @return list of emails
#' @export
collectEmails <- function(url)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jmethods(scrapInterface);
  return(rJava::.jcall(scrapInterface,"[Ljava/lang/String;","getEmails"));
}
#' Collect phone numbers from a web page
#'
#'this function exctract all phone numbers from a web page
#' @param url url of the target web page
#' @return list of phone numbers
#' @export
collectPhones <- function(url)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jmethods(scrapInterface);
  return(rJava::.jcall(scrapInterface,"[Ljava/lang/String;","getPhones"));
}

#' Collect SocialLinks
#'
#'this function exctract all social medias links from a web page
#' @param url url of the target web page
#' @return list of social media links
#' @export
collectSocialLinks <- function(url)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jmethods(scrapInterface);
  return(rJava::.jcall(scrapInterface,"[Ljava/lang/String;","getSocialLinks"));
}

#' Collect media links from a web page
#'
#'this function exctract all medias such images, videos, audio, documents.. from a web page
#' @param url url of the target web page
#' @param media media type could be : image,video,document,audio
#' @return list of medias
#' @export
collectMedias <- function(url,media)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jmethods(scrapInterface);
  return(rJava::.jcall(scrapInterface,"[Ljava/lang/String;","getMedia",media));
}

#' Collect by keyword links from a web page
#'
#'This function extract a webpage content by keyword, and return the blocs containing that keyword
#' @param url url of the target web page
#' @param key keyword to search for
#' @return list of bloc content containing that keyword
#' @export
collectContentByKey <- function(url,key)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  return(rJava::.jcall(scrapInterface,"[Ljava/lang/String;","getSearchKeyResult",key));
}

