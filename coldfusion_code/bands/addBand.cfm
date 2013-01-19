<cfinclude template="../common/user_logged_in.cfm">

<cfparam name="Form.name"       default="">
<cfparam name="Form.website"    default="">
<cfparam name="Form.biography"  default="">

<cfif IsDefined("Form.bandSubmit")>
  <cftry>

    <cftransaction action="begin">
      <cfquery name="insertBand"
               datasource="#Request.DSN#"
               username="#Request.username#"
               password="#Request.password#">
        INSERT INTO tbBands(maintainer_id, name, website, biography)
        VALUES
          (
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#currentUser.user_id#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.name#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.website#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.biography#">
          )
      </cfquery>

      <cfquery name="lastBandId"
               datasource="#Request.DSN#"
               username="#Request.username#"
               password="#Request.password#">
        SELECT bandsSeq.currval FROM dual
      </cfquery>
    </cftransaction>
    
    <cfset Session.notice = "Successfully created band.">
    <cflocation url="showBand.cfm?band_id=#lastBandId.currval#" addToken="no">
  
    <cfcatch type="any">
      <cfset Session.alert = "There was an error processing your request, please try again.">
    </cfcatch>
  </cftry>

</cfif>

<cfset this.pageTitle = "Add Band">
<cfinclude template="../shared/header.cfm">

<!--- Build form --->
<cfset formAction       = "addBand.cfm">
<cfset formSubmitValue  = "Create">
<cfinclude template     = "_form.cfm">

<cfinclude template="../shared/footer.cfm">
