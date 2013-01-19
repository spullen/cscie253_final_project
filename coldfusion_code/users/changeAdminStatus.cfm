<cfinclude template="../common/admin_logged_in.cfm">

<cftry>
  <cfquery name="getSelectedUser"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT user_id, username, is_admin FROM tbUsers WHERE user_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.user_id#">
  </cfquery>

  <cfif getSelectedUser.is_admin EQ 1>
    <cfset isAdmin = 0>
  <cfelse>
    <cfset isAdmin = 1>
  </cfif>

  <cfquery name="changeAdminStatus"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    UPDATE tbUsers
    SET is_admin = #isAdmin#
    WHERE user_id = #getSelectedUser.user_id#
  </cfquery>

  <cfset Session.notice = "Successfully update the admin status of #getSelectedUser.username#">

<cfcatch type="any">
  <cfset Session.alert = "Unable to process the request, please try again later.">
</cfcatch>
</cftry>

<cflocation url="index.cfm" addToken="no">
