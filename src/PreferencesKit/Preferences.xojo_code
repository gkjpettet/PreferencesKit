#tag Class
Protected Class Preferences
	#tag Method, Flags = &h0
		Sub Constructor(autoSave As Boolean = False)
		  mPreferences = New Xojo.Core.Dictionary
		  Self.AutoSave = autoSave
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Get(name As Text) As Auto
		  ' Allow lookup of preference using this syntax:
		  ' Dim top As Integer = Preferences.Get("MainWindowTop")
		  
		  If mPreferences.HasKey(name) Then
		    Return mPreferences.Value(name)
		  Else
		    Raise New PreferenceNotFoundException(name)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasKey(key As Text) As Boolean
		  ' Returns True if there is a preference with this name or False if not.
		  Return mPreferences.HasKey(key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Load(prefsFile As Xojo.IO.FolderItem) As Boolean
		  ' Loads the passed preferences file (which should be valid JSON).
		  ' If `prefsFile` doesn't exist then a new file with an empty JSON 
		  ' object is created.
		  
		  Using Xojo.Core
		  Using Xojo.Data
		  Using Xojo.IO
		  
		  If prefsFile = Nil Then Return False
		  
		  ' Keep a reference to our preferences file.
		  mPreferencesFile = prefsFile
		  
		  ' If the preferences file doesn't exist then create it.
		  If Not mPreferencesFile.Exists Then
		    Dim tout As TextOutputStream
		    tout = TextOutputStream.Create(mPreferencesFile, TextEncoding.UTF8)
		    ' Create an empty JSON object (so that the file is valid JSON).
		    tout.Write("{}")
		    tout.Close
		  End If
		  
		  ' Open the file for reading.
		  Dim tin As TextInputStream
		  tin = TextInputStream.Open(mPreferencesFile, TextEncoding.UTF8)
		  
		  ' Get the contents of the file (should be JSON).
		  Dim data As Text = tin.ReadAll
		  
		  ' Close the file.
		  tin.Close
		  
		  ' Attempt to parse the contents of the file into a Dictionary.
		  mPreferences = ParseJSON(data)
		  return True
		  
		  Exception err As IOException
		    ' Unable to create or open the preferences file.
		    Return False
		    
		  Exception err As InvalidJSONException
		    ' Unable to parse the contents of the preferences file.
		    Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lookup(key As Text, default As Auto) As Auto
		  ' Looks up a preference by its key's name. If it exists then we return its value. 
		  ' If it does not exist then we return the passed `default` value.
		  
		  Return mPreferences.Lookup(key, default)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Lookup(name As Text) As Auto
		  ' Allow lookup of preference using this syntax:
		  ' Dim top As Integer = Preferences.MainWindowTop
		  
		  Return Get(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Lookup(name As Text, Assigns value As Auto)
		  ' Set a preference using this syntax:
		  ' Preferences.MainWindowTop = 345
		  
		  Set(name) = value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Save() As Boolean
		  ' Save the preferences Dictionary to disk as JSON.
		  
		  Using Xojo.Core
		  Using Xojo.Data
		  Using Xojo.IO
		  
		  ' If we don't have a preferences file then we can't save obviously...
		  If mPreferencesFile = Nil Then Return False
		  
		  ' Convert the preferences Dictionary to JSON.
		  Dim data As Text = GenerateJSON(mPreferences)
		  
		  ' Create an output stream to write to.
		  Dim tout As TextOutputStream
		  tout = TextOutputStream.Create(mPreferencesFile, TextEncoding.UTF8)
		  
		  ' Write the JSON
		  tout.Write(data)
		  
		  ' Close the stream.
		  tout.Close
		  
		  ' Success.
		  Return True
		  
		  Exception err As InvalidArgumentException
		    ' Unable to convert one of the values in the preferences Dictionary to a JSON value
		    Return False
		    
		  Exception err As IOException
		    ' Unable to write the preferences to disk.
		    Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Set(name As Text, Assigns value As Auto)
		  ' Set a preference using this syntax:
		  ' Preferences.Set("MainWindowTop") = 345
		  ' If AutoSave is True then the preferences file on disk will also be updated.
		  
		  If mPreferences <> Nil Then
		    mPreferences.Value(name) = value
		    If AutoSave Then Call Save
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AutoSave As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPreferences As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPreferencesFile As Xojo.IO.FolderItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
