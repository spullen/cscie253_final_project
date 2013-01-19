<cfset this.pageTitle = "Shows">

<cfquery name="getShows"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">

  SELECT tbShows.show_id, 
         tbShows.show_date, 
         tbShows.voting_start_date, 
         tbShows.voting_end_date, 
         tbVenues.venue_id, 
         tbVenues.name,
         tbVenues.street,
         tbVenues.city,
         tbVenues.state,
         tbVenues.zip
  FROM tbShows
  INNER JOIN tbVenues ON tbVenues.venue_id = tbShows.venue_id
  ORDER BY show_date DESC
</cfquery>

<cfinclude template="../shared/header.cfm">

<cfif IsDefined("Session.userId") AND currentUser.RecordCount EQ 1 AND currentUser.is_admin EQ 1>
  <div>
    <a href="addShow.cfm">Add New Show</a>
  </div>
  <br>
</cfif>

<cfif getShows.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Venue</th>
        <th>Venue Address</th>
        <th>Show Date</th>
        <th>Voting Start Date</th>
        <th>Voting End Date</th>
        <cfif IsDefined("Session.userId") AND currentUser.RecordCount EQ 1 AND currentUser.is_admin EQ 1>
          <th class="span1"></th>
          <th class="span1"></th>
        </cfif>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getShows">
        <tr>
          <td><a href="viewShow.cfm?show_id=#show_id#">#name#</a></td>
          <td>
            #street#
            <br>
            #city#, #state# #zip#
          </td>
          <td>#DateFormat(show_date, "mm/dd/yyyy")#</td>
          <td>#DateFormat(voting_start_date, "mm/dd/yyyy")#</td>
          <td>#DateFormat(voting_end_date, "mm/dd/yyyy")#</td>
          <cfif IsDefined("Session.userId") AND currentUser.RecordCount EQ 1 AND currentUser.is_admin EQ 1>
            <td><a href="editShow.cfm?show_id=#show_id#" class="btn btn-primary">Edit</a></td>
            <td>
              <form action="deleteShow.cfm" method="post" class="form-inline">
                <input type="hidden" name="show_id" value="#show_id#">
                <input type="submit" class="delete-action btn btn-danger" data-confirm="Are you sure you want to delete?" value="Delete">
              </form>
            </td>
          </cfif>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h4>There are no shows.</h4>
</cfif>

<cfinclude template="../shared/footer.cfm">
