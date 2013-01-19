<cfinclude template="../../common/user_logged_in.cfm">

<cfparam name="Form.band_id" default="-1">

<cfif Form.band_id NEQ -1>

  <cfquery name="getBand"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbBands
    WHERE band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.band_id#">
  </cfquery>

  <cfif getBand.RecordCount EQ 0>
    <cfset Session.alert = "Band does not exist, invalid band id">
    <cflocation url="../index.cfm" addToken="no">
  <cfelse>
  
    <!--- make sure that only the maintainer can see this page --->
    <cfif IsDefined("Session.userId") AND currentUser.user_id NEQ getBand.maintainer_id>
      <cfset Session.alert = "Only maintainers can manage members.">
      <cflocation url="../index.cfm" addToken="no">
    </cfif>
  </cfif>

  <cftry>
    
    <cfquery name="updateBandMember"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      UPDATE tbMembers
      SET name        = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.name#">,
          instrument  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.instrument#">
      WHERE band_id   = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.band_id#"> AND
            member_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.member_id#">
    </cfquery>

    <cfset Session.notice = "Successfully updated band member.">
    <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">

    <cfcatch type="any">
      <cfset Session.alert = "There was an error processing your request, please try again.">
      <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">
    </cfcatch>
  </cftry>
<cfelse>
  <cfset Session.alert = "Band does not exist, invalid band id">
  <cflocation url="../index.cfm" addToken="no">
</cfif>
