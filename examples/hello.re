/*
let theme = Theme [
  Init [RemovePostTypeSupport Post Editor]
  AdminMenu [
    RemoveMenuPage Jetpack,
    RemoveMenuPage Edit,
    RemoveMenuPage Comments,
    RemoveMenuPage Themes,
    RemoveMenuPage Plugins,
    RemoveMenuPage Tools,
    RemoveMenuPage GeneralOptions,
  ],
  AddMetaBoxes [
    Metabox "Content" "hello-content" Post [
    ],
  ]
];
*/

Lib.Wordpress.wordpress ();

