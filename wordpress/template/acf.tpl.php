#lang reader "./../template.rkt"
<?php
function {{tpl_name}}_acf_add_local_field_groups() {
  {{#acf}}
    acf_add_local_field_group(array (
      'key' => '{{key}}',
      'title' => '{{title}}',
      'location' => array (
        array (
          {{#location}}
          array (
            'param' => '{{param}}',
            'operator' => '{{operator}}',
            'value' => '{{value}}'
          ),
          {{/location}}
        ),
      ),
      'fields' => array (
        {{#fields}}
        array(
          'key' => '{{key}}',
          'label' => '{{label}}',
          'name' => '{{name}}',
          'type' => '{{type}}',

          {{#text}}
            'default_value' => '',
            'placeholder' => '',
            'prepend' => '',
            'append' => '',
            'formatting' => 'none',
            'maxlength' => '',
          {{/text}}

          {{#image}}
            'save_format' => 'object',
            'preview_size' => 'thumbnail',
            'library' => 'all',
          {{/image}}
        )
        {{/fields}}
      )
    ));
  {{/acf}}
}

add_action('acf/init', '{{tpl_name}}_acf_add_local_field_groups');
?>

