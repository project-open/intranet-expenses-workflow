# /packages/intranet-expenses-workflow/www/expense-bundles-payment-2.tcl
#
# Copyright (c) 2003-2011 ]project-open[
#
# All rights reserved. Please check
# http://www.project-open.com/license/ for details.

ad_page_contract {
    Purpose: Takes commands from the /intranet/projects/view
    page and saves changes, deletes tasks etc.

    @param return_url the url to return to
    @param action "delete" and other actions.
    @param submit Not used (may be localized!)
    @task_id List of tasks to be processes

    @author frank.bergmann@project-open.com
} {
    { start_date_form "" }
    { end_date_form "" }
    { output_format "html" }
    { cost_status_id_form "" }
    { employee_id_form "" }
    payment_date:array,optional
    payed_p:array,optional
    payment_amount:array,float,optional
    payment_date:array,optional
    provider:array,integer,optional
    return_url:optional 
}

# ----------------------------------------------------------------------
# Permissions
# ---------------------------------------------------------------------


set current_user_id [ad_maybe_redirect_for_registration]

if {![im_permission $current_user_id "view_expenses_all"]} {
    ad_return_complaint "[_ intranet-core.lt_Insufficient_Privileg]" "
    <li>[_ intranet-core.lt_You_dont_have_suffici_2]"
    return
}


if { ![info exists return_url] } { set return_url "/intranet-expenses-workflow/expense-bundles-payment.tcl?[export_url_vars start_date_form end_date_form output_format cost_status_id_form employee_id_form]" }

set payed_p_list [array names payed_p]

# Append dummy task in case the list is empty
lappend all_payed_p_list 0

ns_log Notice "task-action: payed_p_list=$payed_p_list"

set currency [ad_parameter -package_id [im_package_cost_id] "DefaultCurrency" "" "EUR"]
set modified_ip_address [ns_conn peeraddr]
set last_modified_date [db_string "get current date" "select sysdate from dual"]
set note ""
set payment_type_id ""

# ----------------------------------------------------------------------
# Batch-process the elements
# ---------------------------------------------------------------------

set error_list [list]

	foreach cost_id $payed_p_list {
	    if { ![validate_textdate [textdate_to_ansi $payment_date($cost_id)]] } {
		ad_return_complaint 1 "Date doesn't have the right format.<br>"
	    }
	    if { "" != $payment_date($cost_id) && ![regexp {[0-9][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9]} [textdate_to_ansi $payment_date($cost_id)]] } {
		ad_return_complaint 1 "Start Date doesn't have the right format.
		 Current value: '$payment_date($cost_id)'"
	    } else {
     		   set payment_date_cost $payment_date($cost_id)
	    }

	    if {[catch {

		set provider_id $provider($cost_id)
		set payment_id [db_nextval "im_payments_id_seq"]

		db_dml update_cost_status "
			update	im_costs
			set	cost_status_id = [im_cost_status_paid]
			where	cost_id = :cost_id
		"
		db_dml payment_update "
	        	insert into im_payments
		        (
				payment_id,
        	        	cost_id,
				company_id,
				provider_id,
        		        received_date,
                		payment_type_id,
		                note,
        		        last_modified,
                		last_modifying_user,
	                	modified_ip_address
	        	) values (
				$payment_id,
				:cost_id,
				[im_company_internal],
				:provider_id,
				:payment_date_cost,
				:payment_type_id,
				:note,
				:last_modified_date,
				:current_user_id,
				:modified_ip_address
			)
		"
	    } errmsg]} {
		ad_return_complaint 1 "<li>[lang::message::lookup "" intranet-timesheet2-tasks.Unable_Update_Task "Unable to update expense bundle:<br><pre>$errmsg</pre>"]"
		ad_script_abort
	    }
	    # Audit the actions
	    im_audit -object_id $payment_id -action create
	    im_audit -object_id $cost_id -action update 
	}

ad_returnredirect $return_url
