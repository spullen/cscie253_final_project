<cfinclude template="../common/admin_logged_in.cfm">

<cftry>
  
  <cfquery name="deleteShow"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    DELETE FROM tbShows WHERE show_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.show_id#">
  </cfquery>

  <cfset Session.notice = "Successfully deleted show.">

<cfcatch type="any">
  <cfset Session.alert = "Unable to delete show.">
</cfcatch>
</cftry>

<cflocation url="index.cfm" addToken="no">
