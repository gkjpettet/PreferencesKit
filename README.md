# PreferencesKit
A Xojo module for saving and loading application preferences

## About
This class is inspired by [Javier Menendez's preferences example][javier] and [Paul Lefebvre's blog post][paul]. It provides a robust cross-platform way to save and load preferences using a JSON file.

## Installation
Simply copy the `PreferencesKit` module into any Xojo project (console, desktop, iOS).

## Usage
The coolest thing about the `Preferences` class is that it uses the lookup operator overload mechanism to allow you to access the values of properties stored in the JSON preferences file using dot notation. Below gives a basic example of how to use it.

```language-xojo
' Create a preferences object. You should probably make this an App property.
' Note the `True` value passed to the constructor. This will immediately write 
' changes to the preferences file whenever a preference value is changed.
' This defaults to False.
Dim myPreferences As New PreferencesKit.Preferences(True)

' Get the file to use to store the preferences. 
Dim prefsFile As Xojo.IO.FolderItem = Xojo.IO.SpecialFolder.Documents.Child("myprefs.prefs")

' Load the preferences.
If Not myPreferences.Load(prefsFile) Then
  MsgBox("Unable to load preferences!")
  Quit
End If

' Get a value. For example, a username. Remember, the key is case-sensitive.
Dim username As Text = myPreferences.username

' You can obviously set values too. Even if they don't yet exist in the preferences file.
myPreferences.myNewNumber = 105.2

Break

Exception err As PreferencesKit.PreferenceNotFoundException
' This will happen in this example if your preferences file does not contain 
' a key called `username`
Break
```

## How to help
When using `PreferencesKit` in your own applications, if you run into a bug:

1. At bare minimum, raise an issue at [https://github.com/gkjpettet/PreferencesKit/issues].
2.  Better yet, fork the repo, fix the bug and submit a pull request, [https://github/gkjpettet/PreferencesKit/fork].
3.  Best, fork the repo, add a unit test exposing the bug, fix the bug, and then submit a pull request (see #2).

[javier]: https://blog.xojo.com/2018/06/20/create-a-preferences-class-with-operator_lookup
[paul]: https://blog.xojo.com/2014/01/27/saving-preferences