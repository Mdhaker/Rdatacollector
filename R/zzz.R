.onLoad <- function(libname, pkgname)
{
  if(pkgname %in% rownames(installed.packages()))
      {pathToLoad = find.package(pkgname);}
   else
    {pathToLoad = paste0(find.package(pkgname),"/inst");}
  #installing rJava
  if(("rJava" %in% rownames(installed.packages())) == FALSE )
    {
      install.packages("rJava");
    }
  #installing stringi
  if(("stringr" %in% rownames(installed.packages())) == FALSE)
    {
      install.packages("stringr");
    }
   #installing xlsx
  if(("xlsx" %in% rownames(installed.packages())) == FALSE)
    {
      install.packages("xlsx");
    }
  if( stringi::stri_length(Sys.getenv("JAVA_HOME")) > 0)
    {
    rJava::.jpackage(pkgname, lib.loc=libname);
    rJava::.jinit();
    rJava::.jaddClassPath(paste0(pathToLoad,"/java/JScrap.jar"));
    rJava::.jaddClassPath(paste0(pathToLoad,"/java/JSocial.jar"));
    scrapInterface <- rJava::.jnew("utils/Rinterface",url);
    socialInterface <<- rJava::.jnew("com/datacollection/utils/Rinterface",pathToLoad);
    rJava::.jcall(scrapInterface,"V","setChromeDriverPath",pathToLoad);
    }
  else
    print("please setup java envirement");
}
#' @export
enableDebug <- function(debug)
{
  rJava::.jcall(socialInterface,"V","setDebug",debug);
}
