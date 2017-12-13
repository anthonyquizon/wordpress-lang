<?
  function template_name_remove_menus() {
      remove_menu_page('foo');
      remove_menu_page('bar');
      remove_menu_page('baz');
  }

  add_action('admin_menu', 'template_name_remove_menus');
?>
