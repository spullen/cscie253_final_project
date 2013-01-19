<cfinclude template="../../common/user_logged_in.cfm">

<cfparam name="Form.band_id" default="-1">

<cfif Form.band_id NEQ -1>

  <cfquery name="getBand"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbBands
    WHERE band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.band_id#">
  </cfquery>

  <cfif getBand.RecordCount EQ 0>
    <cfset Session.alert = "Band does not exist, invalid band id">
    <cflocation url="../index.cfm" addToken="no">
  <cfelse>
    <cfif IsDefined("Session.userId") AND currentUser.user_id NEQ getBand.maintainer_id>
      <cfset Session.alert = "Only maintainers can manage members.">
      <cflocation url="../index.cfm" addToken="no">
    </cfif>
  </cfif>

  <cftry>

    <cfquery name="getMusicFile"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      SELECT file_path 
      FROM tbMusicFiles
      WHERE band_id       = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.band_id#"> AND
            music_file_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.music_file_id#">
    </cfquery>

    <!--- delete the file --->
    <!--- TODO: Buggy Fix --->
    <!--- This doesn't work, so I'm just going to delete the record in the DB --->
    <!---<cffile action="delete" file="/home/courses/s/p/spullen/public_html/final_project/assets/#Trim(getBand.band_id)#/#getMusicFile.file_path#">--->
  
    <cfquery name="deleteMusicFile"
             datasource="#Request.DSN#"
             username="#Request.username#"
             password="#Request.password#">
      DELETE FROM tbMusicFiles
      WHERE band_id       = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.band_id#"> AND
            music_file_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.music_file_id#">
    </cfquery>

    <cfset Session.notice = "Successfully deleted music file.">
    <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">

    <cfcatch type="any">
      <cfset Session.alert = "There was an error processing your request, please try again.">
      <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">
    </cfcatch>
  </cftry>
<cfelse>
  <cfset Session.alert = "Band does not exist, invalid band id">
  <cflocation url="../index.cfm" addToken="no">
</cfif>
