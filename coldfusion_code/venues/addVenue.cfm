<cfinclude template="../common/admin_logged_in.cfm">

<cfparam name="Form.name"     default="">
<cfparam name="Form.street"   default="">
<cfparam name="Form.city"     default="">
<cfparam name="Form.state"    default="">
<cfparam name="Form.zip"      default="">
<cfparam name="Form.website"  default="">
<cfparam name="Form.phone"    default="">

<cfif IsDefined("Form.venueSubmit")>
  <cftry>
    <cfquery name="insertVenue"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      INSERT INTO tbVenues(name, street, city, state, zip, website, phone)
      VALUES
        (
          <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.name#">,
          <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.street#">,
          <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.city#">,
          <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.state#">,
          <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.zip#">,
          <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.website#">,
          <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.phone#">
        )
    </cfquery>

    <cfset Session.notice = "Successfully created venue.">
    <cflocation url="index.cfm" addToken="no">
  
  <cfcatch type="any">
    <cfset Session.alert = "There was an error processing your request, please try again.">
  </cfcatch>
  </cftry>

</cfif>

<cfset this.pageTitle = "Add Venue">
<cfinclude template="../shared/header.cfm">

<!--- Build form --->
<cfset formAction       = "addVenue.cfm">
<cfset formSubmitValue  = "Create">
<cfinclude template     = "_form.cfm">

<cfinclude template="../shared/footer.cfm">
