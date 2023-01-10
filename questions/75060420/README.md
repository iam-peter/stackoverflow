Run `lupdate`
```
~/Qt/6.4.0/gcc_64/bin/lupdate . -no-obsolete -locations absolute -ts locale_en.ts locale_de.ts
```

Run `lrelease`
```
~/Qt/6.4.0/gcc_64/bin/lrelease locale_en.ts locale_de.ts
```

Run `lconvert`
```
~/Qt/6.4.0/gcc_64/bin/lconvert -i my_locale_de.ts locale_de.ts -o complete.ts
```