<cfquery name="getVenues"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
  SELECT tbVenues.venue_id, tbVenues.name
  FROM tbVenues
  ORDER BY name
</cfquery>

<form action="<cfoutput>#formAction#</cfoutput>" method="post" class="form-horizontal" id="show-form">

  <div class="control-group">
    <label class="control-label" for="venue_id">Venue</label>
    <div class="controls">
      <select name="venue_id" id="venue_id">
        <option value=""></option>
        <cfoutput query="getVenues">
          <option value="#venue_id#" <cfif Form.venue_id EQ venue_id>selected="selected"</cfif>>#name#</option>
        </cfoutput>
      </select>
      <span class="help-block"></span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="voting_start_date">Voting Start Date</label>
    <div class="controls">
      <input type="text" name="voting_start_date" id="voting_start_date" value="<cfoutput>#DateFormat(Form.voting_start_date, "mm/dd/yyyy")#</cfoutput>" placeholder="Voting Start Date">
      <span class="help-block"></span>
      <span class="help-block">Ex. mm/dd/yyyy</span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="voting_end_date">Voting End Date</label>
    <div class="controls">
      <input type="text" name="voting_end_date" id="voting_end_date" value="<cfoutput>#DateFormat(Form.voting_end_date, "mm/dd/yyyy")#</cfoutput>" placeholder="Voting End Date">
      <span class="help-block"></span>
      <span class="help-block">Ex. mm/dd/yyyy</span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="show_date">Show Date</label>
    <div class="controls">
      <input type="text" name="show_date" id="show_date" value="<cfoutput>#DateFormat(Form.show_date, "mm/dd/yyyy")#</cfoutput>" placeholder="Show Date">
      <span class="help-block"></span>
      <span class="help-block">Ex. mm/dd/yyyy</span>
    </div>
  </div>

  <cfif IsDefined("Form.show_id")>
    <input type="hidden" name="show_id" id="show_id" value="<cfoutput>#Form.show_id#</cfoutput>">
  </cfif>

  <div class="form-actions">
    <input type="submit" name="showSubmit" value="<cfoutput>#formSubmitValue#</cfoutput>" class="btn btn-primary">
    <input type="reset" value="Reset" class="btn btn-danger">
  </div>

</form>
