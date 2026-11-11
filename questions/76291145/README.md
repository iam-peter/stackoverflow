# In QML, I cannot get a shortcut for a CheckBox

- **Question:** [stackoverflow.com/q/76291145](https://stackoverflow.com/questions/76291145/in-qml-i-cannot-get-a-shortcut-for-a-checkbox) by [Pietro](https://stackoverflow.com/users/235472/pietro) · May 2023
- **Tags:** `qt` `qml` `qtquick2`
- **My answer:** [answer 76292396](https://stackoverflow.com/questions/76291145/in-qml-i-cannot-get-a-shortcut-for-a-checkbox/76292396#76292396) · accepted · score 3 · May 2023

## Question

In a QML `MenuBar`, the mnemonics for "&File" and "&New..." work, but "&Auto Save"
does not respond to its shortcut. It is a `CheckBox` placed inside the `Menu`, and
moving it to the toolbar did not help (Qt 6.4).

Read the full question on [Stack Overflow](https://stackoverflow.com/questions/76291145/in-qml-i-cannot-get-a-shortcut-for-a-checkbox).

## My answer

No need for a `CheckBox` you can use an `Action` or a `MenuItem` and set the `checkable` property to `true`. A bit strange is that I needed to toggle the `checked` property manually in the `onToggled` or `onTriggered` handler, otherwise the `checked` of both `MenuItem` and `Action` wouldn't change automatically when using the shortcut even though toggled and triggered are called. But it does when clicking on the menu item.

```qml
menuBar: MenuBar {
    Menu {
        title: qsTr("&File")
        Action { text: qsTr("&New...") }

        Action {
            id: autoSaveAction
            checkable: true
            checked: true
            text: qsTr("&Auto Save")
            onToggled: autoSaveAction.checked = !autoSaveAction.checked
        }
    }
}
```

----------

This is probably due to the fact that you would set a setting via the toggle signal and bind that setting to the `checked` property of the `MenuItem`/`Action` as it could be changed from somewhere else instead of binding to the `checked` state of a `MenuItem`/`Action`. Something like that:

```qml
ApplicationWindow {
    id: window
    width: 320
    height: 260
    visible: true

    property bool autoSave: true

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New...") }

            Action {
                id: autoSaveAction
                checkable: true
                checked: window.autoSave
                text: qsTr("&Auto Save")
                onToggled: window.autoSave = !window.autoSave
            }
        }
    }
}
```

## Code in this folder

The second snippet from the answer: a checkable `Action` whose `checked` state is bound to
a property on the window.

| File | Contents |
| --- | --- |
| [`CMakeLists.txt`](CMakeLists.txt) | CMake project |
| [`main.cpp`](main.cpp) | Application entry point |
| [`Main.qml`](Main.qml) | `MenuBar` with the checkable "Auto Save" action |

### Build and run

Requires Qt 6.5 or later with these modules: Qt Quick, Qt Quick Controls.

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=~/Qt/6.x/gcc_64
cmake --build build
./build/appDemo76291145
```
