
/*
 * Business Process Definition: Expense Approval (expense_approval_wf)
 *
 * Auto-generated by ACS Workflow Export, version 4.3
 *
 * Context: default
 */


/*
 * Cases table
 */
create table expense_approval_wf_cases (
  case_id               integer primary key
                        references wf_cases on delete cascade
);

/* 
 * Declare the object type
 */


create function inline_0 () returns integer as '
begin
    PERFORM workflow__create_workflow (
        ''expense_approval_wf'', 
        ''Expense Approval'', 
        ''Expense Approval'', 
        '''', 
        ''expense_approval_wf_cases'',
        ''case_id''
    );

    return null;

end;' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();

        


/*****
 * Places
 *****/


    select workflow__add_place(
        'expense_approval_wf',
        'start', 
        'Ready to Modify', 
        null
    );

        

    select workflow__add_place(
        'expense_approval_wf',
        'before_approve', 
        'Ready to Approve', 
        null
    );

        

    select workflow__add_place(
        'expense_approval_wf',
        'before_approved', 
        'Ready to Approved', 
        null
    );

        

    select workflow__add_place(
        'expense_approval_wf',
        'before_deleted', 
        'Ready to Deleted', 
        null
    );

        

    select workflow__add_place(
        'expense_approval_wf',
        'end', 
        'Process finished', 
        null
    );

        
/*****
 * Roles
 *****/



	select workflow__add_role (
         'expense_approval_wf',
         'modify',
         'Modify',
         1
    );

        

	select workflow__add_role (
         'expense_approval_wf',
         'approve',
         'Approve',
         2
    );

        

	select workflow__add_role (
         'expense_approval_wf',
         'approved',
         'Approved',
         3
    );

        

	select workflow__add_role (
         'expense_approval_wf',
         'deleted',
         'Deleted',
         4
    );

        

/*****
 * Transitions
 *****/



	select workflow__add_transition (
         'expense_approval_wf',
         'modify',
         'Modify',
         'modify',
         1,
         'user'
	);
	
        

	select workflow__add_transition (
         'expense_approval_wf',
         'approve',
         'Approve',
         'approve',
         2,
         'user'
	);
	
        

	select workflow__add_transition (
         'expense_approval_wf',
         'approved',
         'Approved',
         'approved',
         3,
         'automatic'
	);
	
        

	select workflow__add_transition (
         'expense_approval_wf',
         'deleted',
         'Deleted',
         'deleted',
         4,
         'automatic'
	);
	
        

/*****
 * Arcs
 *****/



	select workflow__add_arc (
         'expense_approval_wf',
         'approve',
         'start',
         'out',
         '#',
         '',
         'Not Approve this Expense Bundle'
	);

        

	select workflow__add_arc (
         'expense_approval_wf',
         'approve',
         'before_approved',
         'out',
         'wf_callback__guard_attribute_true',
         'approve_approve_this_expense_bundle_p',
         'Approve this Expense Bundle'
	);

        

	select workflow__add_arc (
         'expense_approval_wf',
         'approve',
         'before_approve',
         'in',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'expense_approval_wf',
         'approved',
         'end',
         'out',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'expense_approval_wf',
         'approved',
         'before_approved',
         'in',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'expense_approval_wf',
         'deleted',
         'before_deleted',
         'in',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'expense_approval_wf',
         'deleted',
         'end',
         'out',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'expense_approval_wf',
         'modify',
         'start',
         'in',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'expense_approval_wf',
         'modify',
         'before_approve',
         'out',
         '',
         '',
         ''
	);

        

/*****
 * Attributes
 *****/



    select workflow__create_attribute(
        'expense_approval_wf',
        'approve_approve_this_expense_bundle_p',
        'boolean',
        'Approve this Expense Bundle',
	null,
	null,
	null,
        't',
	1,
	1,
	null,
	'generic'
    );

        

	select workflow__add_trans_attribute_map(
        	'expense_approval_wf', 
        	'approve',
        	'approve_approve_this_expense_bundle_p',
        	1
    );

        
/*****
 * Transition-role-assignment-map
 *****/



/*
 * Context/Transition info
 * (for context = default)
 */

insert into wf_context_transition_info
(context_key,
 workflow_key,
 transition_key,
 estimated_minutes,
 instructions,
 enable_callback,
 enable_custom_arg,
 fire_callback,
 fire_custom_arg,
 time_callback,
 time_custom_arg,
 deadline_callback,
 deadline_custom_arg,
 deadline_attribute_name,
 hold_timeout_callback,
 hold_timeout_custom_arg,
 notification_callback,
 notification_custom_arg,
 unassigned_callback,
 unassigned_custom_arg)
values
('default',
 'expense_approval_wf',
 'deleted',
 0,
 '',
 '',
 '',
 'im_workflow__set_object_status_id',
 '3812',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '');

insert into wf_context_transition_info
(context_key,
 workflow_key,
 transition_key,
 estimated_minutes,
 instructions,
 enable_callback,
 enable_custom_arg,
 fire_callback,
 fire_custom_arg,
 time_callback,
 time_custom_arg,
 deadline_callback,
 deadline_custom_arg,
 deadline_attribute_name,
 hold_timeout_callback,
 hold_timeout_custom_arg,
 notification_callback,
 notification_custom_arg,
 unassigned_callback,
 unassigned_custom_arg)
values
('default',
 'expense_approval_wf',
 'approved',
 0,
 '',
 '',
 '',
 'im_workflow__set_object_status_id',
 '3802',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '');

insert into wf_context_transition_info
(context_key,
 workflow_key,
 transition_key,
 estimated_minutes,
 instructions,
 enable_callback,
 enable_custom_arg,
 fire_callback,
 fire_custom_arg,
 time_callback,
 time_custom_arg,
 deadline_callback,
 deadline_custom_arg,
 deadline_attribute_name,
 hold_timeout_callback,
 hold_timeout_custom_arg,
 notification_callback,
 notification_custom_arg,
 unassigned_callback,
 unassigned_custom_arg)
values
('default',
 'expense_approval_wf',
 'modify',
 5,
 '',
 '',
 '',
 'im_workflow__set_object_status_id',
 '3816',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 'im_workflow__assign_to_owner',
 '');

insert into wf_context_transition_info
(context_key,
 workflow_key,
 transition_key,
 estimated_minutes,
 instructions,
 enable_callback,
 enable_custom_arg,
 fire_callback,
 fire_custom_arg,
 time_callback,
 time_custom_arg,
 deadline_callback,
 deadline_custom_arg,
 deadline_attribute_name,
 hold_timeout_callback,
 hold_timeout_custom_arg,
 notification_callback,
 notification_custom_arg,
 unassigned_callback,
 unassigned_custom_arg)
values
('default',
 'expense_approval_wf',
 'approve',
 5,
 '',
 '',
 '',
 'im_workflow__set_object_status_id',
 '3818',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 'im_workflow__assign_to_supervisor',
 '');



/*
 * Context/Role info
 * (for context = default)
 */



/*
 * Context Task Panels
 * (for context = default)
 */

insert into wf_context_task_panels 
(context_key,
 workflow_key,
 transition_key,
 sort_order,
 header,
 template_url,
 overrides_action_p,
 overrides_both_panels_p,
 only_display_when_started_p)
values
('default',
 'expense_approval_wf',
 'approve',
 1,
 'Approve Expense Bundle',
 '/packages/intranet-expenses-workflow/www/bundle-panel',
 'f',
 'f',
 'f');

insert into wf_context_task_panels 
(context_key,
 workflow_key,
 transition_key,
 sort_order,
 header,
 template_url,
 overrides_action_p,
 overrides_both_panels_p,
 only_display_when_started_p)
values
('default',
 'expense_approval_wf',
 'modify',
 1,
 'Modify Expense Bundle',
 '/packages/intranet-expenses-workflow/www/bundle-panel',
 'f',
 't',
 'f');


commit;

