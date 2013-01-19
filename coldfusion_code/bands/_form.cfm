<form action="<cfoutput>#formAction#</cfoutput>" method="post" class="form-horizontal" id="band-form">

  <div class="control-group">
    <label class="control-label" for="name">Name</label>
    <div class="controls">
      <input type="text" name="name" id="name" value="<cfoutput>#Form.name#</cfoutput>" placeholder="Name">
      <span class="help-block"></span>
    </div>
  </div>
  
  <div class="control-group">
    <label class="control-label" for="website">Website</label>
    <div class="controls">
      <input type="text" name="website" id="website" value="<cfoutput>#Form.website#</cfoutput>" placeholder="Website">
      <span class="help-block"></span>
      <span class="help-block">Ex. www.website.com</span>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="biography">Biography</label>
    <div class="controls">
      <textarea id="biography" name="biography" class="span5" rows="10"><cfoutput>#Form.biography#</cfoutput></textarea>
      <span class="help-block"></span>
    </div>
  </div> 

  <cfif IsDefined("Form.band_id")>
    <input type="hidden" name="band_id" id="band_id" value="<cfoutput>#Form.band_id#</cfoutput>">
  </cfif>

  <div class="form-actions">
    <input type="submit" name="bandSubmit" value="<cfoutput>#formSubmitValue#</cfoutput>" class="btn btn-primary">
    <input type="reset" value="Reset" class="btn btn-danger">
  </div>

</form>
