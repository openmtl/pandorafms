<?php 

// Pandora FMS - http://pandorafms.com
// ==================================================
// Copyright (c) 2005-2010 Artica Soluciones Tecnologicas
// Please see http://pandorafms.org for full contribution list

// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation for version 2.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// Load global vars
global $config;

require_once ($config['homedir'] . "/include/functions_alerts.php");
enterprise_include_once ('meta/include/functions_alerts_meta.php');

check_login ();

enterprise_hook('open_meta_frame');

if (! check_acl ($config['id_user'], 0, "LM")) {
	db_pandora_audit("ACL Violation",
		"Trying to access Alert Management");
	require ("general/noaccess.php");
	exit;
}

$update_command = (bool) get_parameter ('update_command');
$id = (int) get_parameter ('id');
$pure = get_parameter('pure', 0);

// Header
if (defined('METACONSOLE'))
	alerts_meta_print_header();
else
	ui_print_page_header (__('Alerts') . ' &raquo; ' .
		__('Configure alert command'), "images/gm_alerts.png", false, "alerts_config", true);


if ($update_command) {
	$id = (int) get_parameter ('id');
	$alert = alerts_get_alert_command ($id);
	if ($alert['internal']) {
		db_pandora_audit("ACL Violation", "Trying to access Alert Management");
		require ("general/noaccess.php");
		exit;
	}
	
	$name = (string) get_parameter ('name');
	$command = (string) get_parameter ('command');
	$description = (string) get_parameter ('description');
	
	$fields_descriptions = array();
	$fields_values = array();
	$info_fields = '';
	$values = array();
	for ($i=1;$i<=10;$i++) {
		$fields_descriptions[] = (string) get_parameter ('field'.$i.'_description');
		$fields_values[] = (string) get_parameter ('field'.$i.'_values');
		$info_fields .= ' Field'.$i.': ' . $fields_values[$i - 1];
	}
	
	$values['fields_values'] = io_json_mb_encode($fields_values);
	$values['fields_descriptions'] = io_json_mb_encode($fields_descriptions);
	
	$values['name'] = $name;
	$values['command'] = $command;
	$values['description'] = $description;
	
	//Check it the new name is used in the other command.
	$id_check = db_get_value ('id', 'talert_commands', 'name', $name);
	if (($id_check != $id) && (!empty($id_check))) {
		$result = '';
	}
	else {
		$result = alerts_update_alert_command ($id, $values);
		$info = 'Name: ' . $name . ' Command: ' . $command . ' Description: ' . $description. ' ' .$info_fields;
	}
	
	if ($result) {
		db_pandora_audit("Command management", "Update alert command #" . $id, false, false, $info);
	}
	else {
		db_pandora_audit("Command management", "Fail to update alert command #" . $id, false, false);
	}
	
	ui_print_result_message ($result,
		__('Successfully updated'),
		__('Could not be updated'));
}


$name = '';
$command = '';
$description = '';
$fields_descriptions = '';
$fields_values = '';
if ($id) {
	$alert = alerts_get_alert_command ($id);
	$name = $alert['name'];
	$command = $alert['command'];
	$description = $alert['description'];
	
	$fields_descriptions = $alert['fields_descriptions'];
	$fields_values = $alert['fields_values'];
}

if (!empty($fields_descriptions)) {
	$fields_descriptions = json_decode($fields_descriptions, true);
}

if (!empty($fields_values)) {
	$fields_values = json_decode($fields_values, true);
}

$table = new stdClass();
$table->width = '100%';
$table->class = 'databox filters';

if (defined('METACONSOLE')) {
	$table->width = '100%';
	$table->class = 'databox data';
	if ($id) {
		$table->head[0] = __('Update Command');
	}
	else {
		$table->head[0] = __('Create Command');
	}
	
	$table->head_colspan[0] = 4;
	$table->headstyle[0] = 'text-align: center';
}
$table->style = array ();
if (!defined('METACONSOLE')) {
	$table->style[0] = 'font-weight: bold';
	$table->style[2] = 'font-weight: bold';
}
$table->size = array ();
$table->size[0] = '20%';
$table->data = array ();

$table->colspan[0][1] = 3;
$table->data[0][0] = __('Name');
$table->data[0][2] = html_print_input_text ('name', $name, '', 35, 255, true);

$table->colspan[1][1] = 3;
$table->data[1][0] = __('Command');
$table->data[1][0] .= ui_print_help_icon ('alert_macros', true);
$table->data[1][1] = html_print_textarea ('command', 8, 30, $command, '', true);

$table->colspan[2][1] = 3;
$table->data[2][0] = __('Description');
$table->data[2][1] = html_print_textarea ('description', 10, 30, $description, '', true);

for ($i = 1; $i <= 10; $i++) {
	
	$table->data['field'.$i][0] = sprintf(__('Field %s description'), $i);
	
	// Only show help on first row
	if ($i == 1) {
		$table->data['field'.$i][0] .= ui_print_help_icon ('alert_fields_description', true);
	}
	
	if (!empty($fields_descriptions)) {
		$field_description = $fields_descriptions[$i-1];
	}
	else {
		$field_description = '';
	}
	$table->data['field'.$i][1] = html_print_input_text ('field'.$i.'_description', $field_description, '', 35, 255, true);
	
	$table->data['field'.$i][2] = sprintf(__('Field %s values'), $i);
	
	// Only show help on first row
	if ($i == 1) {
		$table->data['field'.$i][2] .= ui_print_help_icon ('alert_fields_values', true);
	}
	
	if (!empty($fields_values)) {
		$field_values = $fields_values[$i-1];
	}
	else {
		$field_values = '';
	}
	$table->data['field'.$i][3] = html_print_input_text ('field'.$i.'_values', $field_values, '', 65, 255, true);
}

echo '<form method="post" action="index.php?sec=galertas&sec2=godmode/alerts/alert_commands&pure='.$pure.'">';
html_print_table ($table);

echo '<div class="action-buttons" style="width: '.$table->width.'">';
if ($id) {
	html_print_input_hidden ('id', $id);
	html_print_input_hidden ('update_command', 1);
	html_print_submit_button (__('Update'), 'create', false, 'class="sub upd"');
}
else {
	html_print_input_hidden ('create_command', 1);
	html_print_submit_button (__('Create'), 'create', false, 'class="sub wand"');
}
echo '</div>';
echo '</form>';

enterprise_hook('close_meta_frame');

?>
