<cfif IsDefined("Session.userId")>
  <cfif NOT (currentUser.RecordCount EQ 1 AND currentUser.is_admin EQ 1)>
    <cfset Session.alert = "You are not authorized to view this page.">
    <cflocation url="#Request.appRoot#" addToken="no">
  </cfif>
<cfelse>
  <cfset Session.alert = "You need to be logged in to have access to this page.">
  <cflocation url="#Request.appRoot#/sessions/login.cfm" addToken="no">
</cfif>
