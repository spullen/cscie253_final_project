<cfset this.pageTitle = "Venues">

<cfquery name="getVenues"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
  SELECT *
  FROM tbVenues
  ORDER BY name
</cfquery>

<cfinclude template="../shared/header.cfm">

<cfif IsDefined("Session.userId") AND currentUser.RecordCount EQ 1 AND currentUser.is_admin EQ 1>
  <div>
    <a href="addVenue.cfm">Add New Venue</a>
  </div>
  <br>
</cfif>

<cfif getVenues.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Name</th>
        <th>Address</th>
        <th>Website</th>
        <th>Phone</th>
        <cfif IsDefined("Session.userId") AND currentUser.RecordCount EQ 1 AND currentUser.is_admin EQ 1>
          <th class="span1"></th>
          <th class="span1"></th>
        </cfif>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getVenues">
        <tr>
          <td>#name#</td>
          <td>
            #street#
            <br>
            #city#, #state# #zip#
          </td>
          <td>#website#</td>
          <td>#phone#</td>
          <cfif IsDefined("Session.userId") AND currentUser.RecordCount EQ 1 AND currentUser.is_admin EQ 1>
            <td><a href="editVenue.cfm?venue_id=#venue_id#" class="btn btn-primary">Edit</a></td>
            <td>
              <form action="deleteVenue.cfm" method="post" class="form-inline">
                <input type="hidden" name="venue_id" value="#venue_id#">
                <input type="submit" class="delete-action btn btn-danger" data-confirm="Are you sure you want to delete?" value="Delete">
              </form>
            </td>
          </cfif>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h4>There are no venues.</h4>
</cfif>

<cfinclude template="../shared/footer.cfm">
