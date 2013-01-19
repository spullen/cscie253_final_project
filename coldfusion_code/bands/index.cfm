<cfset this.pageTitle = "Bands">

<cfparam name="URL.name" default="-1">

<!--- get the bands, if the band search was entered restrict the query based on the string entered --->
<cfquery name="getBands"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
  SELECT *
  FROM tbBands
  <cfif URL.name NEQ -1>
  WHERE upper(name) LIKE upper(trim(<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#URL.name#%">))
  </cfif>
  ORDER BY name
</cfquery>

<cfinclude template="../shared/header.cfm">

<cfif IsDefined("Session.userId") AND currentUser.RecordCount EQ 1>
  <div>
    <a href="addBand.cfm">Add New Band</a>
  </div>
  <br>
</cfif>

<cfif getBands.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Name</th>
        <th>Website</th>
        <th></th>
        <cfif IsDefined("Session.userId")>
          <th class="span2"></th>
        </cfif>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getBands">
        <tr>
          <td><a href="showBand.cfm?band_id=#band_id#">#name#</a></td>
          <td>
            <cfif website EQ "">
              No Website
            <cfelse>
              <a href="http://#website#" target="_blank">Website</a>
            </cfif>
          </td>
          <td><a href="viewCurrentEntries.cfm?band_id=#band_id#">View Current Entries</a></td>
          <cfif IsDefined("Session.userId")>
            <cfif maintainer_id EQ currentUser.user_id>
              <td><a href="editBand.cfm?band_id=#band_id#" class="btn btn-primary">Edit</a></td>
            <cfelse>
              <td></td>
            </cfif>
          </cfif>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h4>There are no bands.</h4>
</cfif>

<cfinclude template="../shared/footer.cfm">
