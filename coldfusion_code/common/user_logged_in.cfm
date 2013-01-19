<cfif Not IsDefined("Session.userId")>
  <cfset Session.alert = "You need to be logged in to have access to this page.">
  <cflocation url="#Request.appRoot#/sessions/login.cfm" addToken="no">
</cfif>
