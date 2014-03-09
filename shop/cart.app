module shop/cart 

imports shop/product
imports user/user
imports shop/order 

access control rules 

  rule page shoppingcart() { true }

section shopping cart

  session shoppingcart {
    order -> Order 
    
    function buy(p: Product) {
      if(order == null) { order := Order{}; }
      order.buy(p);
    }
    
    function order(): Order {
      var o := order;
      o.submitted := true;
      o.submittedOn := now();
      principal().orders.add(o);
      order := Order{};     
      return o;
    }
  }
   
section view shopping cart

  page shoppingcart() {
    init{
      if(shoppingcart.order == null) { 
        shoppingcart.order := Order{};
      }
    }
    action order() { 
      if(!loggedIn()) { 
        message("Please sign in or register before placing your order");
        return signin(); 
      }
      validate(shoppingcart.order.items.length > 0, "By some products first");
      return order(shoppingcart.order());
    }
    main{
      pageHeader{ "Shopping Cart" }
      showOrder(shoppingcart.order)
      gridRow{
        gridCol(12) {
          pullRight{ 
            navigate catalogue() [class="btn btn-default"] { "Continue Shopping" } " "
            submit order() [class="btn btn-primary"]{ "Place Order" }
          }
        }
      }
    }
  }
 