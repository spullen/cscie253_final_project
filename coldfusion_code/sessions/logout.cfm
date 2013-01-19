<cfset StructDelete(Session, "userId")>
<cfset Session.notice = "You are now logged out.">
<cflocation url="../index.cfm" addtoken="no">
