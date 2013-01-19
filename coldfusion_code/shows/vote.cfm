<cfinclude template="../common/user_logged_in.cfm">

<cfset referer = CGI.HTTP_REFERER />

<cfparam name="Form.entry_id" default="-1">
<cfparam name="Form.vote_id" default="-1">
<cfparam name="Form.rating" default="-1">

<cfif IsDefined("Form.voteSubmit")>

  <cfif Form.entry_id NEQ -1>

    <!--- Get the entry and the show --->
    <cfquery name="getEntryAndShow"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      SELECT *
      FROM tbEntries
      INNER JOIN tbShows ON tbShows.show_id = tbEntries.show_id
      WHERE entry_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.entry_id#">
    </cfquery>
    
    <!--- Make sure that the voting period is open --->
    <cfif DateCompare(Now(), getEntryAndShow.voting_start_date) GTE 0 AND DateCompare(Now(), getEntryAndShow.voting_end_date) LTE 0>

      <!--- validate that the rating exists and is in the proper range. --->
      <cfif Len(Form.rating) GT 0 AND IsNumeric(Form.rating) AND Form.rating GTE 1 AND Form.rating LTE 5>
        <cftry>
          <!--- If the vote id is not equal to -1 then this is an update otherwise insert --->
          <cfif Form.vote_id NEQ -1>

            <cfquery name="updateVote"
                     datasource="#Request.DSN#"
                     username="#Request.username#"
                     password="#Request.password#">
              UPDATE tbVotes
              SET rating = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#Form.rating#">
              WHERE vote_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.vote_id#">
            </cfquery>
            
            <cfset Session.notice = "Successfully updated vote!">
          <cfelse>

            <!--- check to see that user hasn't already voted --->
            <cfquery name="voteCount"
                     datasource="#Request.DSN#"
                     username="#Request.username#"
                     password="#Request.password#">
              SELECT *
              FROM tbVotes
              WHERE user_id   = #currentUser.user_id# AND
                    entry_id  = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.entry_id#">
            </cfquery>

            <cfif voteCount.RecordCount EQ 0>
              <cfquery name="insertVote"
                       datasource="#Request.DSN#"
                       username="#Request.username#"
                       password="#Request.password#">
                INSERT INTO tbVotes(entry_id, user_id, rating) 
                VALUES (
                  <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.entry_id#">,
                  #currentUser.user_id#,
                  <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#Form.rating#">
                )
              </cfquery>

              <cfset Session.notice = "Successfully added vote!">
            <cfelse>
              <cfset Session.alert = "There was an error processing your request, please try again.">
            </cfif>
          </cfif>

          <cfcatch type="any">
            <cfset Session.alert = "There was an error processing your request, please try again.">
          </cfcatch>
        </cftry>
      <cfelse>
        <cfset Session.alert = "Failed to add vote, please select a rating between 1 and 5.">
      </cfif><!--- End validation and insert/update --->
    <cfelse>
      <cfset Session.alert = "Voting is currently over for this show, sorry.">
    </cfif><!--- End check date range --->

  <cfelse>
    <cfset Session.alert = "Invalid entry.">
  </cfif>

<cfelse>
  <cfset Session.alert = "You can only vote through the form :-P">
</cfif>

<cflocation url="#referer#" addToken="no">
