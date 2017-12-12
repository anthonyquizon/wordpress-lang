
<?
function {{tpl_name}}_remove_menus() {
  {{#items}}
    remove_menu_page('{{item}}');        
  {{/items}}
}

add_action('admin_menu', '{{tpl_name}}_remove_menus');
?>
