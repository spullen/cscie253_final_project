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

  <cfquery name="getBandMembers"
           datasource="#Request.DSN#"
           username="#Request.username#"
           password="#Request.password#">
    SELECT *
    FROM tbMembers
    WHERE band_id = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#URL.band_id#">
    ORDER BY name
  </cfquery>
<cfelse>
  <cfset Session.alert = "Band does not exist, invalid band id">
  <cflocation url="../index.cfm" addToken="no">
</cfif>

<cfset this.pageTitle = "Manage #getBand.name#'s Members">
<cfinclude template="../../shared/header.cfm">

<div>
  <form action="addMember.cfm?band_id=<cfoutput>#getBand.band_id#</cfoutput>" method="post" class="band-member-form">
    <div class="control-group">
      <label class="control-label" for="name">Name</label>
      <div class="controls">
        <input type="text" name="name" id="name" placeholder="Name">
        <span class="help-block"></span>
      </div>
    </div>
    
    <div class="control-group">
      <label class="control-label" for="instrument">Instrument/Role</label>
      <div class="controls">
        <input type="text" name="instrument" id="instrument" placeholder="Instrument/Role">
        <span class="help-block"></span>
      </div>
    </div>

    <div class="form-actions">
      <input type="submit" name="bandMemberSubmit" value="Add Band Member" class="btn btn-primary">
      <input type="reset" value="Reset" class="btn btn-danger">
    </div>
  </form>
</div>
<br>

<cfif getBandMembers.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Name</th>
        <th>Instrument</th>
        <th></th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getBandMembers">
        <tr>
          <td>
            <form action="updateMember.cfm" method="post" class="band-member-form">
            <div class="control-group">
              <div class="controls">
                <input type="text" name="name" id="name" value="#name#">
                <span class="help-block"></span>
              </div>
            </div>
          </td>
          <td>
            <div class="control-group">
              <div class="controls">
                <input type="text" name="instrument" id="instrument" value="#instrument#">
                <span class="help-block"></span>
              </div>
            </div>            
          </td>
          <td>
            <input type="hidden" name="band_id" value="#band_id#">
            <input type="hidden" name="member_id" value="#member_id#">
            <input type="submit" name="update" value="Update" class="btn btn-primary">
            <!--- Bug: for some reason the fields won't validate and show errors, I think it's because I tried having both the create and update fields on one page and it's getting confused --->
            </form><!-- end update form -->
          </td>
          <td>
            <form action="deleteMember.cfm" method="post" class="form-inline">
              <input type="hidden" name="band_id" value="#band_id#">
              <input type="hidden" name="member_id" value="#member_id#">
              <input type="submit" name="delete" value="Delete" class="delete-action btn btn-danger" data-confirm="Are you sure you want to delete?">
            </form><!-- end delete form -->
          </td>
        </tr>
      </cfoutput>
    </tbody>
  </table>
<cfelse>
  <h4>No Band Members.</h4>
</cfif>

<div><a href="../showBand.cfm?band_id=<cfoutput>#URL.band_id#</cfoutput>">Back to view band page.</a></div>

<cfinclude template="../../shared/footer.cfm">
