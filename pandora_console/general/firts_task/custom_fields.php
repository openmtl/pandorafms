<?php
global $config;
check_login ();
ui_require_css_file ('firts_task');
?>
<?php 

ui_print_info_message ( array('no_close'=>true, 'message'=>  __('There are no custom fields defined yet.') ) ); 
?>

<div class="new_task">
	<div class="image_task">
		<?php echo html_print_image('images/firts_task/icono_grande_reconserver.png', true, array("title" => __('Custom Graphs')));?>
	</div>
	<div class="text_task">
		<h3> <?php echo __('Create Custom Fields'); ?></h3>
		<p id="description_task"> <?php echo __('The Recon Task definition of Pandora FMS is used to find new elements in the network. 
		If it detects any item, it will add that item to the monitoring, and if that item it is already being monitored, then it will 
		ignore it or will update its information.There are three types of detection: Based on <strong id="fuerte"> ICMP </strong>(pings), 
		<strong id="fuerte">SNMP</strong> (detecting the topology of networks and their interfaces), and other <strong id="fuerte"> customized </strong>
		type. You can define your own customized recon script.'); ?></p>
		<form action="index.php?sec=gagente&sec2=godmode/agentes/configure_field" method="post">
			<input type="submit" class="button_task" value="<?php echo __('Create Custom Fields'); ?>" />
		</form>
	</div>
</div>