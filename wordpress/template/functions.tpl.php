#lang reader "./../template.rkt"
<?php
{{#admin_menu}}
  function {{tpl_name}}_remove_menus() {
    {{#items}}
      remove_menu_page('{{item}}');        
    {{/items}}
  }

  add_action('admin_menu', '{{tpl_name}}_remove_menus');
{{/admin_menu}}

require(get_template_directory() . '/acf.php');
?>
