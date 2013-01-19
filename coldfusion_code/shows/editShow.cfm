<cfinclude template="../common/admin_logged_in.cfm">

<cfparam name="URL.show_id" default="-1">

<cfif IsDefined("Form.showSubmit")>
  <cfset URL.show_id = Form.show_id>

  <cftry>
    
    <cfset show_date = #CreateODBCDateTime(Form.show_date)#>
    <cfset voting_start_date = #CreateODBCDateTime(Form.voting_start_date)#>
    <cfset voting_end_date = #CreateODBCDateTime(Form.voting_end_date)#>

    <cfquery name="updateShow"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      UPDATE tbShows
      SET venue_id          = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.venue_id#">,
          show_date         = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#show_date#">,
          voting_start_date = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#voting_start_date#">,
          voting_end_date   = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#voting_end_date#">
      WHERE show_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.show_id#">
    </cfquery>

    <cfset Session.notice = "Successfully updated show.">
    <cflocation url="index.cfm" addToken="no">
  
  <cfcatch type="any">
    <cfset Session.alert = "There was an error processing your request, please try again.">
  </cfcatch>
  </cftry>
</cfif>

<cfif URL.show_id NEQ -1>

  <cfquery name="getShow"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbShows
    WHERE show_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.show_id#">
  </cfquery>

  <cfif getShow.RecordCount IS 0>
    <cfset Session.alert = "Show does not exist, invalid show id.">
    <cflocation url="index.cfm" addToken="no">
  <cfelse>
    
    <!--- set the field values from the record returned --->
    <cfparam name="Form.show_id"            default="#URL.show_id#">
    <cfparam name="Form.venue_id"           default="#getShow.venue_id#">
    <cfparam name="Form.show_date"          default="#getShow.show_date#">
    <cfparam name="Form.voting_start_date"  default="#getShow.voting_start_date#">
    <cfparam name="Form.voting_end_date"    default="#getShow.voting_end_date#">
  </cfif>

<cfelse>
  <cfset Session.alert = "Show does not exist, invalid show id.">
  <cflocation url="index.cfm" addToken="no">
</cfif>

<cfset this.pageTitle = "Edit Show">
<cfinclude template="../shared/header.cfm">

<!--- Build form --->
<cfset formAction       = "editShow.cfm">
<cfset formSubmitValue  = "Update">
<cfinclude template     = "_form.cfm">

<cfinclude template="../shared/footer.cfm">
