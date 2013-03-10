module product

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
    output(p.photo)
    par{ "Price: " output(p.price) }
    buyButton(p) " "
    navigate product(p, "edit") { iPencil " Edit" }
  }
  
  template editProduct(p: Product) {
    action save() { return product(p, ""); }
    horizontalForm{
      controlGroup("Name"){ input(p.name) }
      controlGroup("Price"){ input(p.price) }
      controlGroup("Description"){ input(p.description) }
      controlGroup("Photo"){ input(p.photo) }
      controlGroup("Kind"){ input(p.kind) }
      formActions{
        submitlink save() [class="btn btn-primary"] { "Save" } " "
        navigate product(p,"") [class="btn"] { "Cancel" }
      }
    }
  }
  
  template buyButton(p: Product) {
    action buy() { p.buy(); }
    submitlink buy() [class="btn"] { "Buy" }
  }
  
  template newProduct() {
    action new() { 
      var p := Product{ name := "Zo maar een naam" };
      p.save();
      return product(p, "edit");
    }
    submitlink new() [class="btn"] { iPlus " New Product" }
  }
  
section catalogue

  template productColumns(p: Product) {
    column{ navigate product(p, "") { output(p.name) } }
    column{
      if(p.photo != null) {
        navigate product(p, "") { output(p.photo) }
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
