## Firefox

about:config

`toolkit.legacyUserProfileCustomizations.stylesheets` set to `true`

<profile>: help -> More Troubleshooting Information

```bash
cd ~/.mozilla/firefox/<profile>
mkdir chrome
touch chrome/userChrome.css
```

`userChrome.css`

```
#TabsToolbar { visibility: collapse !important; }
```
