<cfinclude template="../common/admin_logged_in.cfm">

<cftry>
  
  <cfquery name="deleteVenue"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    DELETE FROM tbVenues WHERE venue_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.venue_id#">
  </cfquery>

  <cfset Session.notice = "Successfully deleted venue.">

<cfcatch type="any">
  <cfset Session.alert = "Unable to delete venue.">
</cfcatch>
</cftry>

<cflocation url="index.cfm" addToken="no">
