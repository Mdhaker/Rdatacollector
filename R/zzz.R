.onLoad <- function(libname, pkgname)
{
  rJava::.jpackage(pkgname, lib.loc=libname);
  rJava::.jinit();
  rJava::.jaddClassPath(paste0(find.package(pkgname),"/java/JScrap.jar"));
  rJava::.jaddClassPath(paste0(find.package(pkgname),"/java/JSocial.jar"));
  scrapInterface <- rJava::.jnew("utils/Rinterface",url);
  socialInterface <<- rJava::.jnew("com/datacollection/utils/Rinterface");
  rJava::.jcall(scrapInterface,"V","setChromeDriverPath",getwd());
}
#' @export
enableDebug <- function(debug)
{
  rJava::.jcall(socialInterface,"V","setDebug",debug);
}
