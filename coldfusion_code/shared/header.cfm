<!DOCTYPE html>
<html lang="en">
<head>
  <title>
    Battle of the Bands
    <cfif IsDefined("this.pageTitle")>
      | <cfoutput>#this.pageTitle#</cfoutput>
    </cfif>
  </title>
  
  <cfoutput>
    <link rel="stylesheet" type="text/css" href="#Request.appRoot#/stylesheets/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="#Request.appRoot#/stylesheets/bootstrap-responsive.min.css">
    <link rel="stylesheet" type="text/css" href="#Request.appRoot#/stylesheets/application.css">
  </cfoutput>
</head>
<body>
  <div class="navbar navbar-fixed-top navbar-inverse">
    <div class="navbar-inner">
      <div class="container">
        <cfoutput>
          <a class="brand" href="#Request.appRoot#">Home</a>
          <ul class="nav">
            <li><a href="#Request.appRoot#/shows">Shows</a></li>
            <li><a href="#Request.appRoot#/bands">Bands</a></li>
            <li><a href="#Request.appRoot#/venues">Venues</a></li>
            <cfif IsDefined("Session.userId") AND currentUser.RecordCount EQ 1>
              <li><a href="#Request.appRoot#/bands/myBands.cfm">My Bands</a></li>
              <!--- Admin Only Stuff --->
              <cfif currentUser.is_admin EQ 1>
                <li><a href="#Request.appRoot#/users">Users</a></li>
              </cfif>
            </cfif>
          </ul>
          <ul class="nav pull-right">
            <cfif IsDefined("Session.userId") AND currentUser.RecordCount EQ 1>
              <li><a>Logged in as #currentUser.first_name# #currentUser.last_name#</a></li>
              <li><a href="#Request.appRoot#/sessions/logout.cfm">Logout</a></li>
            <cfelse>
              <li><a href="#Request.appRoot#/sessions/login.cfm">Login</a></li>
              <li><a href="#Request.appRoot#/register.cfm">Register</a></li>
            </cfif>
          </ul>
          <form action="#Request.appRoot#/bands/index.cfm" method="get" class="navbar-search pull-right">
            <input type="text" class="search-query span2" name="name" placeholder="Band Search" />
          </form>
        </cfoutput>
      </div>
    </div>
  </div>
  <div class="container">
    <div class="content">
      <div class="page-header">
        <div id="notifications">
          <cfif IsDefined("Session.notice")>
            <div class="alert alert-block alert-success notice">
              <p id="notice"><cfoutput>#Session.notice#</cfoutput></p>
            </div>
            <cfset StructDelete(Session, "notice")>
          </cfif><!--- End notice message --->

          <cfif IsDefined("Session.alert")>
            <div class="alert alert-block alert-warning alert">
              <p id="alert"><cfoutput>#Session.alert#</cfoutput></p>
            </div>
            <cfset StructDelete(Session, "alert")>
          </cfif>
        </div>
        <cfif IsDefined("this.pageTitle")>
          <h1><cfoutput>#this.pageTitle#</cfoutput></h1>
        </cfif>
      </div>
      <div class="row">
        <div class="span12">
