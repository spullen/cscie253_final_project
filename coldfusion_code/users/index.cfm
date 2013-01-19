<cfinclude template="../common/admin_logged_in.cfm">

<cfquery name="getVenues"
         datasource="#Request.DSN#"
         username="#Request.username#"
         password="#Request.password#">
  SELECT *
  FROM tbUsers
  ORDER BY last_name, first_name
</cfquery>

<cfset this.pageTitle = "Users">
<cfinclude template="../shared/header.cfm">

<cfif getVenues.RecordCount GT 0>
  <table class="table table-striped table-bordered">
    <thead>
      <tr>
        <th>Name</th>
        <th>Username</th>
        <th>Email</th>
        <th>Is Admin?</th>
        <th class="span3"></th>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="getVenues">
        <tr>
          <td>#last_name#, #first_name#</td>
          <td>#username#</td>
          <td>#email#</td>
          <td>
            <cfif is_admin EQ 1>
              Yes
            <cfelse>
              No
            </cfif>
          </td>
          <td>
            <form action="changeAdminStatus.cfm" method="post" class="form-inline">
              <input type="hidden" name="user_id" value="#user_id#">
              <input type="submit" value="Swap Admin Status" class="btn btn-primary">
            </form>
          </td>
        </tr>
      </cfoutput>
    </tbody>
<cfelse>
  <h4>There are no users? Wait how are you here?</h4>
</cfif>

<cfinclude template="../shared/footer.cfm">
