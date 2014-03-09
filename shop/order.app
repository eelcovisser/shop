module shop/order

access control rules

  rule page order(o: Order) { 
    principal() == o.customer
  }
  
  

section orders

  entity Order {   
    customer    : User
    items       : {OrderItem}
    submitted   : Bool (default=false)
    submittedOn : DateTime
    
    total       : Float := total() // Sum[o.price | o: Order in orders]
    
    function total(): Float { 
      var sum := 0.0;
      for(i in items) { sum := sum + i.price; }
      return sum;
    }
    
    function findItem(p: Product): OrderItem {
      for(i in items) {
        if(i.product == p) { return i; }
      }
      return null;
    }
    
    function buy(p: Product) {
      var i := findItem(p);
      if(i != null) {
        i.number := i.number + 1;  
      } else {
        var i := OrderItem{ product := p number := 1 };
        items.add(i);
      }
    }
    
    function remove(i: OrderItem) {
      items.remove(i); 
    }
    
    function submit() { 
      
    }    
  }
  
  extend entity User {
    orders -> {Order} (inverse=Order.customer)
  }
  
  enum OrderStatus {
    orderOrdered("ordered"),
    orderDelivered("delivered") 
  }
  
section order items

  entity OrderItem {
    product -> Product
    number  :: Int
    price   :: Float := number.floatValue() * product.price
    
    function adjust(number: Int) {
      this.number := this.number + number;
    }
  
  }
  
section order view

  page order(o: Order) {
    main{
      pageHeader{ "Your order of " /* output(o.submittedOn.format("MMM d, yyyy")) */ }
      showOrder(o)
    }
  }
  
  template showOrder(o: Order) {
    action incNumber(i: OrderItem) { i.adjust(1); }
    action decNumber(i: OrderItem) { i.adjust(-1); }
    action remove(i: OrderItem) { o.remove(i); }
    tableBordered{
      row{
          column{ "Product" }
          column{ "" }
          column{ "Number" }
          column{ "Price" }
          column{ "Total" }
        }
        for(i in shoppingcart.order.items) {
          row{
            productColumns(i.product)
            column{ 
              output(i.number) 
              buttonGroup{
                submitlink incNumber(i) [class="btn btn-default btn-sm"] { iChevronUp }
                submitlink decNumber(i) [class="btn btn-default btn-sm"] { iChevronDown }
                submitlink remove(i) [class="btn btn-default btn-sm"] { iRemove }
              }
            }
            column{ output(i.product.price) }
            column{ output(i.price) }
          }
        }
        row{
          column{ "Total" }
          column{ "" }
          column{ "" }
          column{ "" }
          column{ output(shoppingcart.order.total) }
        }
    }    
  }
  
section order status

  template yourorders() {
    pageHeader{ "Your Orders" }
    tableBordered{
      for(o in principal().orders where o.submitted != null) {
        row{
          column{ navigate order(o) { output(o.modified /*.format("MMM d, yyy") */) } }
          column{ output(o.total) }
        }
      }
    }
  }
  
  