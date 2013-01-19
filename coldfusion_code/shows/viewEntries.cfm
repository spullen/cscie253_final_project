<cfparam name="URL.show_id" default="-1">

<cfif URL.show_id NEQ -1>
  <cfquery name="getShow"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbShows
    INNER JOIN tbVenues ON tbShows.venue_id = tbVenues.venue_id
    WHERE show_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#URL.show_id#">
  </cfquery>

  <cfif getShow.RecordCount EQ 0>
    <cfset Session.alert = "Show does not exist, invalid show id.">
    <cflocation url="index.cfm" addToken="no">
  </cfif>

  <!--- If the user is logged in, get the rating (even if it's null) --->
  <cfquery name="getShowEntries"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    <cfif IsDefined("Session.userId")>
      SELECT tbEntries.entry_id,
             tbEntries.show_id,
             tbBands.band_id,
             tbBands.name,
             averageEntryRatingView.average_rating,
             tbVotes.vote_id,
             tbVotes.rating,
             tbVotes.user_id
      FROM tbEntries
      INNER JOIN tbBands ON tbBands.band_id = tbEntries.band_id
      LEFT OUTER JOIN averageEntryRatingView ON averageEntryRatingView.entry_id = tbEntries.entry_id
      LEFT OUTER JOIN tbVotes ON tbVotes.entry_id = tbEntries.entry_id AND tbVotes.user_id = #currentUser.user_id#
      WHERE tbEntries.show_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#URL.show_id#">
      ORDER BY case when average_rating is null then 1 else 0 end, average_rating DESC
    <cfelse>
      SELECT tbEntries.entry_id,
             tbEntries.show_id,
             tbBands.band_id,
             tbBands.name,
             averageEntryRatingView.average_rating
      FROM tbEntries
      INNER JOIN tbBands ON tbBands.band_id = tbEntries.band_id
      LEFT OUTER JOIN averageEntryRatingView ON averageEntryRatingView.entry_id = tbEntries.entry_id
      WHERE show_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#URL.show_id#">
      ORDER BY case when average_rating is null then 1 else 0 end, average_rating DESC
    </cfif>
  </cfquery>

<cfelse>
  <cfset Session.alert = "Show does not exist, invalid show id.">
  <cflocation url="index.cfm" addToken="no">
</cfif>

<cfset this.pageTitle = "#getShow.name# - #DateFormat(getShow.show_date, "mm/dd/yyyy")# Entries">
<cfinclude template="../shared/header.cfm">

<div>
  <cfoutput>
  <span><a href="viewShow.cfm?show_id=#getShow.show_id#">Back to show</a> | <a href="index.cfm">Back to shows list</a></span>
  </cfoutput>
</div>
<br>

<cfif DateCompare(Now(), getShow.voting_start_date) GTE 0 AND DateCompare(Now(), getShow.voting_end_date) LTE 0>
  <div class="alert alert-block alert-success notice">
    <p id="notice">Voting Is Currently Open For This Show!</p>
  </div>
<cfelse>
  <div class="alert alert-block alert-warning alert">
    <p id="notice">Voting Is Closed For This Show.</p>
  </div>
</cfif>

<cfif getShowEntries.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Name</th>
        <th>Average Rating</th>
        <cfif IsDefined("Session.userId")>
          <th class="span4">Your Vote</th>
        </cfif>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getShowEntries">
        <tr>
          <td><a href="../bands/showBand.cfm?band_id=#band_id#">#name#</a></td>
          <td>
            <!--- if the average rating is null then the rating is 0 --->
            <cfif average_rating NEQ "">
              #average_rating#
            <cfelse>
              0
            </cfif>
          </td>
          <!--- Only show this cell if the user if logged in --->
          <cfif IsDefined("Session.userId")>
            <!--- Only allow a user to vote if show is currently in the voting period --->
            <cfif DateCompare(Now(), getShow.voting_start_date) GTE 0 AND DateCompare(Now(), getShow.voting_end_date) LTE 0>
              <td>
                <form action="vote.cfm" method="post" class="form-inline">
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
            <cfelse>
              <td>
                <cfif rating NEQ "">
                  #rating#
                <cfelse>
                  No vote given.
                </cfif>
              </td>
            </cfif>
          </cfif>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h4>There are no entries for this show.</h4>
</cfif>

<cfinclude template="../shared/footer.cfm">
