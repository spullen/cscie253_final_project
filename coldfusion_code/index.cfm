<cfif IsDefined("Session.userId")>
  <cfset this.pageTitle = "Home">
<cfelse>
  <cfset this.pageTitle = "Welcome!">
</cfif>

<cfinclude template="shared/header.cfm">

<cfif !IsDefined("Session.userId")>
  <p>
    Welcome to Battle of the Bands! Find new bands and vote for them so that they can win entrance into shows.
  </p>
  <p>
    If you have your own band, add them and try to get a spot in shows. Build your fan base!
  </p>
  <p>
    <div>If you already have an account, <a href="sessions/login.cfm">login</a> here.</div>
    <div>Or <a href="register.cfm">register</a> for an account.</div>
  </p>
</cfif>

<!--- get the next 4 upcoming shows --->
<cfquery name="getUpcomingShows"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
  
  SELECT show_id, show_date, voting_start_date, voting_end_date, venue_id, name, street, city, state, zip
  FROM (
    SELECT show_id, show_date, voting_start_date, voting_end_date, venue_id, name, street, city, state, zip, rownum r
    FROM (
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
      WHERE tbShows.show_date >= sysdate
      ORDER BY show_date ASC
    )
    WHERE rownum <= 4
  )
  WHERE r >= 1
</cfquery>

<h2>Upcoming Shows</h2>

<cfif getUpcomingShows.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Venue</th>
        <th>Venue Address</th>
        <th>Show Date</th>
        <th>Voting Start Date</th>
        <th>Voting End Date</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getUpcomingShows">
        <tr>
          <td>#name#</td>
          <td>
            #street#
            <br>
            #city#, #state# #zip#
          </td>
          <td>#DateFormat(show_date, "mm/dd/yyyy")#</td>
          <td>#DateFormat(voting_start_date, "mm/dd/yyyy")#</td>
          <td>#DateFormat(voting_end_date, "mm/dd/yyyy")#</td>
          <td><a href="shows/viewEntries.cfm?show_id=#show_id#">View Entries</a></td>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h4>No upcoming shows.</h4>
</cfif>

<cfinclude template="shared/footer.cfm">
