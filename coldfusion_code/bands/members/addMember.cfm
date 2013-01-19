<cfinclude template="../../common/user_logged_in.cfm">

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
    <cflocation url="../index.cfm" addToken="no">
  <cfelse>

    <!--- make sure that only the maintainer can see this page --->
    <cfif IsDefined("Session.userId") AND currentUser.user_id NEQ getBand.maintainer_id>
      <cfset Session.alert = "Only maintainers can manage members.">
      <cflocation url="../index.cfm" addToken="no">
    <cfelse>
      
      <cfif IsDefined("Form.bandMemberSubmit")>
        
        <cftry>
          <cftransaction action="begin">
            <cfquery name="getBandMemberId"
                     datasource="#Request.DSN#"
                     username="#Request.username#"
                     password="#Request.password#">
              SELECT member_id
              FROM tbMemberIds a
              WHERE NOT EXISTS (
                SELECT * 
                FROM tbMembers b
                WHERE a.member_id = b.member_id AND
                      band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.band_id#">
              )
            </cfquery>

            <cfif getBandMemberId.RecordCount IS 0>
              <cfset Session.alert = "The maximum number of band members has been reached.">
              <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">          
            </cfif>
              
            <cfquery name="insertBandMember"
                     datasource="#Request.DSN#"
                     username="#Request.username#"
                     password="#Request.password#">
              INSERT INTO tbMembers(band_id, member_id, name, instrument)
              VALUES
                (
                  <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.band_id#">,
                  #getBandMemberId.member_id#,
                  <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.name#">,
                  <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.instrument#">
                )
            </cfquery>            
          </cftransaction>

          <!--- The stored proc is giving me problems, I have no idea what LONG column it is talking about... --->
          <!--- ORA-01461: can bind a LONG value only for insert into a LONG column --->
          <!--- Commenting this out until I can figure out what LONG column it is talking about
          <cfstoredproc procedure="add_band_member"
                        datasource="#Request.DSN#"
                        username="#Request.username#"
                        password="#Request.password#">
            <cfprocparam cfsqltype="CF_SQL_CHAR" type="in" value="#URL.band_id#" maxLength="4">
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#Form.name#" maxLength="40">
            <cfprocparam cfsqltype="CF_SQL_VARCHAR" type="in" value="#Form.instrument#" maxLength="40">
            <cfprocparam cfsqltype="CF_SQL_NUMBER" type="out" variable="memberId">
          </cfstoredproc>

          <cfif memberId EQ "-1">
            <cfset Session.alert = "The maximum number of band members has been reached.">
            <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">
          </cfif>
          --->

          <cfset Session.notice = "Successfully created band member.">
          <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">

          <cfcatch type="any">
            <cfset Session.alert = "There was an error processing your request, please try again.">
            <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">
          </cfcatch>
        </cftry>

      <cfelse>
        <cfset Session.alert = "Form must be submitted in order to add band member.">
        <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">
      </cfif>

    </cfif>
  </cfif>
<cfelse>
  <cfset Session.alert = "Band does not exist, invalid band id">
  <cflocation url="../index.cfm" addToken="no">
</cfif>
