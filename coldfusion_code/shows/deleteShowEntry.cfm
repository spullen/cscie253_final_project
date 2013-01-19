<cfinclude template="../common/user_logged_in.cfm">

<cfparam name="Form.band_id" default="-1">
<cfparam name="Form.entry_id" default="-1">
<cfparam name="Form.show_id" default="-1">

<cfif Form.band_id NEQ -1 AND Form.entry_id NEQ -1 AND Form.show_id NEQ -1 AND IsDefined("Form.deleteShowEntrySubmit")>
  
  <cfquery name="getBand"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT band_id, maintainer_id
    FROM tbBands
    WHERE band_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#Form.band_id#">
  </cfquery>

  <!--- make sure the maintainer is the one entering the band --->
  <cfif getBand.maintainer_id NEQ currentUser.user_id>
    <cfset Session.alert = "Only maintainers can enter their bands into shows.">
    <cflocation url="viewShow.cfm?show_id=#Form.show_id#" addToken="no">
  </cfif>

  <cftry>
    <transaction action="begin">
      <cfquery name="deleteEntry"
               datasource="#Request.DSN#"
               username="#Request.username#"
               password="#Request.password#">
        DELETE FROM tbEntries
        WHERE entry_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#Form.entry_id#">
      </cfquery>
    </transaction>

    <cfset Session.notice = "Successfully removed entry from show.">
    <cflocation url="viewShow.cfm?show_id=#Form.show_id#" addToken="no">

    <cfcatch type="any">
      <cfset Session.alert = "There was an error processing your request, please try again.">
      <cflocation url="viewShow.cfm?show_id=#Form.show_id#" addToken="no">
    </cfcatch>
  </cftry>

<cfelse>
  <cfset Session.alert = "Invalid show, band or entry id">
  <cflocation url="index.cfm" addToken="no">
</cfif>
