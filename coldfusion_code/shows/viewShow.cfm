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

<cfelse>
  <cfset Session.alert = "Show does not exist, invalid show id.">
  <cflocation url="index.cfm" addToken="no">
</cfif>

<cfset this.pageTitle = "#getShow.name# - #DateFormat(getShow.show_date, "mm/dd/yyyy")#">
<cfinclude template="../shared/header.cfm">

<div>
  <a href="index.cfm">Back to show list.</a>
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

<div>
  <cfoutput>
  <h5><a href="viewEntries.cfm?show_id=#getShow.show_id#">View Entries</a></h5>
  </cfoutput>
</div>

<div>
  <cfoutput>
  <dl>
    <dt>Venue</dt>
    <dd>#getShow.name#</dd>

    <dt>Venue Address</dt>
    <dd>
      #getShow.street#
      <br>
      #getShow.city#, #getShow.state# #getShow.zip#
    </dd>
    
    <dt>Show Date</dt>
    <dd>#DateFormat(getShow.show_date, "mm/dd/yyyy")#</dd>

    <dt>Voting Start Date</dt>
    <dd>#DateFormat(getShow.voting_start_date, "mm/dd/yyyy")#</dd>
    
    <dt>Voting End Date</dt>
    <dd>#DateFormat(getShow.voting_end_date, "mm/dd/yyyy")#</dd>
  </dl>
  </cfoutput>
</div>

<!--- 
  If the user is logged in and the current date is less than or equal to 0
  then retrieve all of the bands that the user maintains so they can enter
  the band into the show.
--->
<cfif IsDefined("Session.userId")>
  <cfif DateCompare(Now(), getShow.voting_end_date) LTE 0>
    <cfquery name="getBandsForEntry"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      SELECT *
      FROM tbBands a
      WHERE maintainer_id = #currentUser.user_id# AND
            NOT EXISTS (
              SELECT * FROM tbEntries b
              WHERE b.band_id = a.band_id AND
                    b.show_id = #getShow.show_id#
            )
    </cfquery>

    <cfquery name="getEnteredBands"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      SELECT *
      FROM tbBands
      INNER JOIN tbEntries ON tbBands.band_id = tbEntries.band_id
      WHERE maintainer_id = #currentUser.user_id# AND
            show_id       = #getShow.show_id#
    </cfquery>

    <cfif getBandsForEntry.RecordCount GT 0>
      <h5>Bands that are not currently entered into the show</h5>
      <table class="table table-striped table-bordered">
        <thead>
          <tr>
            <th>Name</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getBandsForEntry">
            <tr>
              <td><a href="../bands/showBand.cfm?band_id=#band_id#">#name#</a></td>
              <td>
                <form action="enterShow.cfm" method="post">
                  <input type="hidden" name="band_id" value="#band_id#">
                  <input type="hidden" name="show_id" value="#getShow.show_id#">
                  <input type="submit" name="enterShowSubmit" value="Enter" class="btn btn-primary">
                </form>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    <cfelse>
      You don't have any bands to enter, would you like to <a href="../bands/addBand.cfm">add one?</a>
    </cfif>

    <cfif getEnteredBands.RecordCount GT 0>
      <br><br>
      <h5>Your bands that are entered into the show.</h5>
      <table class="table table-striped table-bordered">
        <thead>
          <tr>
            <th>Name</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getEnteredBands">
            <tr>
              <td><a href="../bands/showBand.cfm?band_id=#band_id#">#name#</a></td>
              <td>
                <form action="deleteShowEntry.cfm" method="post">
                  <input type="hidden" name="entry_id" value="#entry_id#">
                  <input type="hidden" name="band_id" value="#band_id#">
                  <input type="hidden" name="show_id" value="#show_id#">
                  <input type="submit" name="deleteShowEntrySubmit" value="Remove Entry" class="delete-action btn btn-danger" data-confirm="Are you sure you want to remove entry from show?">
                </form>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    <cfelse>
      <h5>You don't have any bands entered.</h5>
    </cfif>
  </cfif>
</cfif>

<cfinclude template="../shared/footer.cfm">
