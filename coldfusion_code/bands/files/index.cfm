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

  <!--- make sure that only the maintainer can see this page --->
  <cfif getBand.RecordCount EQ 0>
    <cfset Session.alert = "Band does not exist, invalid band id">
    <cflocation url="../index.cfm" addToken="no">
  <cfelse>
    <cfif IsDefined("Session.userId") AND currentUser.user_id NEQ getBand.maintainer_id>
      <cfset Session.alert = "Only maintainers can manage members.">
      <cflocation url="../index.cfm" addToken="no">
    </cfif>
  </cfif>

  <cfquery name="getMusicFiles"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbMusicFiles
    WHERE band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.band_id#">
    ORDER BY title
  </cfquery>
<cfelse>
  <cfset Session.alert = "Band does not exist, invalid band id">
  <cflocation url="../index.cfm" addToken="no">
</cfif>

<cfset this.pageTitle = "Manage #getBand.name#'s Music Files">
<cfinclude template="../../shared/header.cfm">

<div>
  <form action="uploadMusicFile.cfm" method="post" enctype="multipart/form-data" id="music-file-form">
    <div class="control-group">
      <label class="control-label" for="title">Title</label>
      <div class="controls">
        <input type="text" name="title" id="title" placeholder="Title">
        <span class="help-block"></span>
      </div>
    </div>
    
    <div class="control-group">
      <label class="control-label" for="file">File</label>
      <div class="controls">
        <input type="file" name="upload_file" id="upload_file">
        <span class="help-block"></span>
      </div>
    </div>

    <input type="hidden" name="band_id" value="<cfoutput>#getBand.band_id#</cfoutput>">

    <div class="form-actions">
      <input type="submit" name="musicFileSubmit" value="Upload Music File" class="btn btn-primary">
      <input type="reset" value="Reset" class="btn btn-danger">
    </div>
  </form>
</div>

<br>

<cfif getMusicFiles.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Title</th>
        <th>Upload Date</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getMusicFiles">
        <tr>
          <td>#title#</td>
          <td>#DateFormat(upload_date, "mm/dd/yyyy")#</td>
          <td>
            <form action="deleteMusicFile.cfm" method="post">
              <input type="hidden" name="band_id" value="#band_id#">
              <input type="hidden" name="music_file_id" value="#music_file_id#">
              <input type="submit" name="delete" value="Delete" class="delete-action btn btn-danger" data-confirm="Are you sure you want to delete?">
            </form>
          </td>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h4>No music files have been uploaded.</h4>
</cfif>

<div><a href="../showBand.cfm?band_id=<cfoutput>#URL.band_id#</cfoutput>">Back to view band page.</a></div>

<cfinclude template="../../shared/footer.cfm">
