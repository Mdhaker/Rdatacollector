
#' Collect data from a web page
#'
#' This function scraps data from a web page and save it into an excel sheet.
#'
#' Data such : Email, phones numbers, medias, links, social media links, and html tables
#'
#' @Example collectWebPageData(<path\file.xls>,"https://www.apec.fr/")
#' @param excelpath Path to the excel file
#' @param url url of the target web page

#' @return void
#' @export

collectWebPageData<- function(excelpath,url)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jmethods(scrapInterface);
  rJava::.jcall(scrapInterface,"V","scrapInFile",excelpath);
}

#' Collect data from a whole website
#'
#' collectWebSiteData crawls a whole website for the requested data and save each scraped page into
#' an excel sheet, and download the availble media files in a sepcific directory
#'
#' @param url url of the target web page
#' @param downloadpath path to the downloaded media files
#' @param excelpath Path to the excel file
#' @return void
#' @export
collectWebSiteData <- function(url,excelpath,downloadpath)
{
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  rJava::.jcall(scrapInterface,"V","crawlSite",excelpath,downloadpath);
}
#' Collect emails from a web page
#'
#'this function extract all emails from a web page and return it as an R list
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
#'this function extract all phone numbers from a web page and return it as an R list
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
#'this function extract all social medias links from a web page and return it as an R list
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
#'this function extract all medias such images, videos, audio, documents.. from a web page
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

