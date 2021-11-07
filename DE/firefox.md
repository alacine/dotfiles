## Firefox

about:config

`toolkit.legacyUserProfileCustomizations.stylesheets` set to `true`

<profile>: help -> More Troubleshooting Information (或 `about:support`)

```bash
cd ~/.mozilla/firefox/<profile>
mkdir chrome
touch chrome/userChrome.css
```

`userChrome.css`

```css
/*================== TABS BAR ==================*/
#titlebar #TabsToolbar {
  visibility: collapse !important;
}

/* The default sidebar width. */
#sidebar-box {
  overflow: hidden!important;
  position: relative!important;
  transition: all 100ms!important;
  min-width: 40px !important;
  max-width: 300px !important;
}

/* The sidebar width when hovered. */
#sidebar-box #sidebar,#sidebar-box:hover {
  transition: all 100ms!important;
  min-width: 300px !important;
  max-width: 300px !important;
}
```
