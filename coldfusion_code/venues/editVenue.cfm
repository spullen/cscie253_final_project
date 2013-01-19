<cfinclude template="../common/admin_logged_in.cfm">

<cfparam name="URL.venue_id" default="-1">

<cfif IsDefined("Form.venueSubmit")>
  <cfset URL.venue_id = Form.venue_id>

  <cftry>
    <cfquery name="updateVenue"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      UPDATE tbVenues
      SET name    = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.name#">,
          street  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.street#">,
          city    = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.city#">,
          state   = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.state#">,
          zip     = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.zip#">,
          website = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.website#">,
          phone   = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.phone#">
      WHERE venue_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.venue_id#">
    </cfquery>

    <cfset Session.notice = "Successfully updated venue.">
    <cflocation url="index.cfm" addToken="no">
  
  <cfcatch type="any">
    <cfset Session.alert = "There was an error processing your request, please try again.">
  </cfcatch>
  </cftry>
</cfif>

<cfif URL.venue_id NEQ -1>

  <cfquery name="getVenue"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbVenues
    WHERE venue_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.venue_id#">
  </cfquery>

  <cfif getVenue.RecordCount IS 0>
    <cfset Session.alert = "Venue does not exist, invalid venue id.">
    <cflocation url="index.cfm" addToken="no">
  <cfelse>
    
    <!--- set the field values from the record returned --->
    <cfparam name="Form.venue_id" default="#URL.venue_id#">
    <cfparam name="Form.name"     default="#getVenue.name#">
    <cfparam name="Form.street"   default="#getVenue.street#">
    <cfparam name="Form.city"     default="#getVenue.city#">
    <cfparam name="Form.state"    default="#getVenue.state#">
    <cfparam name="Form.zip"      default="#getVenue.zip#">
    <cfparam name="Form.website"  default="#getVenue.website#">
    <cfparam name="Form.phone"    default="#getVenue.phone#">
  </cfif>

<cfelse>
  <cfset Session.alert = "Venue does not exist, invalid venue id.">
  <cflocation url="index.cfm" addToken="no">
</cfif>

<cfset this.pageTitle = "Edit Venue">
<cfinclude template="../shared/header.cfm">

<div>
  <a href="index.cfm">Back</a>
</div>
<br>

<!--- Build form --->
<cfset formAction       = "editVenue.cfm">
<cfset formSubmitValue  = "Update">
<cfinclude template     = "_form.cfm">

<cfinclude template="../shared/footer.cfm">
