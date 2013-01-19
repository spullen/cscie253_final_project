<cfinclude template="../common/user_logged_in.cfm">

<cfparam name="Form.band_id" default="-1">
<cfparam name="Form.show_id" default="-1">

<cfif Form.band_id NEQ -1 AND Form.show_id NEQ -1 AND IsDefined("Form.enterShowSubmit")>
  
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

  <cfquery name="getShow"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT show_id
    FROM tbShows
    WHERE show_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#Form.show_id#">
  </cfquery>

  <cfquery name="getShowEntry"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbEntries
    WHERE show_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#Form.show_id#"> AND
          band_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#Form.band_id#">
  </cfquery>

  <!--- make sure the band doesn't already have an entry --->
  <cfif getShowEntry.RecordCount GT 0>
    <cfset Session.alert = "Band is already entered for the show.">
    <cflocation url="viewShow.cfm?show_id=#Form.show_id#" addToken="no">
  </cfif>

  <!--- now do the insert --->
  <cftry>
    <transaction action="begin">
      <cfquery name="insertEntry"
               datasource="#Request.DSN#"
               username="#Request.username#"
               password="#Request.password#">
        INSERT INTO tbEntries(band_id, show_id) 
        VALUES(#getBand.band_id#, #getShow.show_id#)
      </cfquery>
    </transaction>

    <cfset Session.notice = "Successfully entered band into show! Good Luck!">
    <cflocation url="viewShow.cfm?show_id=#Form.show_id#" addToken="no">

    <cfcatch type="any">
      <cfset Session.alert = "There was an error processing your request, please try again.">
      <cflocation url="viewShow.cfm?show_id=#Form.show_id#" addToken="no">
    </cfcatch>
  </cftry>

<cfelse>
  <cfset Session.alert = "Invalid band or show id">
  <cflocation url="index.cfm" addToken="no">
</cfif>
