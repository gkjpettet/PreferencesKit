#tag Class
Protected Class Preferences
	#tag Method, Flags = &h0
		Sub Constructor(autoSave As Boolean = False)
		  mPreferences = New Dictionary
		  Self.AutoSave = autoSave
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520707265666572656E636573206173204A534F4E2E
		Function Dump() As String
		  ///
		  ' Returns the preferences as JSON.
		  ///
		  
		  If mPreferences <> Nil Then
		    Return GenerateJSON(mPreferences)
		  Else
		    Return "{}"
		  End If
		  
		  Exception err As InvalidArgumentException
		    Raise New PreferencesKit.Error("One or more of the values cannot be converted to a JSON data type")
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652076616C7565206F662074686520706173736564206E616D656420707265666572656E63652E
		Function Get(name As String) As Variant
		  ///
		  ' Returns the value of the passed named preference.
		  '
		  ' - Parameter name: The name of the preference to get.
		  '
		  ' - Returns: The preference's value.
		  '
		  ' - Raises: PreferenceNotFoundException if there is no preference named `name`.
		  '
		  ' - Notes:
		  ' Allows the look up of preferences using this syntax:
		  ' Var top As Integer = Preferences.Get("MainWindowTop")
		  ///
		  
		  If mPreferences.HasKey(name) Then
		    Return mPreferences.Value(name)
		  Else
		    Raise New PreferenceNotFoundException(name)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732054727565206966207468657265206973206120707265666572656E636520776974682074686973206E616D65206F722046616C7365206966206E6F742E
		Function HasKey(key As String) As Boolean
		  ///
		  ' Returns True if there is a preference with this name or False if not.
		  '
		  ' - Parameter key: The key to look up.
		  ///
		  
		  Return mPreferences.HasKey(key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4C6F6164732061204A534F4E20707265666572656E6365732066696C652E2052657475726E732054727565206966207375636365737366756C206F722046616C7365206966206E6F742E
		Function Load(prefsFile As FolderItem) As Boolean
		  ///
		  ' Loads a JSON preferences file.
		  '
		  ' - Parameter prefsFile: The JSON preferences file to load.
		  '
		  ' - Returns: True if the preferences were successfully loaded or False if not.
		  '
		  ' - Notes:
		  ' If `prefsFile` doesn't exist then a new file with an empty JSON 
		  ' object is created.
		  ///
		  
		  If prefsFile = Nil Then
		    Return False
		  Else
		    // Keep a reference.
		    mPreferencesFile = prefsFile
		  End If
		  
		  // If the preferences file doesn't exist then create it.
		  If Not mPreferencesFile.Exists Then
		    Var tout As TextOutputStream = TextOutputStream.Create(mPreferencesFile)
		    tout.Encoding = Encodings.UTF8
		    
		    // Create an empty JSON object (so that the file is valid JSON).
		    tout.Write("{}")
		    
		    tout.Close
		  End If
		  
		  // Open the file for reading.
		  Var tin As TextInputStream = TextInputStream.Open(mPreferencesFile)
		  tin.Encoding = Encodings.UTF8
		  
		  // Get the contents of the file (should be JSON).
		  Var data As String = tin.ReadAll
		  
		  // Close the file.
		  tin.Close
		  
		  // Attempt to parse the contents of the file into a Dictionary.
		  mPreferences = ParseJSON(data)
		  
		  // Done.
		  Return True
		  
		  Exception err As IOException
		    // Unable to create or open the preferences file.
		    Return False
		    
		  Exception err As InvalidJSONException
		    // Unable to parse the contents of the preferences file.
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652076616C7565206F6620746865206E616D656420707265666572656E6365206F722072657475726E73207468652064656661756C742076616C7565207370656369666965642E
		Function Lookup(name As String, default As Variant) As Variant
		  ///
		  ' Returns the value of the named preference or returns the default value specified.
		  '
		  ' - Parameter name: The name of the preference whose value we want.
		  ' - Parameter default: The value to return if there is no preference with the specified name.
		  ///
		  
		  Return mPreferences.Lookup(name, default)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416C6C6F7773207468652072657472696576616C206F66206120707265666572656E6365207573696E672074686520646F74206F70657261746F722E
		Function Operator_Lookup(name As String) As Variant
		  ///
		  ' Allows the retrieval of a preference using the dot operator.
		  '
		  ' - Parameter name: The name of the preference whose value we want.
		  '
		  ' - Returns: The value of the named preference (if it exists).
		  '
		  ' - Raises: PreferenceNotFoundException if there is no preference named `name`.
		  '
		  ' - Notes:
		  ' Allows the look up of a preference using this syntax:
		  ' Dim top As Integer = Preferences.MainWindowTop
		  ///
		  
		  Return Get(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416C6C6F7773207468652073657474696E67206F66206120707265666572656E636527732076616C7565207573696E67207468652061737369676E6D656E74206F70657261746F722E
		Sub Operator_Lookup(name As String, Assigns value As Variant)
		  ///
		  ' Allows the setting of a preference's value using the assignment operator.
		  '
		  ' - Parameter name: The name of the preference whose value should be set. Will be created if required.
		  ' - Parameter : The value.
		  '
		  ' - Notes:
		  ' Sets a preference using this syntax:
		  ' Preferences.MainWindowTop = 345
		  ///
		  
		  Set(name) = value
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53617665732074686520707265666572656E6365732044696374696F6E61727920746F206469736B206173204A534F4E2E2052657475726E732054727565206966207375636365737366756C206F722046616C7365206966206E6F742E
		Function Save() As Boolean
		  ///
		  ' Saves the preferences Dictionary to disk as JSON.
		  '
		  ' - Returns: True if the save was successful or False if not.
		  ///
		  
		  // If we don't have a preferences file then we can't save obviously.
		  If mPreferencesFile = Nil Then Return False
		  
		  // Convert the preferences Dictionary to JSON.
		  Var data As String = GenerateJSON(mPreferences)
		  
		  // Create an output stream to write to.
		  Var tout As TextOutputStream = TextOutputStream.Create(mPreferencesFile)
		  tout.Encoding = Encodings.UTF8
		  
		  // Write the JSON
		  tout.Write(data)
		  
		  // Close the stream.
		  tout.Close
		  
		  // Success.
		  Return True
		  
		  Exception err As InvalidArgumentException
		    // Unable to convert one of the values in the preferences Dictionary to a JSON value
		    Return False
		    
		  Exception err As IOException
		    // Unable to write the preferences to disk.
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41737369676E7320746865207061737365642076616C756520746F2074686520737065636966696564206B65792E20496620746865206B657920646F6573206E6F7420657869737420697420697320637265617465642E
		Sub Set(name As String, Assigns value As Variant)
		  ///
		  ' Assigns the passed value to the specified key. If the key does not exist it is created.
		  '
		  ' - Parameter name: The name of the key to set.
		  ' - Parameter : The value.
		  '
		  ' - Notes:
		  ' Sets a preference using the syntax:
		  ' Preferences.Set("MainWindowTop") = 345
		  ' If `AutoSave` is True then the preferences file on disk will also be updated immediately.
		  ///
		  
		  If mPreferences = Nil Then mPreferences = New Dictionary
		  
		  mPreferences.Value(name) = value
		  
		  If AutoSave Then Call Save
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 49662054727565207468656E20616E79206368616E676573206D61646520746F2074686520707265666572656E6365732077696C6C206265206175746F6D61746963616C6C79207772697474656E20746F206469736B2E
		AutoSave As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206261636B696E672064696374696F6E6172792073746F72696E672074686520707265666572656E6365732E
		Private mPreferences As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652066696C6520746861742074686520707265666572656E6365732077696C6C206265207772697474656E20746F20286173204A534F4E292E
		Private mPreferencesFile As FolderItem
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AutoSave"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
