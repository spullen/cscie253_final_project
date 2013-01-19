<cfinclude template="../common/user_logged_in.cfm">

<cfquery name="getBands"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
  SELECT *
  FROM tbBands
  WHERE maintainer_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#currentUser.user_id#">
  ORDER BY name
</cfquery>

<cfset this.pageTitle = "My Bands">
<cfinclude template="../shared/header.cfm">

<cfif getBands.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Name</th>
        <th>Website</th>
        <th></th>
        <th class="span1"></th>
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
          <td><a href="bandEntries.cfm?band_id=#band_id#">View Entries</a></td>
          <td>
            <cfif maintainer_id EQ currentUser.user_id>
              <a href="editBand.cfm?band_id=#band_id#" class="btn btn-primary">Edit</a>
            </cfif>
          </td>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h4>You currently don't have any bands. Would you like to <a href="addBand.cfm">create one?</a></h4>
</cfif>

<cfinclude template="../shared/footer.cfm">
