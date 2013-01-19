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

  <cfquery name="getBandMembers"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbMembers
    WHERE band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.band_id#">
    ORDER BY name
  </cfquery>

  <cfquery name="getBandMusicFiles"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbMusicFiles
    WHERE band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.band_id#">
  </cfquery>
<cfelse>
  <cfset Session.alert = "Band does not exist, invalid band id">
  <cflocation url="index.cfm" addToken="no">
</cfif>

<cfset this.pageTitle = "#getBand.name#">
<cfinclude template="../shared/header.cfm">

<div>
  <cfoutput>
  <span><a href="viewCurrentEntries.cfm?band_id=#getBand.band_id#">View Current Entries</a> | <a href="viewPastEntries.cfm?band_id=#getBand.band_id#">View Past Entries</a></span>
  </cfoutput>
</div>
<br>

<!--- If the band hasn't entered their website information, don't show a link to the webiste --->
<cfif getBand.website NEQ "">
  <div>
    <a href="http://<cfoutput>#getBand.website#</cfoutput>" target="_blank">Visit Band's Website</a>
  </div>
  <br>
</cfif>

<h3>Biography</h3>
<cfoutput>
  <p>#ReplaceNoCase(getBand.biography,Chr(10),'<br>','ALL')#</p>
</cfoutput>

<h3>Members</h3>
<cfif IsDefined("Session.userId") AND currentUser.user_id EQ getBand.maintainer_id>
  <a href="members/index.cfm?band_id=<cfoutput>#getBand.band_id#</cfoutput>">Manage Members</a>
</cfif>
<cfif getBandMembers.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Name</th>
        <th>Instrument</th>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getBandMembers">
        <tr>
          <td>#name#</td>
          <td>#instrument#</td>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h5>This band has no members.</h5>
</cfif>

<h3>Music Samples</h3>
<cfif IsDefined("Session.userId") AND currentUser.user_id EQ getBand.maintainer_id>
  <a href="files/index.cfm?band_id=<cfoutput>#getBand.band_id#</cfoutput>">Manage Music Files</a>
</cfif>
<cfif getBandMusicFiles.RecordCount GT 0>
  <ul>
    <cfoutput query="getBandMusicFiles">
      <li><a href="#Request.appRoot#/assets/#Trim(getBand.band_id)#/#file_path#" target="_blank">#title#</a></li>
    </cfoutput>
  </ul>
<cfelse>
  <h5>This band has no music samples.</h5>
</cfif>

<cfinclude template="../shared/footer.cfm">
