application shop

imports elib/lib
imports layout
imports shop/cart 
imports shop/order
imports shop/product
imports user/user

access control rules

  rule page root() { true }
  
section root page

  override template appname() { "Knutsel Frutsel" }

	page root(){ 
	  main{
	    well{ "Welkom bij Knutsel Frutsel" }
      <img src="/shop/images/KnutselFrutsel-Logo.jpg" />
	  }
	}
	

	
  