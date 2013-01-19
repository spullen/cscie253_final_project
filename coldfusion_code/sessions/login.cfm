<cfset this.pageTitle = "Login">

<cfset this.errors = -1>

<cfparam name="Form.username" default="" type="string">
<cfif IsDefined("Form.login")>
  
  <cfquery name="getUser"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT user_id
    FROM tbUsers
    WHERE username = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.username#"> AND
          pwd = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.password#">
  </cfquery>

  <cfif getUser.RecordCount IS 1>
    
    <cfset Session.userId = getUser.user_id>
    <cfset Session.notice = "You are now logged in!">

    <cflocation url="../index.cfm" addtoken="no">

  <cfelse>
    <cfset this.errors = "Invalid Username or Password.">
  </cfif>

</cfif>

<cfinclude template="../shared/header.cfm">

<form action="login.cfm" method="post" class="form-horizontal">

  <cfif this.errors NEQ -1>
    <h4 class="form-error"><cfoutput>#this.errors#</cfoutput></h4>
  </cfif>
  
  <div class="control-group">
    <label class="control-label" for="username">Username</label>
    <div class="controls">
      <input type="text" name="username" id="username" value="<cfoutput>#Form.username#</cfoutput>" placeholder="Username">
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="password">Password</label>
    <div class="controls">
      <input type="password" name="password" id="password" placeholder="Password">
    </div>
  </div>

  <div class="form-actions">
    <input type="submit" name="login" value="Login" class="btn btn-primary">
  </div>

</form>

<cfinclude template="../shared/footer.cfm">
