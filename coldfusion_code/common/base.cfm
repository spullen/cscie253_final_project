<!--- ########## Application Variables ########## --->
<cfapplication  name="Battle of the Bands"
                clientmanagement="no"
                sessionmanagement="yes"
                setclientcookies="yes"
                setdomaincookies="no"
                sessiontimeout="#CreateTimeSpan(0,1,0,0)#"
                applicationtimeout="#CreateTimeSpan(2,0,0,0)#">

<!--- ########## Oracle Variables ########## --->
<cfparam name="Request.DSN" default="cscie253">
<cfparam name="Request.username" default="spullen">
<cfparam name="Request.password" default="6201">

<cfset Request.appRoot = "/~spullen/final_project">

<cfif IsDefined("Session.userId")>
  <cfquery name="currentUser"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT * 
    FROM tbUsers 
    WHERE user_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Session.userId#">
  </cfquery>
</cfif>
