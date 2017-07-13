.onLoad <- function(libname, pkgname)
{
  #installing rJava
  if(! ("rJava" %in% rownames(installed.packages())) )
    {
      install.packages("rJava");
    }
  #installing stringi
  if(! ("stringi" %in% rownames(installed.packages())) )
    {
      install.packages("stringi");
    }
  if( stringi::stri_length(Sys.getenv("JAVA_HOME")) > 0)
    {
    
  rJava::.jpackage(pkgname, lib.loc=libname);
  rJava::.jinit();
  rJava::.jaddClassPath(paste0(find.package(pkgname),"/java/JScrap.jar"));
  rJava::.jaddClassPath(paste0(find.package(pkgname),"/java/JSocial.jar"));
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  socialInterface <<- rJava::.jnew("com/datacollection/utils/Rinterface");
  rJava::.jcall(scrapInterface,"V","setChromeDriverPath",getwd());
    }
  else
    print("please setup java envirement");
}
#' @export
enableDebug <- function(debug)
{
  rJava::.jcall(socialInterface,"V","setDebug",debug);
}
