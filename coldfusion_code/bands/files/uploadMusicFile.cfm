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
  
    <!--- make sure that only the maintainer can see this page --->
    <cfif IsDefined("Session.userId") AND currentUser.user_id NEQ getBand.maintainer_id>
      <cfset Session.alert = "Only maintainers can manage members.">
      <cflocation url="../index.cfm" addToken="no">
    </cfif>
  </cfif>

  <cftry>

    <!--- upload the music file --->
    <cfset file_dir = "/home/courses/s/p/spullen/public_html/final_project/assets/#Trim(getBand.band_id)#">
    <cfset file_name = "#createUUID()#.mp3"> <!--- just want to store the file name, will build the path for download --->
    <cfset file_path = "#file_dir#/#file_name#">

    <!--- if the directory doesn't exist, then create it --->
    <cfif Not DirectoryExists(file_dir)>
      <cfdirectory action="create" directory="#file_dir#" mode="777">
    </cfif>
    
    <cffile action="upload" accept="audio/mpeg,audio/mp3" fileField="upload_file" destination="#file_path#" mode="777">
    
    <cftransaction action="begin">
      <cfquery name="getMusicFileId"
               datasource="#Request.DSN#"
               username="#Request.username#"
               password="#Request.password#">
        SELECT music_file_id
        FROM tbMusicFileIds a
        WHERE NOT EXISTS (
          SELECT * 
          FROM tbMusicFiles b
          WHERE a.music_file_id = b.music_file_id AND
                band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.band_id#">
        )
      </cfquery>

      <cfif getMusicFileId.RecordCount IS 0>
        <cfset Session.alert = "The maximum number of music files has been reached.">
        <cflocation url="index.cfm?band_id=#getBand.band_id#" addToken="no">          
      </cfif>
      
      <cfquery name="insertMusicFile"
               datasource="#Request.DSN#"
               username="#Request.username#"
               password="#Request.password#">
        INSERT INTO tbMusicFiles(band_id, music_file_id, title, file_path)
        VALUES
          (
            #getBand.band_id#,
            #getMusicFileId.music_file_id#,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Form.title#">,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#file_name#">
          )
      </cfquery>            
    </cftransaction>

    
    <cfset Session.notice = "Successfully uploaded music file.">
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
