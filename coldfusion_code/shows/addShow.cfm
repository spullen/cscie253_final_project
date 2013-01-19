<cfinclude template="../common/admin_logged_in.cfm">

<cfquery name="getVenuesCount"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
  SELECT count(*) as venuesCount
  FROM tbVenues
</cfquery>

<!--- If there are no venues, then we must create one, shows belong to venues --->
<cfif getVenuesCount.venuesCount IS 0>
  <cfset Session.alert = "No venues exist, you must create a venue before creating a show.">
  <cflocation url="#Request.appRoot#/venues/addVenue.cfm">
</cfif>

<cfparam name="Form.venue_id"           default="">
<cfparam name="Form.show_date"          default="">
<cfparam name="Form.voting_start_date"  default="">
<cfparam name="Form.voting_end_date"    default="">

<cfif IsDefined("Form.showSubmit")>
  <cftry>
    
    <cfset show_date = #CreateODBCDateTime(Form.show_date)#>
    <cfset voting_start_date = #CreateODBCDateTime(Form.voting_start_date)#>
    <cfset voting_end_date = #CreateODBCDateTime(Form.voting_end_date)#>

    <cfquery name="insertShow"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      INSERT INTO tbShows(venue_id, show_date, voting_start_date, voting_end_date)
      VALUES
        (
          <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.venue_id#">,
          <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#show_date#">,
          <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#voting_start_date#">,
          <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#voting_end_date#">
        )
    </cfquery>

    <cfset Session.notice = "Successfully created show.">
    <cflocation url="index.cfm" addToken="no">
  
  <cfcatch type="any">
    <cfset Session.alert = "There was an error processing your request, please try again.<br>Make sure the voting start and end dates don't overlap with other shows.">
  </cfcatch>
  </cftry>
</cfif>

<cfset this.pageTitle = "Add Show">
<cfinclude template="../shared/header.cfm">

<!--- Build form --->
<cfset formAction       = "addShow.cfm">
<cfset formSubmitValue  = "Create">
<cfinclude template     = "_form.cfm">

<cfinclude template="../shared/footer.cfm">
