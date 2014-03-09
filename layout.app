module layout

section main template
 
  template mainResponsive() {    
    includeCSS("bootstrap/css/bootstrap.css") 
    //includeCSS("bootstrap/css/bootstrap-responsive.css")   
    //includeCSS("bootstrap/css/bootstrap-adapt.css")
    includeCSS("bootstrap-extension.css")
    includeJS("jquery.js")
    includeJS("bootstrap/js/bootstrap.js")
    includeHead("<meta name='viewport' content='width=device-width, initial-scale=1.0'>")   
    //includeHead(rendertemplate(rssLink()))
    //includeHead(rendertemplate(analytics))
    //includeHead(rendertemplate(bitterfont))
    //<link href="http://fonts.googleapis.com/css?family=Bitter" rel="stylesheet" type="text/css">
    elements
  }

  template main() { 
    mainResponsive{ 
      navbarResponsive{  
        navItems{ 
          navItem{           
            navigate catalogue() { "Catalogus" }
          }
          navItem{
            navigate shoppingcart() { iShoppingCartWhite }
          }
          if(loggedIn()) {
            navItem{
              navigate account(principal().username) { iUserWhite }
            }
            navItem{
              navigate signout() { iLogOutWhite }
            }
          } else {
            navItem{
              navigate signin() { iLogInWhite " Sign In" }
            }
          }
        }
      }
      gridContainer{
        messages
        elements 
      }
      //footer(application.footerMenu())
    }
  }
  
 

