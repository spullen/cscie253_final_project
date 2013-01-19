<cfset this.pageTitle = "Register">

<cfparam name="Form.first_name" default="" type="string">
<cfparam name="Form.last_name" default="" type="string">
<cfparam name="Form.username" default="" type="string">
<cfparam name="Form.email" default="" type="string">
<cfparam name="Form.password" default="" type="string">

<cfif IsDefined("Form.register")>
  <cftry>
    <cftransaction action="begin">
      <cfquery name="registerUser"
               datasource="#Request.DSN#"
               username="#Request.username#"
               password="#Request.password#">
        INSERT INTO tbUsers(first_name, last_name, username, email, pwd)
        VALUES
          (
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.first_name#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.last_name#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.username#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.email#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.password#">
          )
      </cfquery>
    </cftransaction>

    <cfset Session.notice = "You have successfully registered, please login!">
    <cflocation url="#Request.appRoot#/sessions/login.cfm" addtoken="no">
  
  <cfcatch type="any">
    <cfset Session.alert = "Username or email already exist, please try a new username or check if you already have an account.">
  </cfcatch>
  </cftry>
</cfif>

<cfinclude template="shared/header.cfm">

<form action="register.cfm" method="post" class="form-horizontal" id="register-form">

  <div class="control-group">
    <label class="control-label" for="first_name">First Name</label>
    <div class="controls">
      <input type="text" name="first_name" id="first_name" value="<cfoutput>#Form.first_name#</cfoutput>" placeholder="First Name">
      <span class="help-block"></span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="last_name">Last Name</label>
    <div class="controls">
      <input type="text" name="last_name" id="last_name" value="<cfoutput>#Form.last_name#</cfoutput>" placeholder="Last Name">
      <span class="help-block"></span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="username">Username</label>
    <div class="controls">
      <input type="text" name="username" id="username" value="<cfoutput>#Form.username#</cfoutput>" placeholder="Username">
      <span class="help-block"></span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="email">Email</label>
    <div class="controls">
      <input type="text" name="email" id="email" value="<cfoutput>#Form.email#</cfoutput>" placeholder="Email">
      <span class="help-block"></span>
      <span class="help-block">example@domain.com</span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="password">Password</label>
    <div class="controls">
      <input type="password" name="password" id="password" placeholder="Password">
      <span class="help-block"></span>
    </div>
  </div>

  <div class="form-actions">
    <input type="submit" name="register" value="Register" class="btn btn-primary">
    <input type="reset" value="Reset" class="btn btn-danger">
  </div>

</form>

<cfinclude template="shared/footer.cfm">
