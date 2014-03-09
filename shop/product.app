module shop/product

access control rules

  rule page product(p: Product, tab: String) { true }
  
  rule page catalogue() { true }

section data model

  entity Product {
    name        :: String
    price       :: Float 
    description :: WikiText
    photo       :: Image
    kind        :: String
    
    function buy() { 
      shoppingcart.buy(this);
    } 
  }
  
section product view

  page product(p: Product, tab: String) {
    main{
      pageHeader{ output(p.name) }
      case(tab) {
        "" { viewProduct(p) }
        "edit" { editProduct(p) }
      }
    }
  }
  
  template viewProduct(p: Product) {
    par{ output(p.description) }
    if(p.photo != null) { output(p.photo)[style="width:200px;"] }
    par{ "Price: " output(p.price) }
    buyButton(p) " "
    buttonNavigate(navigate(product(p, "edit"))){ iPencil " Edit" }
  }
  
  template editProduct(p: Product) {
    action save() { return product(p, ""); }
    horizontalForm{
      controlGroup("Name"){ input(p.name) }
      controlGroup("Price"){ input(p.price) }
      controlGroup("Description"){ input(p.description) }
      controlGroup("Photo"){ 
        if(p.photo != null) { output(p.photo)[style="width:200px;"] }
        input(p.photo) 
      }
      controlGroup("Kind"){ input(p.kind) }
      formActions{
        submit save() [class="btn btn-primary"] { "Save" } " "
        //navigate product(p,"") [class="btn btn-default"] { "Cancel" }
        buttonNavigate(navigate(product(p, ""))) { "Cancel" }
      }
    }
  }
  
  template buyButton(p: Product) {
    action buy() { p.buy(); }
    submitlink buy() [class="btn btn-primary"] { "Buy" }
  }
  
  template newProduct() {
    action new() { 
      var p := Product{ name := "Zo maar een naam" };
      p.save();
      return product(p, "edit");
    }
    submitlink new() [class="btn btn-default"] { iPlus " New Product" }
  }
  
section catalogue

  template productColumns(p: Product) {
    column{ navigate product(p, "") { output(p.name) } }
    column{
      if(p.photo != null) {
        navigate product(p, "") { output(p.photo)[style="width:200px;"] }
      }
    }
  }

  page catalogue() {
    main{
      pageHeader{ "Catalogue" }
      tableBordered{
        for(p: Product order by p.name asc) {
          row{
            productColumns(p)
            column{ buyButton(p) }
          }
        }
      }
      newProduct
    }
  }
