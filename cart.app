module cart

imports product

section data model

  entity Order {
    product -> Product
    amount  :: Int
    price   :: Float := amount.floatValue() * product.price
  }

  session shoppingcart {
    orders -> List<Order>
    total  :: Float := total() // Sum[o.price | o: Order in orders]
    function total(): Float { 
      var sum := 0.0;
      for(o in orders) { 
        sum := sum + o.price;
      }
      return sum;
    }
    function buy(p: Product) {
      for(o in orders) {
        if(o.product == p) { 
          o.amount := o.amount + 1; 
          return;
        }
      }
      var o := Order{ product := p amount := 1 };
      orders.add(o);
    }
  }
 
section view shopping cart

  page shoppingcart() {
    main{
      pageHeader{ "Shopping Cart" }
      tableBordered{
        row{
          column{ "Product" }
          column{ "" }
          column{ "Amount" }
          column{ "Price" }
          column{ "Total" }
        }
        for(o in shoppingcart.orders) {
          row{
            productColumns(o.product)
            column{ output(o.amount) }
            column{ output(o.product.price) }
            column{ output(o.price) }
          }
        }
        row{
          column{ "Total" }
          column{ "" }
          column{ "" }
          column{ "" }
          column{ output(shoppingcart.total) }
        }
      }
    }
  }