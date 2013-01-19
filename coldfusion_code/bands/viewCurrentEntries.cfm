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

  <cfif getBand.RecordCount EQ 0>
    <cfset Session.alert = "Band does not exist, invalid band id">
    <cflocation url="index.cfm" addToken="no">
  </cfif>

  <cfquery name="getBandCurrentEntries"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    <!--- If the user is logged in we want to get their current vote otherwise just get the basic info --->
    <cfif IsDefined("Session.userId")>
      SELECT tbEntries.entry_id,
             tbEntries.show_id,
             tbShows.voting_start_date,
             tbShows.voting_end_date,
             tbShows.show_date,
             tbVenues.name,
             tbVenues.street,
             tbVenues.city,
             tbVenues.state,
             tbVenues.zip,
             averageEntryRatingView.average_rating,
             tbVotes.vote_id,
             tbVotes.rating,
             tbVotes.user_id
      FROM tbEntries
      INNER JOIN tbShows ON tbShows.show_id = tbEntries.show_id
      INNER JOIN tbVenues ON tbVenues.venue_id = tbShows.venue_id  
      LEFT OUTER JOIN averageEntryRatingView ON averageEntryRatingView.entry_id = tbEntries.entry_id
      LEFT OUTER JOIN tbVotes ON tbVotes.entry_id = tbEntries.entry_id AND tbVotes.user_id = #currentUser.user_id#
      WHERE tbEntries.band_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#URL.band_id#"> AND
            tbShows.voting_start_date <= sysdate AND
            tbShows.voting_end_date >= sysdate 
      ORDER BY tbShows.show_date DESC
    <cfelse>
      SELECT tbEntries.entry_id,
             tbEntries.show_id,
             tbShows.voting_start_date,
             tbShows.voting_end_date,
             tbShows.show_date,
             tbVenues.name,
             tbVenues.name,
             tbVenues.street,
             tbVenues.city,
             tbVenues.state,
             tbVenues.zip,
             averageEntryRatingView.average_rating
      FROM tbEntries
      INNER JOIN tbShows ON tbShows.show_id = tbEntries.show_id
      INNER JOIN tbVenues ON tbVenues.venue_id = tbShows.venue_id  
      LEFT OUTER JOIN averageEntryRatingView ON averageEntryRatingView.entry_id = tbEntries.entry_id
      WHERE tbEntries.band_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#URL.band_id#"> AND
            tbShows.voting_start_date <= sysdate AND
            tbShows.voting_end_date >= sysdate 
      ORDER BY tbShows.show_date DESC
    </cfif>
  </cfquery>
<cfelse>
  <cfset Session.alert = "Band does not exist, invalid band id">
  <cflocation url="index.cfm" addToken="no">
</cfif>

<cfset this.pageTitle = "#getBand.name#'s Current Entries">
<cfinclude template="../shared/header.cfm">

<div>
  <cfoutput>
  <span><a href="showBand.cfm?band_id=#getBand.band_id#">Back to band's page</a> | <a href="viewPastEntries.cfm?band_id=#getBand.band_id#">View Past Entries</a></span>
  </cfoutput>
</div>
<br>

<cfif getBandCurrentEntries.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Venue Name</th>
        <th>Venue Address</th>
        <th>Average Rating</th>
        <cfif IsDefined("Session.userId")>
          <th class="span4"></th>
        </cfif>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getBandCurrentEntries">
        <tr>
          <td>#name#</td>
          <td>
            #street#
            <br>
            #city#, #state# #zip#
          </td>
          <td>#average_rating#</td>
          <cfif IsDefined("Session.userId")>
            <td>
              <form action="../shows/vote.cfm" method="post" class="form-inline">
                <input type="hidden" name="entry_id" value="#entry_id#">
                <cfif vote_id NEQ "">
                  <input type="hidden" name="vote_id" value="#vote_id#">
                </cfif>
                <select name="rating">
                  <option value="-1"></option>
                  <option value="1" <cfif rating NEQ "" AND rating EQ "1">selected="selected"</cfif>>1</option>
                  <option value="2" <cfif rating NEQ "" AND rating EQ "2">selected="selected"</cfif>>2</option>
                  <option value="3" <cfif rating NEQ "" AND rating EQ "3">selected="selected"</cfif>>3</option>
                  <option value="4" <cfif rating NEQ "" AND rating EQ "4">selected="selected"</cfif>>4</option>
                  <option value="5" <cfif rating NEQ "" AND rating EQ "5">selected="selected"</cfif>>5</option>
                </select>
                <input type="submit" name="voteSubmit" value="Vote" class="btn btn-primary">
              </form>
            </td>
          </cfif>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h4>There are no entries for this band.</h4>
</cfif>

<cfinclude template="../shared/footer.cfm">
