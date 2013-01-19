<form action="<cfoutput>#formAction#</cfoutput>" method="post" class="form-horizontal" id="venue-form">

  <div class="control-group">
    <label class="control-label" for="name">Name</label>
    <div class="controls">
      <input type="text" name="name" id="name" value="<cfoutput>#Form.name#</cfoutput>" placeholder="Name">
      <span class="help-block"></span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="street">Street</label>
    <div class="controls">
      <input type="text" name="street" id="street" value="<cfoutput>#Form.street#</cfoutput>" placeholder="Street">
      <span class="help-block"></span>
      <span class="help-block">Ex. 123 StName Ave.</span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="city">City</label>
    <div class="controls">
      <input type="text" name="city" id="city" value="<cfoutput>#Form.city#</cfoutput>" placeholder="City">
      <span class="help-block"></span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="state">State</label>
    <div class="controls">
      <input type="text" name="state" id="state" value="<cfoutput>#Form.state#</cfoutput>" placeholder="State">
      <span class="help-block"></span>
      <span class="help-block">Ex. MA, NY CA</span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="zip">Zip</label>
    <div class="controls">
      <input type="text" name="zip" id="zip" value="<cfoutput>#Form.zip#</cfoutput>" placeholder="Zip">
      <span class="help-block"></span>
      <span class="help-block">Ex. 99999</span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="website">Website</label>
    <div class="controls">
      <input type="text" name="website" id="website" value="<cfoutput>#Form.website#</cfoutput>" placeholder="Website">
      <span class="help-block"></span>
      <span class="help-block">Ex. www.sitename.com</span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="phone">Phone</label>
    <div class="controls">
      <input type="text" name="phone" id="phone" value="<cfoutput>#Form.phone#</cfoutput>" placeholder="Phone">
      <span class="help-block"></span>
      <span class="help-block">Ex. 999-999-9999</span>
    </div>
  </div>

  <cfif IsDefined("Form.venue_id")>
    <input type="hidden" name="venue_id" id="venue_id" value="<cfoutput>#Form.venue_id#</cfoutput>">
  </cfif>

  <div class="form-actions">
    <input type="submit" name="venueSubmit" value="<cfoutput>#formSubmitValue#</cfoutput>" class="btn btn-primary">
    <input type="reset" value="Reset" class="btn btn-danger">
  </div>

</form>
