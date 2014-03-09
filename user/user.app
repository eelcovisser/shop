module user/user
  
access control rules

  principal is User with credentials email, password
  
  rule template *(*) { true }
  
  rule page confirmemail(e: EmailConfirmation) { true }
  
  rule page account(name: String) { 
    principal() == user(name)
  }
  
  rule page signin() { true }
  
  rule page signout() { true }
    
section data model
 
  entity User {
    email    : Email (id)
    username : String
    fullname : String
    password : Secret
    
    confirmation : EmailConfirmation
    
    function register() { 
      password := password.digest();
      confirmation := EmailConfirmation{};
      log(navigate(confirmemail(confirmation)));
      email confirmRegistration(this);
      save();
    }
  }
  
  function user(name: String): User { 
    var users := findUserByUsername(name);
    return if(users.length == 1) users[0] else null;
  }
  
  function principal(): User {
    return securityContext.principal;
  }
  
  entity EmailConfirmation {
    user      : User (inverse=User.confirmation)
    confirmed : Bool (default=false)
    
  }
  
  email template confirmRegistration(u: User) {
    from("eelcovis@gmail.com")
    to(u.email)
    subject("Registration")
    par{ "Hoi " output(u.fullname) ", " }
    par{ "Leuk dat je wilt registreren voor mijn web site!" }
    par{ "Je hoeft alleen nog maar deze link te clicken om je email adres te bevestigen: " }
    par{ output(navigate(confirmemail(u.confirmation))) }
    par{ "groet, " }
    par{ "Het Knutsel Frutsel team" }
  }
  
  page confirmemail(e: EmailConfirmation) {
    init{
      e.confirmed := true;
      message("Thank your for confirming your email address!");
      return signin();
    }
  }

  
section view

  template output(u: User) {
    navigate account(u.username) { output(u.fullname) }
  }

  page account(name: String) {
    var user : User
    init{
      var users := findUserByUsername(name);
      if(users.length == 1) { user := users[0]; } else { return accessDenied(); }
    }
    main{
      pageHeader{ "Account" }
      tableBordered{
        row{ column{ "Email " } column{ output(user.email) } }
        row{ column{ "Username " } column{ output(user.username) } }
        row{ column{ "Fullname " } column{ output(user.fullname) } }
      }
      yourorders
    }
  }
  
section authentication
   
  page signin() {
    main{
      login()
      register()
    }
  }
  
  override template login() { 
    var email : Email
    var password : Secret
    action signin() { 
      validate(authenticate(email, password), "Unknown email/password combination"); 
      validate(principal().confirmation.confirmed, "Email address is not confirmed"); 
      return account(principal().username);
    }
    pageHeader{ "Sign In" }
    horizontalForm{
      controlGroup("Email") {
        input(email)
      }
      controlGroup("Password") {
        input(password) {         
          validate(authenticate(email, password), "Unknown email/password combination")
        }
      }
      formActions{
        submit signin() [class="btn btn-primary"] { "Sign In" }
      }
    }
  }
  
  page signout() { 
    init{
      message("Goodbye!");
      logout();
      return root();
    }
  }
 
section registration
 
  template register() {
    var user := User{ }
    var password : Secret
    action register() { user.register(); }
    pageHeader{ "Register" }
    horizontalForm{
      controlGroup("Email") {
        input(user.email){
          validate(findUser(user.email) == null, "That email address is already in use")
        }
      }
      controlGroup("Username") {
        input(user.username){
          validate(findUserByUsername(user.username).length == 0, "That name is not available")
        }
      }
      controlGroup("Full name") {
        input(user.fullname)
      }
      controlGroup("Password") {
        input(user.password){
          validate(user.password.length() > 2, "Password should have at least 3 characters")
        }
      }
      controlGroup("Repeat password") {
        input(password){ 
          validate(user.password == password, "Password do not match")
        }
      }
      formActions{
        submit register() [class="btn btn-primary"] { "Register" }
      }
    }
  }
  
  