<cfinclude template="../common/user_logged_in.cfm">

<cfparam name="URL.band_id" default="-1">

<cfif URL.band_id NEQ -1>
  <cfquery name="getBand"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbBands
    WHERE band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.band_id#">
  </cfquery>

  <cfif getBand.RecordCount IS 0>
    <cfset Session.alert = "Band does not exist, invalid show id.">
    <cflocation url="index.cfm" addToken="no">
  <cfelse>

    <cfif getBand.maintainer_id NEQ currentUser.user_id>
      <cfset Session.alert = "You are not the maintainer of this band, only maintainers can manage the band's information.">
      <cflocation url="showBand.cfm?band_id=#getBand.band_id#" addToken="no">
    </cfif>
    
    <!--- set the field values from the record returned --->
    <cfparam name="Form.band_id"    default="#URL.band_id#">
    <cfparam name="Form.name"       default="#getBand.name#">
    <cfparam name="Form.website"    default="#getBand.website#">
    <cfparam name="Form.biography"  default="#getBand.biography#">
  </cfif>

</cfif>

<cfif IsDefined("Form.bandSubmit")>
  <cfset URL.band_id = Form.band_id>

  <cftry>

    <cfquery name="updateBand"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      UPDATE tbBands
      SET name      = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.name#">,
          website   = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.website#">,
          biography = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.biography#">
      WHERE band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.band_id#">
    </cfquery>

    <cfset Session.notice = "Successfully updated band.">
    <cflocation url="showBand.cfm?band_id=#getBand.band_id#" addToken="no">   
   
    <cfcatch type="any">
      <cfset Session.alert = "There was an error processing your request, please try again.">
    </cfcatch>
  </cftry>
</cfif>


<cfset this.pageTitle = "Edit Band">
<cfinclude template="../shared/header.cfm">

<!--- Build form --->
<cfset formAction       = "editBand.cfm?band_id=#URL.band_id#">
<cfset formSubmitValue  = "Update">
<cfinclude template     = "_form.cfm">

<cfinclude template="../shared/footer.cfm">
