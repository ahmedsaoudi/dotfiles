# tunisian keyboard layout

this file add the layout for tunisian keyboard to ubuntu. 
tested with: 
- ubuntu 20.04

## how does this work

1. create a link to this file from `/usr/share/X11/xkb/symbols/tn` to this one using this
command: `sudo ln -s ~/dotfiles/tn/tn /usr/share/X11/xkb/symbols/tn`

2. in `/usr/share/X11/xkb/rules/evdev.xml` add the following after any `</layout>`,
   **preferably before the `tr` layout**:

```
<layout>
   <configItem>
     <name>tn</name>
     <shortDescription>tn</shortDescription>
     <description>Tunisian</description>
     <languageList>
       <iso639Id>aeb</iso639Id>
     </languageList>
   </configItem>
   <variantList/>
</layout>
```
